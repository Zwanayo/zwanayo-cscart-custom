<?php

/**
 * Executes a callable within a safe error-handling block.
 * If an exception or error occurs, logs the error (if logging is available)
 * and returns the provided default value.
 *
 * @param callable $fn      Function to execute safely.
 * @param mixed    $default Value to return if an error occurs.
 * @return mixed            Return value of $fn(), or $default if an error is thrown.
 */
function zwa_safe(callable $fn, $default = null) {
    try {
        return $fn();
    } catch (Throwable $e) {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg' => 'ZwaChat error: ' . $e->getMessage(),
                'trace' => $e->getTraceAsString(),
            ]);
        }
        return $default;
    }
}
use Tygh\Registry;
if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * Send CORS headers to allow AJAX requests from the storefront.
 */
function fn_zwa_chat_send_cors()
{
    // Allow all origins (adjust as needed)
    header('Access-Control-Allow-Origin: *');
    // Allow common HTTP methods
    header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
    // Allow necessary headers for AJAX
    header('Access-Control-Allow-Headers: Content-Type, X-Requested-With');
    // If this is a preflight request, exit immediately
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        exit;
    }
}

/**
 * Ensure required tables exist (idempotent).
 */
function fn_zwa_chat_ensure_tables()
{
    $pfx = Tygh\Registry::get('config.table_prefix');

    // Messages table
    db_query("
        CREATE TABLE IF NOT EXISTS `{$pfx}zwa_chat_messages` (
            `message_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
            `entry_id` VARCHAR(64) NOT NULL,
            `sender_phone` VARCHAR(32) DEFAULT NULL,
            `message_text` TEXT,
            `status` VARCHAR(16) DEFAULT 'open',
            `response_time` INT DEFAULT NULL,
            `created_at` DATETIME NOT NULL,
            `updated_at` DATETIME DEFAULT NULL,
            PRIMARY KEY (`message_id`),
            KEY `entry_id_idx` (`entry_id`),
            KEY `created_idx` (`created_at`),
            KEY `status_idx` (`status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");

    // Sessions table (summary per entry)
    db_query("
        CREATE TABLE IF NOT EXISTS `{$pfx}zwa_chat_sessions` (
            `session_id` VARCHAR(64) NOT NULL,
            `user_phone` VARCHAR(32) DEFAULT NULL,
            `status` VARCHAR(16) NOT NULL DEFAULT 'open',
            `last_activity` DATETIME NOT NULL,
            `last_message` TEXT,
            PRIMARY KEY (`session_id`),
            KEY `last_activity_idx` (`last_activity`),
            KEY `status_idx` (`status`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ");
}

/**
 * Upsert a session row with latest activity/message.
 */
function fn_zwa_chat_upsert_session($session_id, $user_phone, $last_message, $status = 'open')
{
    $now = date('Y-m-d H:i:s');
    db_query("REPLACE INTO ?:zwa_chat_sessions ?e", [
        'session_id'    => (string) $session_id,
        'user_phone'    => (string) $user_phone,
        'status'        => (string) $status,
        'last_activity' => $now,
        'last_message'  => (string) $last_message,
    ]);
}

/**
 * Read a ZwaChat addon setting with a default.
 *
 * @param string $key     Setting key under addons.zwa_chat.*
 * @param mixed  $default Default value if not set or empty
 * @return mixed
 */

function fn_zwa_chat_setting($key, $default = null)
{
    $val = Registry::get('addons.zwa_chat.' . $key);
    return (isset($val) && $val !== '') ? $val : $default;
}

/**
 * Resolve the Admin API key from various possible setting names, with fallback to the general API key.
 *
 * Checks, in order:
 *  - addons.zwa_chat.admin_api_key
 *  - addons.zwa_chat.admin_api_token
 *  - addons.zwa_chat.admin_key
 * Fallback: addons.zwa_chat.api_key
 *
 * @return string Admin API key or empty string if none configured.
 */
function fn_zwa_chat_admin_api_key()
{
    // Primary explicit admin key names
    $candidates = [
        'addons.zwa_chat.admin_api_key',
        'addons.zwa_chat.admin_api_token',
        'addons.zwa_chat.admin_key',
    ];

    foreach ($candidates as $path) {
        $val = Registry::get($path);
        if (is_string($val) && $val !== '') {
            return $val;
        }
    }

    // Fallback to the general api_key if present
    $fallback = Registry::get('addons.zwa_chat.api_key');
    return (is_string($fallback) && $fallback !== '') ? $fallback : '';
}

/**
 * Build a small config payload for templates/controllers.
 *
 * Returns:
 *  - api_url (string)
 *  - widget_url (string)
 *  - api_key_set (bool)
 *  - admin_api_key_set (bool)
 *
 * @return array
 */
function fn_zwa_chat_get_public_config()
{
    $api_url   = fn_zwa_chat_setting('api_url', '');
    $widget_url = fn_zwa_chat_setting('widget_url', '/zwa_chat/index.html'); // safe default
    $api_key   = fn_zwa_chat_setting('api_key', '');
    $admin_key = fn_zwa_chat_admin_api_key();

    return [
        'api_url'            => (string) $api_url,
        'widget_url'         => (string) $widget_url,
        'api_key_set'        => (bool) $api_key,
        'admin_api_key_set'  => (bool) $admin_key,
    ];
}

/**
 * Returns the total number of chat messages in the system.
 *
 * Uses zwa_safe() to handle database errors gracefully.
 *
 * @return int Total count of messages. Returns 0 on error.
 */
function fn_zwa_chat_get_total_messages()
{
    return zwa_safe(function() {
        return (int) db_get_field("SELECT COUNT(*) FROM ?:zwa_chat_logs");
    }, 0);
}

/**
 * Returns the number of open (active) chat sessions.
 *
 * Counts distinct entry IDs where status is 'open'.
 * Uses zwa_safe() to handle errors.
 *
 * @return int Number of open chat sessions. Returns 0 on failure.
 */
function fn_zwa_chat_get_open_chats()
{
    return zwa_safe(function() {
        return (int) db_get_field(
            "SELECT COUNT(DISTINCT session_id) FROM ?:zwa_chat_logs WHERE wa_status = ?s",
            'open'
        );
    }, 0);
}

/**
 * Returns the number of resolved (closed) chat sessions.
 *
 * Counts distinct entry IDs where status is 'closed'.
 * Uses zwa_safe() for error handling.
 *
 * @return int Number of closed chat sessions. Returns 0 on failure.
 */
function fn_zwa_chat_get_resolved_chats()
{
    return zwa_safe(function() {
        return (int) db_get_field(
            "SELECT COUNT(DISTINCT session_id) FROM ?:zwa_chat_logs WHERE wa_status = ?s",
            'closed'
        );
    }, 0);
}

/**
 * Calculates the average response time across all messages with a response_time value.
 *
 * Uses zwa_safe() for error handling.
 *
 * @return string Average response time formatted as 'Xm Ys'. Returns '0s' if unavailable or on error.
 */
function fn_zwa_chat_get_avg_response_time()
{
    // No response_time in zwa_chat_logs, so always return '0s'
    return '0s';
}

/**
 * Retrieves a list of recent chat messages, ordered by creation time (descending).
 * Supports optional filters and returns fields expected by admin templates.
 *
 * @param int         $limit  Number of messages to retrieve (default 20).
 * @param string      $q      Optional search keyword.
 * @param string      $status Optional status filter.
 * @param string|null $from   Optional start date filter.
 * @param string|null $to     Optional end date filter.
 * @return array              Array of recent messages (each with message_id, chat_id, sender, message, timestamp).
 *                            Returns empty array on error.
 */
function fn_zwa_chat_get_recent_messages($limit = 20, $q = '', $status = '', $from = null, $to = null)
{
    return zwa_safe(function() use ($limit, $q, $status, $from, $to) {
        $conds = [];
        $conds[] = "session_id IS NOT NULL AND session_id <> ''";
        $conds[] = "message IS NOT NULL AND message <> ''";

        if ($q !== '') {
            $like = '%' . $q . '%';
            $conds[] = db_quote("(session_id LIKE ?l OR sender LIKE ?l OR message LIKE ?l)", $like, $like, $like);
        }
        if ($status !== '') {
            $conds[] = db_quote("wa_status = ?s", $status);
        }
        if (!empty($from)) {
            $conds[] = db_quote("DATE(created_at) >= ?s", $from);
        }
        if (!empty($to)) {
            $conds[] = db_quote("DATE(created_at) <= ?s", $to);
        }

        $where = $conds ? (' WHERE ' . implode(' AND ', $conds)) : '';

        $sql = "
            SELECT
                id AS message_id,
                session_id,
                session_id AS chat_id,
                sender,
                message,
                DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') AS timestamp
            FROM ?:zwa_chat_logs
            {$where}
            ORDER BY created_at DESC
            LIMIT ?i
        ";

        return db_get_array($sql, $limit);
    }, []);
}
/**
 * Returns recent chat sessions from the sessions summary table.
 * Shape matches the admin Sessions tab expectations.
 *
 * @param int $limit
 * @return array
 */
function fn_zwa_chat_get_recent_sessions($limit = 20)
{
    return zwa_safe(function() use ($limit) {
        return db_get_array(
            "SELECT
                session_id,
                session_id AS chat_id,
                user_phone,
                DATE_FORMAT(last_activity, '%Y-%m-%d %H:%i:%s') AS last_activity,
                last_message,
                status
             FROM ?:zwa_chat_sessions
             ORDER BY last_activity DESC
             LIMIT ?i",
            (int) $limit
        );
    }, []);
}

/**
 * Register hooks to clear cache on add-on status change.
 */
fn_register_hooks(
    'update_addon_status_pre',
    'update_addon_status_post',
    'index:footer',
    'place_order'
);

/**
 * Clear cache before the Zwa Chat add-on status is changed.
 */
function fn_zwa_chat_update_addon_status_pre($addon, $status, $show_notification, $on_install, $allow_unmanaged, $old_status, $scheme_version) {
    if ($addon === 'zwa_chat') {
        fn_clear_cache();
    }
}


/**
 * Handle outgoing chat messages for ZwaChat.
 *
 * @param string $message The incoming user message.
 * @return string The reply to send back.
 */
function fn_zwa_chat_handle_outgoing($message)
{
    $api_url = fn_zwa_chat_setting('api_url');
    $api_key = fn_zwa_chat_setting('api_key');

    if (empty($api_url) || empty($api_key)) {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg' => 'Missing ZwaChat API configuration (api_url or api_key).',
                'api_url' => $api_url,
                'has_key' => !empty($api_key),
            ]);
        }
        return 'ZwaChat is not configured yet.';
    }

    $payload = json_encode(['message' => $message, 'api_key' => $api_key]);

    $ch = curl_init($api_url);
    curl_setopt_array($ch, [
        CURLOPT_HTTPHEADER     => [
            'Content-Type: application/json',
            "Authorization: Bearer {$api_key}"
        ],
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => $payload,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 10,
    ]);
    $response = curl_exec($ch);
    $curl_errno = curl_errno($ch);
    $curl_error = curl_error($ch);
    $http_code  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($curl_errno) {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg' => 'cURL error calling outgoing API',
                'errno' => $curl_errno,
                'error' => $curl_error,
            ]);
        }
        return 'Sorry, ZwaChat is temporarily unavailable.';
    }

    if ($http_code >= 400) {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg' => 'Outgoing API returned HTTP error',
                'status' => $http_code,
                'body' => $response,
            ]);
        }
    }

    $data = json_decode($response, true);
    return $data['reply'] ?? 'Sorry, no reply.';
}

