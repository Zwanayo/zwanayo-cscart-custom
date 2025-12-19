<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

use Tygh\Registry;

/**
 * Public logging endpoints hit by the Node service.
 * Examples:
 *   POST /index.php?dispatch=zwa_chat.admin_log&key=XXXX
 *   POST /index.php?dispatch=zwa_chat.log&key=XXXX
 *   Body: {"session":"wa:242044472312","sender":"bot","channel":"whatsapp","message":"Hello!"}
 *
 * Improvements over previous version:
 *  - Accept admin key via header (X-Zwa-Admin-Key | x-api-key | api_key) or ?key=
 *  - Timing‑safe key compare (hash_equals)
 *  - OPTIONS preflight support + CORS headers
 *  - Consistent JSON error bodies + status codes (401/405/415/422)
 *  - Input size guards and UTF‑8 normalization
 */

// ---- Helpers --------------------------------------------------------------

/**
 * Reads the provided admin key from headers or query.
 */
function zwachat_get_provided_key(): string {
    // Common header names we allow
    $candidates = [
        'HTTP_X_ZWA_ADMIN_KEY',
        'HTTP_X_API_KEY',
        'HTTP_API_KEY',
    ];
    foreach ($candidates as $h) {
        if (!empty($_SERVER[$h])) {
            return (string) $_SERVER[$h];
        }
    }
    // Fallback to query param
    if (isset($_REQUEST['key'])) {
        return (string) $_REQUEST['key'];
    }
    return '';
}

/**
 * Returns an array of valid admin keys from addon settings and env.
 */
function zwachat_valid_keys(): array {
    $settings = (array) Registry::get('addons.zwa_chat');

    $keys = array_filter([
        $settings['admin_api_key']        ?? '',
        $settings['admin_api_token']      ?? '',
        $settings['zwachat_admin_api_key']?? '',
        $settings['zwa_admin_api_key']    ?? '',
        $settings['api_key']              ?? '',
        $settings['zwachat_api_key']      ?? '',
        // Environment overrides
        getenv('ZWACHAT_ADMIN_API_KEY')   ?: '',
        getenv('ZWACHAT_API_KEY')         ?: '',
    ]);

    // Optional admin.key file next to CS-Cart root (if present & readable)
    $file = Registry::get('config.dir.root') . '/admin.key';
    if (is_readable($file)) {
        $raw = trim((string) @file_get_contents($file));
        if ($raw !== '') {
            $keys[] = $raw;
        }
    }

    // De-duplicate and keep non-empty
    $keys = array_values(array_unique(array_filter(array_map('strval', $keys))));
    return $keys;
}

/**
 * Constant‑time check whether $provided matches any of $valid.
 */
function zwachat_key_is_valid(string $provided, array $valid): bool {
    if ($provided === '' || empty($valid)) {
        return false;
    }
    foreach ($valid as $k) {
        // Normalize whitespace just in case
        $k = trim($k);
        if ($k !== '' && function_exists('hash_equals')) {
            if (hash_equals($k, $provided)) {
                return true;
            }
        } else {
            // Fallback (older PHP): still do a strict compare
            if ($k === $provided) {
                return true;
            }
        }
    }
    return false;
}

/**
 * Emit a JSON response with code.
 */
function zwachat_json(int $code, array $body = []): void {
    http_response_code($code);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($body, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    exit;
}

/**
 * Basic CORS for Node service calls.
 */
function zwachat_cors(): void {
    // Allow same origin by default; wildcard for simplicity
    header('Access-Control-Allow-Origin: *');
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    header('Access-Control-Allow-Headers: Origin, Content-Type, Authorization, X-Requested-With, X-Zwa-Admin-Key, x-api-key, api_key');
}

// ---- Controller -----------------------------------------------------------

zwachat_cors();

$method = strtoupper($_SERVER['REQUEST_METHOD'] ?? 'GET');

// Preflight
if ($method === 'OPTIONS') {
    // No body needed
    http_response_code(204);
    exit;
}

if ($method !== 'POST') {
    // Expose a small hint on GET/others
    zwachat_json(405, [
        'ok' => false,
        'error' => 'method_not_allowed',
        'allow' => ['POST'],
    ]);
}

if ($mode === 'admin_log' || $mode === 'log') {

    // --- 1) Auth ---
    $provided = zwachat_get_provided_key();
    $valid    = zwachat_valid_keys();

    if (!zwachat_key_is_valid($provided, $valid)) {
        zwachat_json(401, ['ok' => false, 'error' => 'unauthorized']);
    }

    // --- 2) Content-Type & JSON parse ---
    $ct = $_SERVER['CONTENT_TYPE'] ?? '';
    if ($ct && stripos($ct, 'application/json') === false) {
        // Treat as 415 Unsupported Media Type
        zwachat_json(415, ['ok' => false, 'error' => 'unsupported_media_type']);
    }

    $raw  = file_get_contents('php://input') ?: '';
    $data = json_decode($raw, true);
    if (!is_array($data)) {
        zwachat_json(422, ['ok' => false, 'error' => 'invalid_json']);
    }

    // --- 3) Extract fields with guards ---
    $session = (string) ($data['session'] ?? '');
    $sender  = (string) ($data['sender']  ?? 'system');
    $channel = (string) ($data['channel'] ?? 'whatsapp');
    $text    = (string) ($data['message'] ?? ($data['text'] ?? ''));

    if ($session === '') {
        $phone = (string) ($data['phone'] ?? ($data['to'] ?? ''));
        $session = $phone ? ('wa:' . preg_replace('/\D+/', '', $phone)) : ('anon:' . uniqid('', true));
    }

    // Size limits (avoid DB bloat)
    if (strlen($session) > 128) { $session = substr($session, 0, 128); }
    if (strlen($sender)  > 64)  { $sender  = substr($sender,  0, 64); }
    if (strlen($channel) > 64)  { $channel = substr($channel, 0, 64); }
    if (strlen($text)    > 4000){ $text    = substr($text,    0, 4000); }

    // Ensure UTF‑8
    if (!mb_detect_encoding($text, 'UTF-8', true)) {
        $text = mb_convert_encoding($text, 'UTF-8');
    }

    // --- 4) Persist ---
    if (function_exists('fn_zwa_chat_log_message_compact')) {
        fn_zwa_chat_log_message_compact($session, $sender, $channel, $text);
    }

    // --- 5) Respond ---
    zwachat_json(200, ['ok' => true]);
}

// Unknown mode for this controller
return [CONTROLLER_STATUS_NO_PAGE];
