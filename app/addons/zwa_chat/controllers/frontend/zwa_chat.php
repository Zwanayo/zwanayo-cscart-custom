<?php
// File: app/addons/zwa_chat/controllers/frontend/zwa_chat.php

// use Tygh\Registry;
use ZwaChat\SignatureValidator;

require_once __DIR__ . '/../../lib/SignatureValidator.php';
require_once __DIR__ . '/../../func.php';

/**
 * ZwaChat Bot logic
 */
class Bot
{
    /**
     * Main entry point for chat API
     *
     * @param string $message User message
     * @param string $phone   User phone number (for context/auth)
     * @return array|string   JSON-serializable response or HTML
     */
    public static function respond($message, $phone)
    {
        $message = trim($message);
        // Intent detection
        if (preg_match('/\b(browse|product|shop|acheter|achat|produit)\b/i', $message)) {
            return self::handleBrowseIntent($message);
        }
        // Entity fetch (#123, order #, etc.)
        if (preg_match_all('/(\w+)\s+#?(\d+)/i', $message, $matches, PREG_SET_ORDER)) {
            $reply = [];
            foreach ($matches as $m) {
                $reply[] = self::fetchEntityByKeyAndId(strtolower($m[1]), (int)$m[2]);
            }
            return ['text' => implode("\n", $reply)];
        }
        // Fallback greeting
        return ['text' => "Hello! Ask me to 'browse electronics', 'order #123', or 'vendor 45'."];
    }

    protected static function handleBrowseIntent($message)
    {
        $category_map = [
            'electronics' => 10,
            'fashion'     => 12,
            'shoes'       => 15,
            'books'       => 18,
            'toys'        => 20,
        ];
        // extract filters
        $category_id = null;
        foreach ($category_map as $kw => $cid) {
            if (stripos($message, $kw) !== false) {
                $category_id = $cid;
                break;
            }
        }
        $page = 1;
        if (preg_match('/page\s*(\d+)/i', $message, $p)) {
            $page = max(1, (int)$p[1]);
        }
        $limit = 10;
        $offset = ($page - 1) * $limit;
        $cond = $category_id ? db_quote(' AND pc.category_id = ?i', $category_id) : '';
        $products = db_get_array(
            "SELECT p.product_id, pd.product AS product, p.list_price AS price, p.amount
             FROM ?:products AS p
             LEFT JOIN ?:product_descriptions AS pd
               ON pd.product_id = p.product_id
               AND pd.lang_code = ?s
             LEFT JOIN ?:products_categories AS pc
               ON p.product_id = pc.product_id
             WHERE p.status = 'A' {$cond}
             LIMIT ?i, ?i",
            CART_LANGUAGE, $offset, $limit
        );
        // render grid HTML
        $html = '<div class="zwa-grid">';
        foreach ($products as $prod) {
            $img = fn_image_to_display('products', $prod['product_id']);
            $html .= '<div class="zwa-card">'
                   . "<img src=\"{$img['image_path']}\" alt=\"" . htmlspecialchars($prod['product']) . "\" />"
                   . '<h4>' . htmlspecialchars($prod['product']) . '</h4>'
                   . '<p>Price: ' . htmlspecialchars($prod['price']) . ' FCFA</p>'
                   . '<p>Stock: ' . htmlspecialchars($prod['amount']) . '</p>'
                   . '</div>';
        }
        $html .= '</div>';
        return ['html' => $html, 'products' => $products];
    }

    protected static function fetchEntityByKeyAndId($key, $id)
    {
        $entities = [
            'order'    => ['table'=>'orders','id_field'=>'order_id','fields'=>['order_id','total','status','timestamp']],
            'product'  => ['table'=>'products','id_field'=>'product_id','fields'=>['product_id','product','price','amount']],
            'vendor'   => ['table'=>'companies','id_field'=>'company_id','fields'=>['company_id','company','email','status']],
            'customer' => ['table'=>'users','id_field'=>'user_id','fields'=>['user_id','firstname','lastname','email']],
            'category' => ['table'=>'categories','id_field'=>'category_id','fields'=>['category_id','category']],
            'loyalty'  => ['table'=>'zcredit','id_field'=>'user_id','fields'=>['user_id','balance','last_updated']],
        ];
        if (!isset($entities[$key])) {
            return "Unrecognized entity '{$key}'.";
        }
        $cfg = $entities[$key];
        $row = db_get_row("SELECT " . implode(',', $cfg['fields']) .
                          " FROM ?:{$cfg['table']} WHERE {$cfg['id_field']} = ?i", $id);
        if (!$row) {
            return ucfirst($key) . " #{$id} not found.";
        }
        $parts = [];
        foreach ($row as $field=>$val) {
            if (in_array($field, ['timestamp','last_updated'])) {
                $val = date('Y-m-d H:i', $val);
            }
            $parts[] = ucfirst(str_replace('_',' ',$field)) . ": {$val}";
        }
        return implode(', ', $parts);
    }

    protected static function askOpenAI($prompt)
    {
        $api_key = \Tygh\Registry::get('addons.zwa_chat.openai_api_key');
        if (!$api_key) {
            return "OpenAI API key not configured.";
        }
        $messages = [
            ['role' => 'system', 'content' => "You are Zwa, the AI assistant for Zwanayo, a fast-growing e-commerce marketplace based in Pointe Noire, Republic of Congo. Zwanayo offers a wide range of products from multiple vendors, a loyalty program called Z-Crédit, and supports orders, product browse, vendor applications, and customer service. Always respond clearly, accurately, and in the context of online retail. If uncertain, suggest visiting https://dev.zwanayo.com or contacting support."],
            ['role' => 'user', 'content' => $prompt],
        ];
        $ch = curl_init('https://api.openai.com/v1/chat/completions');
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json',
            'Authorization: Bearer ' . $api_key,
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode([
            'model' => 'gpt-4',
            'messages' => $messages,
            'temperature' => 0.7,
            'max_tokens' => 500,
        ]));
        $response = curl_exec($ch);
        if (curl_errno($ch)) {
            return "OpenAI request error: " . curl_error($ch);
        }
        curl_close($ch);
        $data = json_decode($response, true);
        if (!isset($data['choices'][0]['message']['content'])) {
            return "OpenAI response error.";
        }
        return trim($data['choices'][0]['message']['content']);
    }
}