/**
 * Clear cache after the Zwa Chat add-on status has been changed.
 */
function fn_zwa_chat_update_addon_status_post($addon, $status, $show_notification, $on_install, $allow_unmanaged, $old_status, $scheme_version) {
    if ($addon === 'zwa_chat') {
        fn_clear_cache();
    }
}

/**
 * Handle a delivery/read status update.
 *
 * @param array $status  Status payload from WhatsApp.
 */
function fn_zwa_chat_handle_status(array $status)
{
    if (empty($status['id']) || empty($status['status'])) {
        fn_log_event('zwa_chat', 'error', [
                     'msg'  => 'Invalid status payload',
                     'data' => $status
                     ]);
        return;
    }
    
    $message_id = $status['id'];
    $new_status = $status['status']; // e.g. 'delivered', 'read'
    $ts         = isset($status['timestamp']) ? date('Y-m-d H:i:s', (int)$status['timestamp']) : fn_date('Y-m-d H:i:s');
    
    db_query(
    'UPDATE ?:zwa_chat_messages SET ?u WHERE message_id = ?s',
    ['status' => $new_status, 'updated_at' => $ts],
    $message_id
    );
    
    fn_log_event('zwa_chat', 'status_updated', [
    'message_id' => $message_id,
    'status'     => $new_status
    ]);
    }
    
    /**
     * Send a WhatsApp text notification for an order event.
     *
     * @param int    $order_id     Order identifier.
     * @param string $status_to    New order status code.
     * @param string $status_from  Previous order status code.
     */