if (!defined('BOOTSTRAP')) { die('Access denied'); }

// --- Schema helpers --------------------------------------------------------
if (!function_exists('zwa_has_column')) {
    function zwa_has_column($table, $field) {
        static $cache = [];
        $key = $table . ':' . $field;
        if (!array_key_exists($key, $cache)) {
            $cache[$key] = (bool) db_get_field("SHOW COLUMNS FROM `$table` LIKE ?s", $field);
        }
        return $cache[$key];
    }
}
if (!function_exists('zwa_order_clause')) {
    function zwa_order_clause($table) {
        if (zwa_has_column($table, 'id')) {
            return 'ORDER BY id ASC';
        }
        if (zwa_has_column($table, 'message_id')) {
            return 'ORDER BY message_id ASC';
        }
        if (zwa_has_column($table, 'created_at')) {
            return 'ORDER BY created_at ASC';
        }
        return '';
    }
}

// Send the CORS headers and handle preflight
fn_zwa_chat_send_cors();
// --- Harden CORS: strict allow-list & proper Vary ---
$allowed_origins = [
    'https://zwanayo.com',
    'https://www.zwanayo.com',
    'https://dev.zwanayo.com',
    'https://chat.zwanayo.com',
];
$origin = isset($_SERVER['HTTP_ORIGIN']) ? trim($_SERVER['HTTP_ORIGIN']) : '';
if ($origin && in_array($origin, $allowed_origins, true)) {
    header('Access-Control-Allow-Origin: ' . $origin);
    header('Vary: Origin');
    header('Access-Control-Allow-Credentials: true');
} else {
    // Do not reflect or use wildcard; default to no ACAO or a single trusted origin
    header_remove('Access-Control-Allow-Origin');
}
// Always ensure our custom admin header is allowed
header('Access-Control-Allow-Headers: Origin, Content-Type, Authorization, X-Requested-With, X-Zwa-Admin-Key');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    // Short-circuit preflight
    while (ob_get_level()) { ob_end_clean(); }
    http_response_code(204);
    exit;
}



// ────────────────────────────────────────────────────────────────────────────
// LIVE CHAT PIPE (Node ↔ CS‑Cart Admin) — schema‑aware, no destructive DDL
// ────────────────────────────────────────────────────────────────────────────
if ($mode === 'live_save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    // --- Auth: header-only strict check ---
    $settings = \Tygh\Registry::get('addons.zwa_chat');
    $expected = trim((string) ($settings['admin_api_key'] ?? ''));
    $incoming = trim($_SERVER['HTTP_X_ZWA_ADMIN_KEY'] ?? '');
    // Also support Bearer token in Authorization header
    if ($incoming === '' && !empty($_SERVER['HTTP_AUTHORIZATION']) && stripos($_SERVER['HTTP_AUTHORIZATION'], 'Bearer ') === 0) {
        $incoming = trim(substr($_SERVER['HTTP_AUTHORIZATION'], 7));
    }
    if ($expected === '' || !hash_equals($expected, $incoming)) {
        // Optional debug without leaking secrets
        $debug_allowed = (\Tygh\Registry::ifGet('addons.zwa_chat.debug_auth', 'N') === 'Y');
        $debug = [];
        if ($debug_allowed && !empty($_SERVER['HTTP_X_ZWA_DEBUG']) && $_SERVER['HTTP_X_ZWA_DEBUG'] === '1') {
            $debug = [
                'adminKeyLen'   => strlen($expected),
                'incomingLen'   => strlen($incoming),
                'expected_tail' => substr($expected, -4),
                'incoming_tail' => substr($incoming, -4),
            ];
        }
        while (ob_get_level()) { ob_end_clean(); }
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(401);
        echo json_encode(['ok' => false, 'error' => 'bad-key'] + ($debug ? ['_debug' => $debug] : []));
        exit;
    }

    // --- Parse JSON body safely (fallback to form POST) ---
    $raw = file_get_contents('php://input');
    $json = json_decode($raw, true);
    $session_id = isset($json['session_id']) ? (string)$json['session_id'] : (string)($_POST['session_id'] ?? '');
    $role       = isset($json['role'])       ? (string)$json['role']       : (string)($_POST['role'] ?? '');
    $text       = isset($json['text'])       ? (string)$json['text']       : (string)($_POST['text'] ?? '');
    // Normalize/guard role -> sender mapping later
    $role = strtolower(trim($role));
    if ($role === '') { $role = 'user'; }
    if ($session_id === '' || $text === '') {
        while (ob_get_level()) { ob_end_clean(); }
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(400);
        echo json_encode(['ok' => false, 'error' => 'missing-fields', 'need' => ['session_id','text']]);
        exit;
    }

    // Prefer conversation-based schema if present
    $has_conversations = (bool) db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'");
    $use_conversations = $has_conversations && zwa_has_column('?:zwa_chat_messages', 'conversation_id');

    if ($use_conversations) {
        // Find or create a conversation mapped by session_id in conversations.meta/session field if present
        // Try direct mapping via a flexible column if it exists
        $conversation_id = 0;
        if (zwa_has_column('?:zwa_chat_conversations', 'external_session')) {
            $conversation_id = (int) db_get_field(
                "SELECT conversation_id FROM ?:zwa_chat_conversations WHERE external_session = ?s LIMIT 1",
                $session_id
            );
            if (!$conversation_id) {
                $conversation_id = db_query("INSERT INTO ?:zwa_chat_conversations ?e", [
                    'external_session' => $session_id,
                    'last_message_time' => date('Y-m-d H:i:s'),
                ]);
            }
        } else {
            // Fallback: create a conversation per session if not found
            $conversation_id = (int) db_get_field(
                "SELECT conversation_id FROM ?:zwa_chat_conversations ORDER BY conversation_id DESC LIMIT 1"
            );
            if (!$conversation_id) {
                $conversation_id = db_query("INSERT INTO ?:zwa_chat_conversations ?e", [
                    'last_message_time' => date('Y-m-d H:i:s'),
                ]);
            }
        }

        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'conversation_id' => (int) $conversation_id,
            'sender'          => ($role === 'user' ? 'customer' : ($role === 'admin' ? 'admin' : 'bot')),
            'channel'         => 'site',
            'message'         => $text,
            'created_at'      => date('Y-m-d H:i:s'),
        ]);
        db_query(
            "UPDATE ?:zwa_chat_conversations SET last_message_time = ?s WHERE conversation_id = ?i",
            date('Y-m-d H:i:s'),
            (int) $conversation_id
        );
    } else {
        // Session-based schema (chat_id)
        $has_sessions = (bool) db_get_field("SHOW TABLES LIKE '?:zwa_chat_sessions'");
        $has_messages = (bool) db_get_field("SHOW TABLES LIKE '?:zwa_chat_messages'");
        if (!$has_sessions || !$has_messages) {
            while (ob_get_level()) { ob_end_clean(); }
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['ok' => false, 'error' => 'schema-missing']); exit;
        }
        // Map session_id -> user_phone
        $user_phone = $session_id; // treat widget session as a pseudo-identifier
        $row = db_get_row("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1", $user_phone);
        if ($row && !empty($row['chat_id'])) {
            $chat_id = (int) $row['chat_id'];
            db_query("UPDATE ?:zwa_chat_sessions SET last_activity = NOW(), last_message = ?s WHERE chat_id = ?i", $text, $chat_id);
        } else {
            db_query("REPLACE INTO ?:zwa_chat_sessions (user_phone, status, last_activity, last_message) VALUES (?s, 'open', NOW(), ?s)", $user_phone, $text);
            $chat_id = (int) db_get_field("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1", $user_phone);
        }
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'chat_id'    => (int) $chat_id,
            'sender'     => (in_array($role, ['user','bot','admin'], true) ? $role : 'user'),
            'channel'    => 'site',
            'message'    => $text,
            'created_at' => date('Y-m-d H:i:s'),
        ]);
    }

    while (ob_get_level()) { ob_end_clean(); }
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode(['ok' => true]); exit;
}

// Admin list (threads)
if ($mode === 'live_list') {
    $use_conversations = (bool) (db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'")
                          && zwa_has_column('?:zwa_chat_messages', 'conversation_id'));
    if ($use_conversations) {
        $threads = db_get_array("
            SELECT c.conversation_id,
                   MAX(m.created_at) AS last_at,
                   SUM(m.sender='customer') AS user_msgs,
                   SUM(m.sender='admin')    AS admin_msgs,
                   SUM(m.sender='bot')      AS bot_msgs
            FROM ?:zwa_chat_conversations c
            LEFT JOIN ?:zwa_chat_messages m ON m.conversation_id = c.conversation_id
            GROUP BY c.conversation_id
            ORDER BY last_at DESC
            LIMIT 500
        ");
    } else {
        $threads = db_get_array("
            SELECT s.user_phone AS session_id,
                   s.chat_id    AS conversation_id,
                   MAX(m.created_at) AS last_at,
                   SUM(m.sender='user')  AS user_msgs,
                   SUM(m.sender='admin') AS admin_msgs,
                   SUM(m.sender='bot')   AS bot_msgs
            FROM ?:zwa_chat_sessions s
            LEFT JOIN ?:zwa_chat_messages m ON m.chat_id = s.chat_id
            GROUP BY s.chat_id, s.user_phone
            ORDER BY last_at DESC
            LIMIT 500
        ");
    }
    Tygh::$app['view']->assign('threads', $threads);
    return [CONTROLLER_STATUS_OK];
}

// Admin view (single thread)
if ($mode === 'live_messages') {
    $use_conversations = (bool) (db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'")
                          && zwa_has_column('?:zwa_chat_messages', 'conversation_id'));

    $conversation_id = 0;
    $session_id = '';
    $messages = [];

    if ($use_conversations) {
        $conversation_id = (int) ($_REQUEST['conversation_id'] ?? 0);
        if ($conversation_id) {
            $messages = db_get_array("
                SELECT * FROM ?:zwa_chat_messages
                WHERE conversation_id = ?i
                " . zwa_order_clause('?:zwa_chat_messages'),
                $conversation_id
            );
        }
    } else {
        $conversation_id = (int) ($_REQUEST['conversation_id'] ?? 0);
        if (!$conversation_id && !empty($_REQUEST['session_id'])) {
            $conversation_id = (int) db_get_field("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s", (string) $_REQUEST['session_id']);
        }
        if ($conversation_id) {
            $messages = db_get_array("
                SELECT * FROM ?:zwa_chat_messages
                WHERE chat_id = ?i
                " . zwa_order_clause('?:zwa_chat_messages'),
                $conversation_id
            );
            $session_id = (string) db_get_field("SELECT user_phone FROM ?:zwa_chat_sessions WHERE chat_id = ?i", $conversation_id);
        }
    }

    Tygh::$app['view']->assign('conversation_id', $conversation_id);
    Tygh::$app['view']->assign('session_id', $session_id);
    Tygh::$app['view']->assign('messages', $messages);
    return [CONTROLLER_STATUS_OK];
}

// Admin reply: persist + forward to Node
if ($mode === 'live_reply' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    $text = (string) ($_REQUEST['text'] ?? '');
    if ($text === '') {
        return [CONTROLLER_STATUS_REDIRECT, 'zwa_chat.live_list'];
    }

    $use_conversations = (bool) (db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'")
                          && zwa_has_column('?:zwa_chat_messages', 'conversation_id'));

    $conversation_id = (int) ($_REQUEST['conversation_id'] ?? 0);

    if ($use_conversations && $conversation_id) {
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'conversation_id' => $conversation_id,
            'sender'          => 'admin',
            'channel'         => 'site',
            'message'         => $text,
            'created_at'      => date('Y-m-d H:i:s'),
        ]);
    } elseif ($conversation_id) {
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'chat_id'    => $conversation_id,
            'sender'     => 'admin',
            'channel'    => 'site',
            'message'    => $text,
            'created_at' => date('Y-m-d H:i:s'),
        ]);
    }

    // Forward to Node (header-auth)
    $settings  = \Tygh\Registry::get('addons.zwa_chat');
    $api_url   = rtrim((string) ($settings['api_url'] ?? ''), '/');
    $admin_key = (string) ($settings['admin_api_key'] ?? '');
    if ($api_url && $admin_key) {
        // Resolve session id for Node
        $session = '';
        if ($use_conversations) {
            if (zwa_has_column('?:zwa_chat_conversations', 'external_session')) {
                $session = (string) db_get_field("SELECT external_session FROM ?:zwa_chat_conversations WHERE conversation_id = ?i", $conversation_id);
            }
        } else {
            $session = (string) db_get_field("SELECT user_phone FROM ?:zwa_chat_sessions WHERE chat_id = ?i", $conversation_id);
        }
        $endpoint = $api_url . '/admin-reply';
        $payload  = json_encode(['session_id' => $session, 'text' => $text]);
        $resp = fn_http_request('POST', $endpoint, $payload, [
            'Content-Type: application/json',
            'X-Zwa-Admin-Key: ' . $admin_key
        ], [], 'text', 5);
        if (empty($resp[0]) || (int)$resp[0] >= 400) {
            error_log('ZwaChat: failed to push admin reply to Node (' . $endpoint . '), HTTP=' . (int)($resp[0] ?? 0));
        }
    }

    return [CONTROLLER_STATUS_REDIRECT, 'zwa_chat.live_messages&conversation_id=' . $conversation_id];
}