function fn_zwa_chat_send_order_notification($order_id, $status_to, $status_from)
{
    // Prevent duplicate notifications
    static $sent = [];
    $key = "{$order_id}_{$status_to}";
    if (isset($sent[$key])) {
        return;
    }
    $sent[$key] = true;

    $order = fn_get_order_info($order_id);
    $user_data = (isset($order['user_data']) && is_array($order['user_data'])) ? $order['user_data'] : [];

    $phone_primary    = $user_data['phone']    ?? '';
    $phone_ud_billing = $user_data['b_phone']  ?? '';
    $phone_ud_ship    = $user_data['s_phone']  ?? '';
    $order_b_phone    = $order['b_phone']      ?? '';
    $order_s_phone    = $order['s_phone']      ?? '';

    $to = $phone_primary
        ?: $phone_ud_billing
        ?: $phone_ud_ship
        ?: $order_b_phone
        ?: $order_s_phone
        ?: '';

    if (empty($to)) {
        fn_log_event('zwa_chat', 'error', [
                     'msg'      => 'No phone on order',
                     'order_id' => $order_id
                     ]);
        return;
    }

    $phone_id = '642156998990283';
    $template_name = 'order_confirmation';
    $language_code = 'en';

    $token = Registry::get('addons.zwa_chat.whatsapp_access_token');
    $endpoint = "https://graph.facebook.com/v19.0/{$phone_id}/messages";
    $status_name = fn_get_status_data($status_to, STATUSES_ORDER, CART_LANGUAGE)['description'] ?? $status_to;

    $payload = [
        'messaging_product' => 'whatsapp',
        'to' => $to,
        'type' => 'template',
        'template' => [
            'name' => $template_name,
            'language' => [ 'code' => $language_code ],
            'components' => [
                [
                    'type' => 'body',
                    'parameters' => [
                        [ 'type' => 'text', 'text' => $order['firstname'] ?? 'Client' ],
                        [ 'type' => 'text', 'text' => (string) $order_id ],
                        [ 'type' => 'text', 'text' => fn_format_price($order['total'], CART_PRIMARY_CURRENCY) ]
                    ]
                ]
            ]
        ]
    ];

    $ch = curl_init($endpoint);
    curl_setopt_array($ch, [
        CURLOPT_HTTPHEADER     => [
            "Authorization: Bearer {$token}",
            'Content-Type: application/json'
        ],
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => json_encode($payload),
        CURLOPT_RETURNTRANSFER => true,
    ]);
    $response = curl_exec($ch);

    $http_code  = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curl_error = curl_error($ch);

    curl_close($ch);

    fn_log_event('zwa_chat', 'order_notification_sent', [
        'order_id' => $order_id,
        'response' => $response
    ]);
}
    
    /**
     * Hook after order placement.
     */
    function fn_zwa_chat_order_placement_routines($order_id, $action, $order_status)
    {
        // Notification handled in fn_zwa_chat_change_order_status_pre
    }
    
    /**
     * Hook before order status change.
     */
    function fn_zwa_chat_change_order_status_pre($status_to, $status_from, $order_info, $force_notification, $order_id)
    {
        fn_zwa_chat_send_order_notification($order_id, $status_to, $status_from);
    }
    /**
     * Hook: index:footer
     * Injects ZwaChat launcher/iframe into the storefront footer.
     */
    function fn_zwa_chat_index_footer(&$view)
    {
        // Note: use HEREDOC or echo strings so you don’t run into quoting issues
        echo <<<HTML
    <!-- ZwaChat Launcher -->
    <style>
    #zwa-launcher {
      position: fixed;
      bottom: 30px; right: 30px;
      width: 60px; height: 60px;
      background: #24488e;
      color: #fff;
      border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-size: 32px;
      box-shadow: 0 2px 12px rgba(0,0,0,0.18);
      cursor: pointer;
      z-index: 11000;
      transition: background 0.2s;
    }
    #zwa-launcher:hover { background: #2c9a5f; }
    #zwa-iframe-wrap {
      display: none;
      position: fixed;
      bottom: 30px; right: 30px;
      z-index: 11000;
    }
    #zwa-iframe-wrap.active { display: block; }
    #zwa-iframe-close {
      position: absolute; top: 8px; right: 12px;
      background: transparent;
      border: none;
      font-size: 22px; color: #888;
      cursor: pointer;
      z-index: 11001;
    }
    @media (max-width: 600px) {
      #zwa-iframe-wrap iframe {
        width: 100vw !important;
        height: 96vh !important;
        right: 0 !important;
        bottom: 0 !important;
        border-radius: 0 !important;
      }
      #zwa-iframe-wrap {
        right: 0;
        bottom: 0;
      }
      #zwa-launcher {
        bottom: 16px; right: 16px;
        width: 52px; height: 52px;
        font-size: 26px;
      }
    }
    </style>

    <div id="zwa-launcher" title="Chat with Zwanayo">💬</div>
    <div id="zwa-iframe-wrap">
      <button id="zwa-iframe-close">&times;</button>
      <iframe src="/zwa_chat/index.html"
        style="width: 400px; height: 600px; border: none; border-radius: 16px; box-shadow: 0 2px 18px rgba(0,0,0,0.2);">
      </iframe>
    </div>
    <script>
      (function() {
        var launcher = document.getElementById('zwa-launcher');
        var wrap     = document.getElementById('zwa-iframe-wrap');
        var closeBtn = document.getElementById('zwa-iframe-close');
        launcher.onclick = function() {
          wrap.classList.add('active');
          launcher.style.display = 'none';
        };
        closeBtn.onclick = function() {
          wrap.classList.remove('active');
          launcher.style.display = 'flex';
        };
      })();
    </script>
    HTML;
    }

/**
 * Hook triggered after placing an order.
 *
 * @param int   $order_id
 * @param string $action
 * @param string $order_status
 * @param array  $cart
 * @param array  $auth
 */
function fn_zwa_chat_place_order($order_id, $action, $order_status, $cart, $auth)
{
    fn_log_event('zwa_chat', 'place_order_hook', [
        'msg' => 'fn_zwa_chat_place_order triggered',
        'order_id' => $order_id,
        'status' => $order_status
    ]);
    // Use the existing order notification logic
    fn_zwa_chat_send_order_notification($order_id, $order_status, '');
}

/**
 * Handle incoming WhatsApp webhook message.
 *
 * @param array $payload Decoded message payload.
 */
function fn_zwa_chat_handle_incoming($payload)
{
    // 1) Make sure tables exist
    fn_zwa_chat_ensure_tables();

    // 2) Extract essentials from flattened WA payload (already parsed upstream)
    $from = (string) ($payload['from'] ?? '');
    $message_text = (string) ($payload['text']['body'] ?? '');
    $entry_id = $from !== '' ? $from : (string) ($payload['id'] ?? '');
    $now = date('Y-m-d H:i:s');

    if ($entry_id !== '' && $message_text !== '') {
        // 3) Persist incoming message
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'entry_id'     => $entry_id,
            'sender_phone' => $from,
            'message_text' => $message_text,
            'status'       => 'open',
            'created_at'   => $now,
            'updated_at'   => $now,
            'direction'    => 'in',
        ]);

        // 4) Upsert/refresh session summary
        fn_zwa_chat_upsert_session($entry_id, $from, $message_text, 'open');
    } else {
        // Log malformed payload and return early
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg'     => 'Invalid incoming payload structure (missing from/text)',
                'payload' => $payload
            ]);
        }
        return;
    }

    // 5) Auto-reply via WhatsApp API (existing behavior)
    $token = getenv('WHATSAPP_ACCESS_TOKEN') ?: Tygh\Registry::get('addons.zwa_chat.whatsapp_access_token');
    $phone_number_id = getenv('WHATSAPP_PHONE_NUMBER_ID') ?: Tygh\Registry::get('addons.zwa_chat.whatsapp_account_id');

    if (empty($token) || empty($phone_number_id)) {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg'     => 'Missing WhatsApp access token or phone number ID',
                'payload' => $payload
            ]);
        }
        return;
    }

    $reply_text = "Thanks for your message! You said: \"{$message_text}\"";
    $endpoint = "https://graph.facebook.com/v19.0/{$phone_number_id}/messages";
    $postData = [
        'messaging_product' => 'whatsapp',
        'to'                => $from,
        'type'              => 'text',
        'text'              => [ 'body' => $reply_text ],
    ];

    $ch = curl_init($endpoint);
    curl_setopt_array($ch, [
        CURLOPT_HTTPHEADER     => [
            "Authorization: Bearer {$token}",
            'Content-Type: application/json'
        ],
        CURLOPT_POST           => true,
        CURLOPT_POSTFIELDS     => json_encode($postData),
        CURLOPT_RETURNTRANSFER => true,
    ]);
    $response  = curl_exec($ch);
    $status    = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $curl_error= curl_error($ch);
    curl_close($ch);

    // Optional: store outgoing bot reply as a message for completeness
    if ($status >= 200 && $status < 300 && $reply_text !== '') {
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'entry_id'     => $entry_id,
            'sender_phone' => '',              // bot/system
            'message_text' => $reply_text,
            'status'       => 'open',
            'created_at'   => date('Y-m-d H:i:s'),
            'updated_at'   => date('Y-m-d H:i:s'),
        ]);
        fn_zwa_chat_upsert_session($entry_id, $from, $reply_text, 'open');
    }

    if ($curl_error) {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'error', [
                'msg'     => 'cURL error sending WhatsApp reply',
                'error'   => $curl_error,
                'payload' => $payload
            ]);
        }
    } else {
        if (function_exists('fn_log_event')) {
            fn_log_event('zwa_chat', 'whatsapp_reply_sent', [
                'http_status' => $status,
                'response'    => $response,
                'payload'     => $payload
            ]);
        }
    }
}