if ($mode === 'manage') {
    $conversation_id = $_REQUEST['conversation_id'] ?? null;

    if ($conversation_id) {
        // Get conversation info
        $conversation = db_get_row(
            'SELECT * FROM ?:zwa_chat_conversations WHERE conversation_id = ?i',
            $conversation_id
        );

        if (!$conversation) {
            fn_set_notification('E', __('Error'), __('Conversation not found.'));
            return [CONTROLLER_STATUS_NO_PAGE];
        }

        // Get all messages in this conversation
        $messages = db_get_array(
            'SELECT * FROM ?:zwa_chat_messages WHERE conversation_id = ?i ORDER BY created_at ASC',
            $conversation_id
        );

        Tygh::$app['view']->assign([
            'conversation' => $conversation,
            'messages' => $messages,
            'conversation_id' => $conversation_id,
        ]);
    } else {
        // Fallback: show conversation list
        $conversations = db_get_array('SELECT * FROM ?:zwa_chat_conversations ORDER BY last_message_time DESC');

        Tygh::$app['view']->assign([
            'conversations' => $conversations,
        ]);
    }
}

if ($mode === 'send_message') {
    $conversation_id = $_REQUEST['conversation_id'] ?? $_REQUEST['session_id'] ?? null;
    $text = $_REQUEST['text'] ?? $_REQUEST['message'] ?? null;
    $channel = $_REQUEST['channel'] ?? 'site';
    $sender = $_REQUEST['sender'] ?? 'admin';
    $is_ajax = isset($_REQUEST['is_ajax']) || (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest');

    if (!$text) {
        $result = ['ok' => false, 'error' => 'Missing message text'];
        if ($is_ajax) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode($result);
            exit;
        } else {
            fn_set_notification('E', __('Error'), __('Missing message text.'));
            return [CONTROLLER_STATUS_REDIRECT, 'zwa_chat.manage'];
        }
    }

    // If no conversation_id was provided, create a new conversation row
    if (!$conversation_id) {
        // Create minimal conversation; additional columns should be nullable in schema
        $conversation_id = db_query("INSERT INTO ?:zwa_chat_conversations ?e", [
            'last_message_time' => date('Y-m-d H:i:s'),
        ]);
    }

    $data = [
        'conversation_id' => (int) $conversation_id,
        'message'         => $text,
        'sender'          => $sender,
        'channel'         => $channel,
        'timestamp'       => date('Y-m-d H:i:s'),
        'created_at'      => date('Y-m-d H:i:s'),
    ];

    db_query('INSERT INTO ?:zwa_chat_messages ?e', $data);

    // Update conversation metadata
    db_query(
        'UPDATE ?:zwa_chat_conversations SET last_message_time = ?s WHERE conversation_id = ?i',
        $data['timestamp'],
        (int) $conversation_id
    );

    if ($is_ajax) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['ok' => true, 'conversation_id' => (int) $conversation_id]);
        exit;
    } else {
        return [CONTROLLER_STATUS_OK, 'zwa_chat.manage&conversation_id=' . (int) $conversation_id];
    }
}