/**
 * Set ZwaChat user context into session.
 *
 * @param array $context
 * @return void
 */
function fn_zwa_chat_set_context(array $context)
{
    $_SESSION['zwa_chat_context'] = $context;
}

/**
 * Get ZwaChat user context from session.
 *
 * @return array
 */
function fn_zwa_chat_get_context()
{
    return $_SESSION['zwa_chat_context'] ?? [];
}

/**
 * REST endpoint to process chatbot messages (to be called by Node/WhatsApp).
 * Example: index.php?dispatch=zwa_chat.api
 */
function fn_zwa_chat_api()
{
    header('Content-Type: application/json');
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['error' => 'Method Not Allowed']);
        exit;
    }

    $input = json_decode(file_get_contents('php://input'), true);
    if (empty($input['message']) || empty($input['api_key'])) {
        http_response_code(400);
        echo json_encode(['error' => 'Missing parameters']);
        exit;
    }

    $stored_key = Registry::get('addons.zwa_chat.api_key');
    if ($input['api_key'] !== $stored_key) {
        http_response_code(401);
        echo json_encode(['error' => 'Unauthorized']);
        exit;
    }

    $message = $input['message'];
    $reply = fn_zwa_chat_handle_outgoing($message);

    // Optional: log detected intent for analytics
    fn_log_event('zwa_chat', 'chat_intent', ['message' => $message, 'reply' => $reply]);

    echo json_encode(['reply' => $reply]);
    exit;
}
function fn_zwa_chat_get_recent_chats($params = []) {
    $limit = !empty($params['limit']) ? (int) $params['limit'] : 20;
    $status = $params['status'] ?? 'all';
    $q      = $params['q'] ?? '';
    $from   = $params['from'] ?? null;
    $to     = $params['to'] ?? null;

    // Query from zwa_chat_sessions for recent chats
    $sql = "SELECT
        session_id,
        session_id AS chat_id,
        user_phone,
        DATE_FORMAT(last_activity, '%Y-%m-%d %H:%i:%s') AS last_activity,
        last_message,
        status
        FROM ?:zwa_chat_sessions";

    $conditions = [];
    if ($status !== 'all') {
        $conditions[] = db_quote("status = ?s", $status);
    }
    if (!empty($q)) {
        $conditions[] = db_quote("(session_id LIKE ?l OR user_phone LIKE ?l)", "%{$q}%", "%{$q}%");
    }
    if ($from) {
        $conditions[] = db_quote("DATE(last_activity) >= ?s", $from);
    }
    if ($to) {
        $conditions[] = db_quote("DATE(last_activity) <= ?s", $to);
    }
    if (!empty($conditions)) {
        $sql .= " WHERE " . implode(' AND ', $conditions);
    }

    $sql .= " ORDER BY last_activity DESC LIMIT ?i";
    return db_get_array($sql, $limit);
}
/**
 * Returns data for the ZwaChat admin dashboard.
 *
 * @return array
 */
function fn_zwa_get_dashboard_stats()
{
    // Total messages created today from zwa_chat_logs
    $total_today = (int) db_get_field(
        "SELECT COUNT(*) FROM ?:zwa_chat_logs WHERE DATE(created_at) = CURDATE()"
    );

    // Active (open) sessions from the sessions table
    $active = (int) db_get_field(
        "SELECT COUNT(*) FROM ?:zwa_chat_sessions WHERE status = 'open'"
    );

    // Average response time not available
    $avg_response_time = 'N/A';

    // No zcredit yet in current schema
    $zcredit = 0;

    return [
        'total_today'       => $total_today,
        'active'            => $active,
        'avg_response_time' => $avg_response_time,
        'zcredit'           => $zcredit,
    ];
}

/**
 * List conversations from ?:zwa_chat_conversations (admin view).
 *
 * @param array $params
 * @return array (conversations, search)
 */
function fn_zwa_chat_list_conversations($params = [])
{
    $default = [
        'limit'  => 20,
        'status' => 'all',
    ];
    $params = array_merge($default, $params);

    $condition = '';
    if ($params['status'] === 'open' || $params['status'] === 'closed') {
        $condition = db_quote(" AND status = ?s", $params['status']);
    }

    $chats = db_get_array(
        "SELECT id, wa_id, status, FROM_UNIXTIME(start_time) AS start_time"
        . " FROM ?:zwa_chat_conversations WHERE 1=1 ?p ORDER BY start_time DESC LIMIT ?i",
        $condition,
        $params['limit']
    );

    $search = [
        'items_per_page' => $params['limit'],
        'status'         => $params['status'],
    ];

    return [$chats, $search];
}