if ($mode === 'get_messages') {
    // Simple JSON endpoint to fetch messages for a conversation
    while (ob_get_level()) { ob_end_clean(); }
    header_remove();
    header('Content-Type: application/json; charset=utf-8');

    $conversation_id = isset($_REQUEST['conversation_id']) ? (int) $_REQUEST['conversation_id'] : 0;

    // Determine schema type
    $use_conversations = (bool) (
        db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'")
        && zwa_has_column('?:zwa_chat_messages', 'conversation_id')
    );

    // Fallback: allow session_id to map to conversation_id
    if ($conversation_id <= 0 && !empty($_REQUEST['session_id'])) {
        if ($use_conversations) {
            // Map session_id to conversation_id via conversations.external_session
            $conversation_id = (int) db_get_field(
                "SELECT conversation_id FROM ?:zwa_chat_conversations WHERE external_session = ?s LIMIT 1",
                (string) $_REQUEST['session_id']
            );
        } else {
            // Map session_id to chat_id
            $conversation_id = (int) db_get_field(
                "SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1",
                (string) $_REQUEST['session_id']
            );
        }
    }
    if ($conversation_id <= 0) {
        echo json_encode(['ok' => false, 'error' => 'missing conversation_id']);
        exit;
    }

    $order = zwa_order_clause('?:zwa_chat_messages');
    if ($use_conversations) {
        $rows = db_get_array(
            "SELECT sender AS sender, message AS message, created_at AS created_at
             FROM ?:zwa_chat_messages
             WHERE conversation_id = ?i {$order}",
            $conversation_id
        );
    } else {
        $rows = db_get_array(
            "SELECT sender AS sender, message AS message, created_at AS created_at
             FROM ?:zwa_chat_messages
             WHERE chat_id = ?i {$order}",
            $conversation_id
        );
    }

    // Transform DB columns to widget-friendly shape {sender, text, created_at}
    $messages = [];
    foreach ($rows as $r) {
        $messages[] = [
            'sender'     => $r['sender'],
            'text'       => $r['message'],
            'created_at' => $r['created_at'],
        ];
    }

    echo json_encode(['ok' => true, 'messages' => $messages]);
    exit;
}

if ($mode === 'widget') {
    // Allow same-origin framing of this widget page
    header('X-Frame-Options: SAMEORIGIN');
    header("Content-Security-Policy: frame-ancestors 'self'");

    $end_send = fn_url('zwa_chat.send_message', 'C');
    $end_get  = fn_url('zwa_chat.get_messages', 'C');

    $html = <<<'HTML'
<!doctype html>
<html>
<head>
<meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>ZwaChat</title>
<style>
html,body{height:100%;margin:0;font-family:system-ui,sans-serif}
.wrap{display:flex;flex-direction:column;height:100%}
.head{height:44px;display:flex;align-items:center;justify-content:space-between;padding:0 12px;border-bottom:1px solid #f1f1f1;background:#fafafa}
.list{flex:1;overflow:auto;padding:10px 12px;display:flex;flex-direction:column;gap:8px}
.msg{margin:0;padding:8px 10px;border-radius:12px;max-width:78%}
.me{align-self:flex-end;background:#e8f3ff}
.them{align-self:flex-start;background:#f5f5f5}
.input{display:flex;gap:8px;border-top:1px solid #f1f1f1;padding:10px}
.input input{flex:1;border:1px solid #e5e7eb;border-radius:10px;padding:10px 12px}
.input button{border:1px solid #e5e7eb;border-radius:10px;background:#fff;padding:10px 12px;cursor:pointer}
</style>
</head>
<body>
<div class="wrap">
  <div class="head"><strong>ZwaChat</strong></div>
  <div id="list" class="list"></div>
  <div class="input">
    <input id="text" type="text" placeholder="Tapez votre message…">
    <button id="send" type="button">Envoyer</button>
  </div>
</div>
<script>
(function(){
  const END_SEND = '%END_SEND%';
  const END_GET  = '%END_GET%';
  // Generate or load persistent session identifier
  let sessionId = localStorage.getItem('zwa_session_id');
  if (!sessionId) {
    sessionId = 'sess_' + Math.random().toString(36).substr(2,9) + Date.now();
    localStorage.setItem('zwa_session_id', sessionId);
  }
  let conversationId = Number(localStorage.getItem('zwa_conversation_id') || 0);
  const list = document.getElementById('list');
  const input = document.getElementById('text');
  const sendBtn = document.getElementById('send');

  function add(msg){
    const p=document.createElement('p');
    p.className='msg ' + (msg.sender==='customer'?'me':'them');
    p.textContent=msg.text;
    list.appendChild(p);
    list.scrollTop=list.scrollHeight;
  }

  async function load(){
    const query = conversationId
      ? '&conversation_id=' + conversationId
      : '&session_id=' + encodeURIComponent(sessionId);
    const r = await fetch(END_GET + query, { credentials:'same-origin', headers:{'X-Requested-With':'XMLHttpRequest'}});
    if(r.ok){
      const d=await r.json();
      list.innerHTML='';
      (d.messages||[]).forEach(add);
    }
  }

  async function send(){
    const text=(input.value||'').trim();
    if(!text) return;
    const body=new URLSearchParams({ conversation_id:String(conversationId||0), text, sender:'customer', is_ajax:'1' });
    const r=await fetch(END_SEND, { method:'POST', credentials:'same-origin', headers:{'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8','X-Requested-With':'XMLHttpRequest'}, body });
    if(!r.ok) return;
    const d=await r.json();
    if(d.conversation_id && !conversationId){
      conversationId=Number(d.conversation_id);
      localStorage.setItem('zwa_conversation_id', String(conversationId));
    }
    add({sender:'customer', text});
    input.value='';
    setTimeout(load, 400);
  }

  sendBtn.addEventListener('click', send);
  input.addEventListener('keydown', e=>{ if(e.key==='Enter') send(); });
  load();
})();
</script>
</body>
</html>
HTML;

    // Inject dynamic endpoints safely
    $html = str_replace('%END_SEND%', htmlspecialchars($end_send, ENT_QUOTES, 'UTF-8'), $html);
    $html = str_replace('%END_GET%',  htmlspecialchars($end_get,  ENT_QUOTES, 'UTF-8'), $html);

    header('Content-Type: text/html; charset=utf-8');
    echo $html;
    exit;
}



if ($mode === 'webhook') {
    try {
        // —— Webhook verification (GET) ——
        if ($_SERVER['REQUEST_METHOD'] === 'GET'
            && isset($_GET['hub.mode'], $_GET['hub.verify_token'], $_GET['hub.challenge'])
        ) {
            $verify_token = \Tygh\Registry::get('addons.zwa_chat.verify_token');
            if ($_GET['hub.verify_token'] === $verify_token) {
                header('Content-Type: text/plain; charset=utf-8');
                echo $_GET['hub.challenge'];
                exit;
            }
            http_response_code(403);
            exit;
        }

        // Only accept POST for message payloads; reject other GETs
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            http_response_code(400);
            exit;
        }

        $input = file_get_contents('php://input');
        file_put_contents(__DIR__ . '/webhook.log', date('c')."\n".$input."\n\n", FILE_APPEND);

        // —— Read payload and verify HMAC signature (POST) ——
        // Debug: log raw webhook input
        error_log('ZwaChat raw POST payload: ' . $input);

        // Retrieve signature header reliably
        $signature = $_SERVER['HTTP_X_HUB_SIGNATURE'] ?? '';
        if (!$signature && function_exists('getallheaders')) {
            foreach (getallheaders() as $name => $value) {
                if (strtolower($name) === 'x-hub-signature') {
                    $signature = $value;
                    break;
                }
            }
        }
        $app_secret = \Tygh\Registry::get('addons.zwa_chat.whatsapp_app_secret');
        if ($signature && !SignatureValidator::isValid($input, $signature, $app_secret)) {
            http_response_code(403);
            exit;
        }

        // —— Relay full payload to Node.js for processing ——
        $node_endpoint = \Tygh\Registry::get('addons.zwa_chat.whatsapp_node_endpoint');
        if (empty($node_endpoint)) {
            // Fallback to your local or production Node URL
            $node_endpoint = 'http://localhost:3010/api/whatsapp-webhook';
        }
        $ch = curl_init($node_endpoint);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, ['Content-Type: application/json']);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $input);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        $node_response = curl_exec($ch);
        if (curl_errno($ch)) {
            error_log('ZwaChat relay to Node error: ' . curl_error($ch));
        } else {
            error_log('ZwaChat relay to Node response: ' . $node_response);
        }
        curl_close($ch);

        // —— Process the update ——
        $update = json_decode($input, true);
        if ($update === null) {
            error_log('ZwaChat JSON decode error: ' . json_last_error_msg());
        } else {
            error_log('ZwaChat decoded update: ' . print_r($update, true));
        }
        if (!empty($update['entry'])) {
            foreach ($update['entry'] as $entry) {
                foreach ($entry['changes'] as $change) {
                    if (!empty($change['value']['messages'])) {
                        foreach ($change['value']['messages'] as $msg) {
                            error_log('ZwaChat webhook message payload: ' . print_r($msg, true));
                            // Log the extracted text body
                            $body = $msg['text']['body'] ?? '';
                            error_log('ZwaChat incoming message body: ' . $body);

                            // Generate and log the bot’s response
                            $botResponse = Bot::respond($body, $msg['from']);
                            error_log('ZwaChat bot response: ' . print_r($botResponse, true));
                            fn_zwa_chat_handle_incoming($msg);
                        }
                    }
                    if (!empty($change['value']['statuses'])) {
                        foreach ($change['value']['statuses'] as $status) {
                            fn_zwa_chat_handle_status($status);
                        }
                    }
                }
            }
        }

        // —— Acknowledge receipt ——
        header('Content-Type: application/json');
        echo json_encode(['status' => 'ok', 'received' => time()]);
        exit;
    } catch (\Throwable $e) {
        error_log($e->getMessage() . "\n" . $e->getTraceAsString());
        http_response_code(500);
        echo $e->getMessage();
        exit;
    }
}

if ($mode === 'chat_api') {
    // ─── Short-circuit to JSON: clear buffers and reset headers ──────────
    while (ob_get_level()) {
        ob_end_clean();
    }
    header_remove();
    header('Content-Type: application/json; charset=utf-8');

    $data = json_decode(file_get_contents('php://input'), true);
    $userMsg = $data['message'] ?? '';
    $api_key = $data['api_key'] ?? ''; // relay expects api_key


    // Relay function to Node.js server
    function relay_to_node($message, $api_key) {
        // Get Node.js relay endpoint from settings, fallback to ngrok URL
        $url = \Tygh\Registry::get('addons.zwa_chat.whatsapp_node_endpoint');
        if (empty($url)) {
            $url = 'https://chat.zwanayo.com/api/whatsapp-webhook';
        }
        $payload = json_encode([
            'message' => $message,
            'api_key' => $api_key
        ]);
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, [
            'Content-Type: application/json'
        ]);
        curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5); // 5 second timeout

        $result = curl_exec($ch);

        if (curl_errno($ch)) {
            curl_close($ch);
            return json_encode(['reply' => '⚠️ ZwaChat is temporarily unavailable. Please try again later.']);
        }
        curl_close($ch);
        return $result ?: json_encode(['reply' => '⚠️ No response from ZwaChat. Try again soon.']);
    }

    echo relay_to_node($userMsg, $api_key);
    exit;
}

if ($mode === 'admin_log' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    // --- Auth: header-only strict check ---
    $a = \Tygh\Registry::get('addons.zwa_chat');
    $expected = trim(isset($a['admin_api_key']) ? (string) $a['admin_api_key'] : '');
    $incoming = trim($_SERVER['HTTP_X_ZWA_ADMIN_KEY'] ?? '');
    if ($incoming === '' && !empty($_SERVER['HTTP_AUTHORIZATION']) && stripos($_SERVER['HTTP_AUTHORIZATION'], 'Bearer ') === 0) {
        $incoming = trim(substr($_SERVER['HTTP_AUTHORIZATION'], 7));
    }
    if ($expected === '' || !hash_equals($expected, $incoming)) {
        $debug_allowed = (\Tygh\Registry::ifGet('addons.zwa_chat.debug_auth', 'N') === 'Y');
        $debug = [];
        if ($debug_allowed && !empty($_SERVER['HTTP_X_ZWA_DEBUG']) && $_SERVER['HTTP_X_ZWA_DEBUG'] === '1') {
            $debug = [
                'adminKeyLen'   => strlen($expected),
                'incomingLen'   => strlen($incoming),
                'expected_tail' => substr($expected, -4),
                'incoming_tail' => substr($incoming, -4),
            ];
        }
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(401);
        fn_echo(json_encode(['ok' => false, 'error' => 'bad-key'] + ($debug ? ['_debug' => $debug] : [])));
        exit;
    }

    // --- Parse JSON payload ---
    $raw = file_get_contents('php://input');
    $json = json_decode($raw, true);
    $session = isset($json['session']) ? (string)$json['session'] : (string)($_POST['session'] ?? '');
    $sender  = isset($json['sender'])  ? (string)$json['sender']  : (string)($_POST['sender'] ?? 'bot');
    $channel = isset($json['channel']) ? (string)$json['channel'] : (string)($_POST['channel'] ?? 'site');
    $message = isset($json['message']) ? (string)$json['message'] : (string)($_POST['message'] ?? '');
    // Normalize sender/channel
    $sender  = in_array($sender,  ['user','bot','admin'], true) ? $sender  : 'bot';
    $channel = in_array($channel, ['site','whatsapp'], true)     ? $channel : 'site';
    if ($session === '' || $message === '') {
        header('Content-Type: application/json; charset=utf-8');
        http_response_code(400);
        fn_echo(json_encode(['ok' => false, 'error' => 'missing-fields', 'need' => ['session','message']]));
        exit;
    }

    // ensure tables (create if missing) and repair schema if columns absent
    // --- sessions table ---
    db_query("CREATE TABLE IF NOT EXISTS ?:zwa_chat_sessions (
        chat_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        user_phone VARCHAR(32) NOT NULL,
        status ENUM('open','resolved') NOT NULL DEFAULT 'open',
        last_activity DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        last_message TEXT NULL,
        UNIQUE KEY user_phone (user_phone)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    // If table exists but without chat_id (older schema), add it and make it PRIMARY KEY
    $col_chat_id = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_sessions LIKE 'chat_id'");
    if (!$col_chat_id) {
        // drop existing PK if any, then add chat_id auto_increment as PRIMARY KEY
        $has_pk = db_get_row("SHOW KEYS FROM ?:zwa_chat_sessions WHERE Key_name = 'PRIMARY'");
        if ($has_pk) {
            db_query("ALTER TABLE ?:zwa_chat_sessions DROP PRIMARY KEY");
        }
        db_query("ALTER TABLE ?:zwa_chat_sessions ADD COLUMN chat_id INT UNSIGNED NOT NULL AUTO_INCREMENT FIRST, ADD PRIMARY KEY (chat_id)");
    }

    // Add missing columns on sessions table if they don't exist yet
    $col_last_activity = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_sessions LIKE 'last_activity'");
    if (!$col_last_activity) {
        db_query("ALTER TABLE ?:zwa_chat_sessions ADD COLUMN last_activity DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP");
    }
    $col_last_message = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_sessions LIKE 'last_message'");
    if (!$col_last_message) {
        db_query("ALTER TABLE ?:zwa_chat_sessions ADD COLUMN last_message TEXT NULL");
    }
    $col_status = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_sessions LIKE 'status'");
    if (!$col_status) {
        db_query("ALTER TABLE ?:zwa_chat_sessions ADD COLUMN status ENUM('open','resolved') NOT NULL DEFAULT 'open'");
    }
    // ensure UNIQUE on user_phone (ignore if already unique)
    $uniq_phone = db_get_row("SHOW INDEX FROM ?:zwa_chat_sessions WHERE Column_name = 'user_phone' AND Non_unique = 0");
    if (!$uniq_phone) {
        // This may fail if duplicates exist; that's acceptable for now.
        @db_query("ALTER TABLE ?:zwa_chat_sessions ADD UNIQUE KEY user_phone (user_phone)");
    }

    // --- messages table ---
    db_query("CREATE TABLE IF NOT EXISTS ?:zwa_chat_messages (
        id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        chat_id INT UNSIGNED NOT NULL,
        sender ENUM('user','bot','admin') NOT NULL,
        channel ENUM('site','whatsapp') NOT NULL DEFAULT 'whatsapp',
        message TEXT NOT NULL,
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        KEY chat_id (chat_id),
        CONSTRAINT fk_zwa_chat_messages_session
            FOREIGN KEY (chat_id) REFERENCES ?:zwa_chat_sessions(chat_id)
            ON DELETE CASCADE
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    // --- schema repair for messages table (non-destructive) ---
    // Avoid dropping PRIMARY KEY when an AUTO_INCREMENT column exists (MySQL error 1075)
    $m_cols = db_get_array("SHOW COLUMNS FROM ?:zwa_chat_messages");
    $__has_id = false;
    $__has_auto_any = false;
    if (is_array($m_cols)) {
        foreach ($m_cols as $col) {
            $fname = isset($col['Field']) ? strtolower($col['Field']) : '';
            if ($fname === 'id') {
                $__has_id = true;
            }
            if (!empty($col['Extra']) && stripos($col['Extra'], 'auto_increment') !== false) {
                $__has_auto_any = true;
            }
        }
    }
    $__has_pk = db_get_row("SHOW KEYS FROM ?:zwa_chat_messages WHERE Key_name = 'PRIMARY'");

    // Only add an AUTO_INCREMENT `id` as PRIMARY KEY when the table has no PK and no AUTO_INCREMENT yet
    if (!($__has_id) && !($__has_pk) && !($__has_auto_any)) {
        db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST");
    } else if (!($__has_id)) {
        // If there's already some primary key, just ensure an `id` column exists (no PK/AI); harmless for inserts
        $m_col_id2 = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'id'");
        if (!$m_col_id2) {
            db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN id INT UNSIGNED NULL FIRST");
        }
    }

    // Ensure required columns exist
    $m_col_chat_id = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'chat_id'");
    if (!$m_col_chat_id) {
        // Place after `id` when present
        if ($__has_id || db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'id'")) {
            db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN chat_id INT UNSIGNED NOT NULL AFTER id");
        } else {
            db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN chat_id INT UNSIGNED NOT NULL FIRST");
        }
    }

    $m_col_sender = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'sender'");
    if (!$m_col_sender) {
        db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN sender ENUM('user','bot','admin') NOT NULL AFTER chat_id");
    }

    $m_col_channel = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'channel'");
    if (!$m_col_channel) {
        db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN channel ENUM('site','whatsapp') NOT NULL DEFAULT 'whatsapp' AFTER sender");
    }

    $m_col_message = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'message'");
    if (!$m_col_message) {
        db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN message TEXT NOT NULL AFTER channel");
    }

    $m_col_created = db_get_row("SHOW COLUMNS FROM ?:zwa_chat_messages LIKE 'created_at'");
    if (!$m_col_created) {
        db_query("ALTER TABLE ?:zwa_chat_messages ADD COLUMN created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP AFTER message");
    }

    // Ensure index on chat_id for FK and lookups
    $m_idx_chat = db_get_row("SHOW INDEX FROM ?:zwa_chat_messages WHERE Key_name = 'chat_id'");
    if (!$m_idx_chat) {
        @db_query("ALTER TABLE ?:zwa_chat_messages ADD INDEX chat_id (chat_id)");
    }

    // Best-effort FK (safe): only add when it doesn't exist AND there are no orphan rows.
    $has_fk = false;
    $create = db_get_row("SHOW CREATE TABLE ?:zwa_chat_messages");
    if (is_array($create)) {
        foreach ($create as $v) {
            if (is_string($v) && strpos($v, 'CONSTRAINT `fk_zwa_chat_messages_session`') !== false) {
                $has_fk = true;
                break;
            }
        }
    }

    // Count messages that point to a non-existent session
    $orphans = (int) db_get_field("
        SELECT COUNT(*)
        FROM ?:zwa_chat_messages m
        LEFT JOIN ?:zwa_chat_sessions s ON s.chat_id = m.chat_id
        WHERE s.chat_id IS NULL
    ");

    if (!$has_fk) {
        if ($orphans === 0) {
            try {
                db_query("ALTER TABLE ?:zwa_chat_messages
                          ADD CONSTRAINT fk_zwa_chat_messages_session
                          FOREIGN KEY (chat_id) REFERENCES ?:zwa_chat_sessions(chat_id)
                          ON DELETE CASCADE");
            } catch (\Throwable $e) {
                // Log but do not break request flow
                error_log('ZwaChat FK add skipped: ' . $e->getMessage());
            }
        } else {
            // Defer FK creation until data is clean
            error_log('ZwaChat FK not added: ' . $orphans . ' orphan message(s) without matching session.');
        }
    }
    // upsert session + insert message
    $row = db_get_row("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1", $session);
    if ($row && !empty($row['chat_id'])) {
        $chat_id = (int) $row['chat_id'];
        db_query("UPDATE ?:zwa_chat_sessions SET last_activity = NOW(), last_message = ?s WHERE chat_id = ?i", $message, $chat_id);
    } else {
        db_query("REPLACE INTO ?:zwa_chat_sessions (user_phone, status, last_activity, last_message) VALUES (?s, 'open', NOW(), ?s)", $session, $message);
        $chat_id = (int) db_get_field("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1", $session);
    }

    db_query("INSERT INTO ?:zwa_chat_messages (chat_id, sender, channel, message, created_at) VALUES (?i, ?s, ?s, ?s, NOW())",
        $chat_id, $sender, $channel, $message
    );

    header('Content-Type: application/json; charset=utf-8');
    fn_echo(json_encode(['ok' => true, 'chat_id' => $chat_id]));
    exit;
}

if ($_REQUEST['dispatch'] === 'zwa_chat.log') {
    header('Content-Type: application/json');
    $data = json_decode(file_get_contents('php://input'), true);
    fn_zwa_chat_write_log($data['type'], $data['message']);
    echo json_encode(['status' => 'ok']);
    exit;
}