/**
 * @deprecated Use fn_zwa_chat_list_conversations() instead.
 */
function fn_zwa_get_recent_chats($params = [])
{
    return fn_zwa_chat_list_conversations($params);
}
function fn_zwa_chat_touch_session($phone) {
    // Normalize phone to digits only for consistent matching
    $phone = preg_replace('/\D+/', '', (string) $phone);
    if ($phone === '') {
        return 0;
    }

    // Use the normalized phone as the session_id (string PK)
    $session_id = $phone;
    $now = date('Y-m-d H:i:s');

    // Upsert-like logic using REPLACE
    db_query("REPLACE INTO ?:zwa_chat_sessions ?e", [
        'session_id'    => (string) $session_id,
        'user_phone'    => (string) $phone,
        'status'        => 'open',
        'last_activity' => $now,
        // keep last_message as-is on REPLACE if needed; here we don't set it
    ]);

    return $session_id;
}

function fn_zwa_chat_add_message($session_id, $sender, $message, $channel = 'whatsapp', $direction = 'out') {
    // session_id here maps to `entry_id` in the messages table
    $entry_id = (string) $session_id;
    $sender_phone = preg_replace('/\D+/', '', (string) $sender);
    $text = (string) $message;
    $now = date('Y-m-d H:i:s');

    // Fallback: if session_id is empty but sender looks like a phone, use it as the session/entry id
    if ($entry_id === '' && $sender_phone !== '') {
        $entry_id = $sender_phone;
    }
    // If we still have no entry id, do not insert an orphan record
    if ($entry_id === '') {
        return;
    }

    // Insert message in the unified schema
    db_query("INSERT INTO ?:zwa_chat_messages ?e", [
        'entry_id'     => $entry_id,
        'sender_phone' => $sender_phone ?: null,
        'message_text' => $text,
        'status'       => 'open',
        'created_at'   => $now,
        'updated_at'   => $now,
    ]);

    // Update/insert session summary row
    fn_zwa_chat_upsert_session($entry_id, $sender_phone, $text, 'open');
}
/**
 * Retrieves all chat messages for a specific chat session (entry_id).
 *
 * Uses zwa_safe() to handle errors gracefully.
 *
 * @param string|int $session_id Session identifier (entry_id).
 * @return array                 Array of messages for the session, each with message_id, sender, message, timestamp.
 *                               Returns empty array on error or if session not found.
 */
function fn_zwa_chat_get_session_messages($session_id)
{
    return zwa_safe(function() use ($session_id) {
        return db_get_array(
            "SELECT
                id AS message_id,
                sender,
                message,
                DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') AS timestamp
             FROM ?:zwa_chat_logs
             WHERE session_id = ?s
             ORDER BY created_at ASC",
            $session_id
        );
    }, []);
}
/**
 * Fetch list of conversations with last message & unread count.
 */
function fn_zwa_chat_get_conversations($params = [], $items_per_page = 20)
{
    // Summarize conversations from zwa_chat_sessions with latest message from zwa_chat_logs
    $conversations = db_get_array(
        "SELECT 
            s.session_id AS conversation_id,
            s.user_phone,
            s.status,
            s.last_activity,
            s.last_message,
            l.sender AS last_sender,
            l.message AS last_message_text,
            l.created_at AS timestamp
         FROM ?:zwa_chat_sessions AS s
         LEFT JOIN ?:zwa_chat_logs AS l ON l.id = (
            SELECT id FROM ?:zwa_chat_logs WHERE session_id = s.session_id ORDER BY created_at DESC LIMIT 1
         )
         ORDER BY s.last_activity DESC
         LIMIT ?i",
        $items_per_page
    );

    $total = db_get_field("SELECT COUNT(*) FROM ?:zwa_chat_sessions");

    $search = [
        'total_items'    => (int) $total,
        'items_per_page' => $items_per_page,
    ];

    return [$conversations, $search];
}

/**
 * Fetch messages for a specific conversation/session for AJAX admin panel.
 * Returns JSON for /index.php?dispatch=zwa_chat.get_messages&session_id=...
 */
function fn_zwa_chat_get_messages()
{
    header('Content-Type: application/json');
    $session_id = $_REQUEST['session_id'] ?? '';
    if (!$session_id) {
        echo json_encode(['ok' => false, 'error' => 'Missing session_id']);
        exit;
    }
    $messages = db_get_array(
        "SELECT 
            id AS message_id,
            sender,
            message AS text,
            channel,
            DATE_FORMAT(created_at, '%Y-%m-%d %H:%i:%s') AS timestamp
         FROM ?:zwa_chat_logs
         WHERE session_id = ?s
         ORDER BY created_at ASC",
        $session_id
    );
    echo json_encode(['ok' => true, 'messages' => $messages]);
    exit;
}

/**
 * Insert a new admin message into a conversation.
 */
function fn_zwa_chat_send_message($conversation_id, $text, $sender = 'admin', $channel = 'site')
{
    $now = date('Y-m-d H:i:s');
    $data = [
        'session_id'    => $conversation_id,
        'sender'        => $sender,
        'message'       => $text,
        'channel'       => $channel,
        'created_at'    => $now,
    ];

    db_query("INSERT INTO ?:zwa_chat_logs ?e", $data);
    $message_id = db_get_last_insert_id();

    return db_get_row(
        "SELECT id AS message_id, sender, message AS text, channel, created_at AS timestamp
         FROM ?:zwa_chat_logs
         WHERE id = ?i",
        $message_id
    );
}
?>
