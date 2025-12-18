<?php
use Tygh\Registry;
use Tygh\Http;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

// --- CORS helper for admin JSON endpoints ---
if (!function_exists('fn_zwa_chat_send_cors')) {
    function fn_zwa_chat_send_cors() {
        $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
        if ($origin) {
            header('Access-Control-Allow-Origin: ' . $origin);
            header('Vary: Origin');
        } else {
            $proto_host = isset($_SERVER['HTTP_HOST']) ? (fn_get_storefront_protocol() . '://' . $_SERVER['HTTP_HOST']) : '*';
            header('Access-Control-Allow-Origin: ' . $proto_host);
        }
        header('Access-Control-Allow-Credentials: true');
        header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
        header('Access-Control-Allow-Headers: Origin, Content-Type, Authorization, X-Requested-With, X-Zwa-Token, X-Zwa-Admin-Key, X-API-Key, x-api-key, api_key');
        header('Access-Control-Max-Age: 86400');
    }
}

// Handle CORS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    fn_zwa_chat_send_cors();
    http_response_code(204);
    exit;
}

// --- Utility: send raw JSON and exit ---
if (!function_exists('zwa_json')) {
    function zwa_json($data, $status = 200) {
        http_response_code($status);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($data);
        exit;
    }
}

// --- Schema helpers (cached) ---
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
        if (zwa_has_column($table, 'id')) return 'ORDER BY id ASC';
        if (zwa_has_column($table, 'message_id')) return 'ORDER BY message_id ASC';
        if (zwa_has_column($table, 'created_at')) return 'ORDER BY created_at ASC';
        return '';
    }
}

// ────────────────────────────────────────────────────────────────────────────
// LIVE CHAT PIPE (Node ↔ CS‑Cart Admin) — schema‑aware, non‑destructive
// ────────────────────────────────────────────────────────────────────────────
// POST /index.php?dispatch=zwa_chat.live_save
// Body: { session_id, role: 'user'|'bot'|'admin', text, meta? }
// Auth: header X-Zwa-Token must equal addons.zwa_chat.admin_api_key
if ($mode === 'live_save' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    fn_zwa_chat_send_cors();
    $settings = Registry::get('addons.zwa_chat');
    $expected = (string) ($settings['admin_api_key'] ?? '');
    $got = $_SERVER['HTTP_X_ZWA_TOKEN'] ?? '';
    if (!$expected || $got !== $expected) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }

    $p = json_decode(file_get_contents('php://input'), true) ?: [];
    $session_id = trim((string) ($p['session_id'] ?? ''));
    $role       = trim((string) ($p['role'] ?? ''));
    $text       = (string) ($p['text'] ?? '');
    $meta       = isset($p['meta']) ? json_encode($p['meta']) : null;

    if ($session_id === '' || $text === '' || !in_array($role, ['user','bot','admin'], true)) {
        zwa_json(['ok' => false, 'error' => 'invalid'], 400);
    }

    // Prefer conversation-based schema if present
    $has_conversations = (bool) db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'");
    $use_conversations = $has_conversations && zwa_has_column('?:zwa_chat_messages', 'conversation_id');

    if ($use_conversations) {
        // Map session -> conversation via conversations table if possible
        $conversation_id = 0;
        if (zwa_has_column('?:zwa_chat_conversations', 'external_session')) {
            $conversation_id = (int) db_get_field(
                "SELECT conversation_id FROM ?:zwa_chat_conversations WHERE external_session = ?s LIMIT 1",
                $session_id
            );
            if (!$conversation_id) {
                $conversation_id = db_query("INSERT INTO ?:zwa_chat_conversations ?e", [
                    'external_session'   => $session_id,
                    'last_message_time'  => date('Y-m-d H:i:s'),
                ]);
            }
        } else {
            // Fallback: create a conversation row if none exist yet
            $conversation_id = (int) db_get_field("SELECT conversation_id FROM ?:zwa_chat_conversations ORDER BY conversation_id DESC LIMIT 1");
            if (!$conversation_id) {
                $conversation_id = db_query("INSERT INTO ?:zwa_chat_conversations ?e", [
                    'last_message_time' => date('Y-m-d H:i:s'),
                ]);
            }
        }

        $row = [
            'conversation_id' => (int) $conversation_id,
            'sender'          => ($role === 'user' ? 'customer' : ($role === 'admin' ? 'admin' : 'bot')),
            'channel'         => 'site',
            'message'         => $text,
            'created_at'      => date('Y-m-d H:i:s'),
        ];
        if (zwa_has_column('?:zwa_chat_messages', 'meta')) {
            $row['meta'] = $meta;
        }
        db_query("INSERT INTO ?:zwa_chat_messages ?e", $row);
        db_query(
            "UPDATE ?:zwa_chat_conversations SET last_message_time = ?s WHERE conversation_id = ?i",
            date('Y-m-d H:i:s'),
            (int) $conversation_id
        );
        zwa_json(['ok' => true, 'conversation_id' => (int) $conversation_id]);
    } else {
        // Session-based schema (sessions/chat_id/messages)
        $has_sessions = (bool) db_get_field("SHOW TABLES LIKE '?:zwa_chat_sessions'");
        $has_messages = (bool) db_get_field("SHOW TABLES LIKE '?:zwa_chat_messages'");
        if (!$has_sessions || !$has_messages) {
            zwa_json(['ok' => false, 'error' => 'schema-missing'], 500);
        }

        // Treat widget session as a pseudo-identifier in user_phone
        $user_phone = $session_id;
        $row = db_get_row("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1", $user_phone);
        if ($row && !empty($row['chat_id'])) {
            $chat_id = (int) $row['chat_id'];
            db_query("UPDATE ?:zwa_chat_sessions SET last_activity = NOW(), last_message = ?s WHERE chat_id = ?i", $text, $chat_id);
        } else {
            db_query("REPLACE INTO ?:zwa_chat_sessions (user_phone, status, last_activity, last_message) VALUES (?s, 'open', NOW(), ?s)", $user_phone, $text);
            $chat_id = (int) db_get_field("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s LIMIT 1", $user_phone);
        }

        $row = [
            'chat_id'    => (int) $chat_id,
            'sender'     => in_array($role, ['user','bot','admin'], true) ? $role : 'user',
            'channel'    => 'site',
            'message'    => $text,
            'created_at' => date('Y-m-d H:i:s'),
        ];
        if (zwa_has_column('?:zwa_chat_messages', 'meta')) {
            $row['meta'] = $meta;
        }
        db_query("INSERT INTO ?:zwa_chat_messages ?e", $row);
        zwa_json(['ok' => true, 'chat_id' => (int) $chat_id]);
    }
}

// GET /index.php?dispatch=zwa_chat.live_list
if ($mode === 'live_list' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    fn_zwa_chat_send_cors();
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
    zwa_json(['ok' => true, 'threads' => $threads]);
}

// GET /index.php?dispatch=zwa_chat.live_messages&conversation_id=... or &session_id=...
if ($mode === 'live_messages' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    fn_zwa_chat_send_cors();
    $use_conversations = (bool) (db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'")
                          && zwa_has_column('?:zwa_chat_messages', 'conversation_id'));

    $conversation_id = 0;
    $session_id = '';
    $messages = [];

    if ($use_conversations) {
        $conversation_id = (int) ($_REQUEST['conversation_id'] ?? 0);
        if ($conversation_id) {
            $order = zwa_order_clause('?:zwa_chat_messages');
            $messages = db_get_array("
                SELECT * FROM ?:zwa_chat_messages
                WHERE conversation_id = ?i
                {$order}
            ", $conversation_id);
        }
    } else {
        $conversation_id = (int) ($_REQUEST['conversation_id'] ?? 0);
        if (!$conversation_id && !empty($_REQUEST['session_id'])) {
            $conversation_id = (int) db_get_field("SELECT chat_id FROM ?:zwa_chat_sessions WHERE user_phone = ?s", (string) $_REQUEST['session_id']);
        }
        if ($conversation_id) {
            $order = zwa_order_clause('?:zwa_chat_messages');
            $messages = db_get_array("
                SELECT * FROM ?:zwa_chat_messages
                WHERE chat_id = ?i
                {$order}
            ", $conversation_id);
            $session_id = (string) db_get_field("SELECT user_phone FROM ?:zwa_chat_sessions WHERE chat_id = ?i", $conversation_id);
        }
    }

    zwa_json(['ok' => true, 'conversation_id' => $conversation_id, 'session_id' => $session_id, 'messages' => $messages]);
}

// POST /index.php?dispatch=zwa_chat.live_reply
if ($mode === 'live_reply' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    fn_zwa_chat_send_cors();
    $text = (string) ($_REQUEST['text'] ?? '');
    $conversation_id = (int) ($_REQUEST['conversation_id'] ?? 0);
    if ($text === '' || !$conversation_id) {
        zwa_json(['ok' => false, 'error' => 'missing'], 400);
    }

    $use_conversations = (bool) (db_get_field("SHOW TABLES LIKE '?:zwa_chat_conversations'")
                          && zwa_has_column('?:zwa_chat_messages', 'conversation_id'));

    if ($use_conversations) {
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'conversation_id' => $conversation_id,
            'sender'          => 'admin',
            'channel'         => 'site',
            'message'         => $text,
            'created_at'      => date('Y-m-d H:i:s'),
        ]);
    } else {
        db_query("INSERT INTO ?:zwa_chat_messages ?e", [
            'chat_id'    => $conversation_id,
            'sender'     => 'admin',
            'channel'    => 'site',
            'message'    => $text,
            'created_at' => date('Y-m-d H:i:s'),
        ]);
    }

    // Forward to Node
    $settings  = Registry::get('addons.zwa_chat');
    $api_url   = rtrim((string) ($settings['api_base'] ?? $settings['api_url'] ?? ''), '/');
    $admin_key = (string) ($settings['admin_api_key'] ?? '');
    if ($api_url && $admin_key) {
        // Resolve session id if we can
        $session = '';
        if ($use_conversations && zwa_has_column('?:zwa_chat_conversations', 'external_session')) {
            $session = (string) db_get_field("SELECT external_session FROM ?:zwa_chat_conversations WHERE conversation_id = ?i", $conversation_id);
        } else {
            $session = (string) db_get_field("SELECT user_phone FROM ?:zwa_chat_sessions WHERE chat_id = ?i", $conversation_id);
        }

        $endpoint = $api_url . '/admin-reply';
        $payload  = [
            'session_id' => $session,
            'text'       => $text,
        ];
        $headers = [
            'Content-Type: application/json',
            'X-Zwa-Admin-Key: ' . $admin_key,
        ];
        try {
            $response = Http::post($endpoint, json_encode($payload), $headers);
        } catch (\Exception $e) {
            // Swallow errors; admin reply is already saved locally.
        }
    }

    zwa_json(['ok' => true]);
}

/**
 * ========== PUBLIC ENDPOINTS ==========
 */

// Send message (customer/site/whatsapp)
if ($mode === 'send_message' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    fn_zwa_chat_send_cors();

    $session_id = trim((string) ($_REQUEST['session_id'] ?? ''));
    $message    = trim((string) ($_REQUEST['message'] ?? ''));
    $channel    = trim((string) ($_REQUEST['channel'] ?? 'site'));
    $sender     = trim((string) ($_REQUEST['sender'] ?? 'user'));

    if ($session_id === '' || $message === '') {
        zwa_json(['ok' => false, 'error' => 'Missing session_id or message'], 400);
    }

    db_query(
        "INSERT INTO ?:zwa_chat_logs (session_id, sender, message, channel, created_at) VALUES (?s, ?s, ?s, ?s, NOW())",
        $session_id, $sender, $message, $channel
    );

    db_query("
        INSERT INTO ?:zwa_chat_sessions (session_id, last_message, last_activity, status, customer_name, user_phone)
        VALUES (?s, ?s, NOW(), 'open', ?s, ?s)
        ON DUPLICATE KEY UPDATE last_message = VALUES(last_message), last_activity = NOW(), status = 'open',
                                customer_name = IF(VALUES(customer_name) <> '', VALUES(customer_name), customer_name),
                                user_phone = IF(VALUES(user_phone) <> '', VALUES(user_phone), user_phone)
    ", $session_id, $message, ($_REQUEST['customer_name'] ?? ''), ($_REQUEST['user_phone'] ?? ''));

    zwa_json(['ok' => true]);
}

/**
 * ========== ADMIN ENDPOINTS ==========
 */

// Mark session as read
if ($mode === 'mark_read' && $_SERVER['REQUEST_METHOD'] === 'POST') {
    fn_zwa_chat_send_cors();
    $session_id = trim((string) ($_REQUEST['session_id'] ?? ''));
    if ($session_id === '') {
        zwa_json(['ok' => false, 'error' => 'missing session_id'], 400);
    }
    db_query("UPDATE ?:zwa_chat_sessions SET status = 'open' WHERE session_id = ?s", $session_id);
    zwa_json(['ok' => true]);
}

// Fetch sessions
if ($mode === 'sessions_json' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    fn_zwa_chat_send_cors();
    $rows = db_get_array("
        SELECT session_id, user_phone, customer_name, last_message, last_activity, status
        FROM ?:zwa_chat_sessions
        ORDER BY last_activity DESC
        LIMIT 100
    ");
    zwa_json(['ok' => true, 'items' => $rows]);
}
            // Fetch logs
            if ($mode === 'logs_json' && $_SERVER['REQUEST_METHOD'] === 'GET') {
                fn_zwa_chat_send_cors();

                $session_id = trim((string) ($_REQUEST['session_id'] ?? ''));
                $q          = trim((string) ($_REQUEST['q'] ?? ''));
                $channel    = trim((string) ($_REQUEST['channel'] ?? ''));
                $sender     = trim((string) ($_REQUEST['sender'] ?? ''));
                $from       = trim((string) ($_REQUEST['from'] ?? ''));
                $to         = trim((string) ($_REQUEST['to'] ?? ''));

                $page     = max(1, (int) ($_REQUEST['page'] ?? 1));
                $per_page = max(1, min(100, (int) ($_REQUEST['per_page'] ?? ($_REQUEST['limit'] ?? 20))));
                $offset   = ($page - 1) * $per_page;

                $where = [];
                $params = [];

                if ($session_id !== '') {
                    $where[] = "session_id = ?s";
                    $params[] = $session_id;
                }
                if ($q !== '') {
                    $like = '%' . $q . '%';
                    $where[] = "(message LIKE ?l OR user_phone LIKE ?l OR session_id LIKE ?l)";
                    $params[] = $like; $params[] = $like; $params[] = $like;
                }
                if ($channel !== '') {
                    $where[] = "channel = ?s";
                    $params[] = $channel;
                }
                if ($sender !== '') {
                    $where[] = "sender = ?s";
                    $params[] = $sender;
                }
                if ($from !== '') {
                    $where[] = "created_at >= ?s";
                    $params[] = $from . " 00:00:00";
                }
                if ($to !== '') {
                    $where[] = "created_at <= ?s";
                    $params[] = $to . " 23:59:59";
                }

                $where_sql = $where ? ("WHERE " . implode(" AND ", $where)) : '';

                $sql = "
                    SELECT id, session_id, sender, message, channel, created_at
                    FROM ?:zwa_chat_logs
                    $where_sql
                    ORDER BY created_at DESC
                    LIMIT ?i OFFSET ?i
                ";

                $logs = db_get_array($sql, ...array_merge($params, [$per_page, $offset]));

                $total = (int) db_get_field(
                    "SELECT COUNT(*) FROM ?:zwa_chat_logs $where_sql",
                    ...$params
                );

                $pages = max(1, ceil($total / $per_page));

                zwa_json([
                    'ok'    => true,
                    'items' => $logs,
                    'page'  => $page,
                    'total' => $total,
                    'pages' => $pages,
                ]);
            }

// Get messages for a session
if ($mode === 'get_messages' && $_SERVER['REQUEST_METHOD'] === 'GET') {
    fn_zwa_chat_send_cors();
    $session_id = trim((string) ($_REQUEST['session_id'] ?? ''));
    if ($session_id === '') {
        zwa_json(['ok' => false, 'error' => 'missing session_id'], 400);
    }
    $msgs = db_get_array(
        "SELECT id, session_id, sender, message, channel, created_at
         FROM ?:zwa_chat_logs
         WHERE session_id = ?s
         ORDER BY created_at ASC",
        $session_id
    );
    zwa_json(['ok' => true, 'messages' => $msgs]);
}

/**
 * ========== ADMIN PAGE ==========
 */
if ($mode === 'manage') {
    $stats = [
        'total_messages'    => fn_zwa_chat_get_total_messages(),
        'open_chats'        => fn_zwa_chat_get_open_chats(),
        'resolved_chats'    => fn_zwa_chat_get_resolved_chats(),
        'avg_response_time' => fn_zwa_chat_get_avg_response_time(),
    ];

    Tygh::$app['view']->assign('stats', $stats);
    $logs = db_get_array("SELECT * FROM ?:zwa_chat_logs ORDER BY created_at DESC LIMIT 20");
    Tygh::$app['view']->assign('logs', $logs);
    Tygh::$app['view']->assign('zwa_config', fn_zwa_chat_get_public_config());

    $sessions = db_get_array("SELECT * FROM ?:zwa_chat_sessions ORDER BY last_activity DESC LIMIT 20");
    Tygh::$app['view']->assign('sessions', $sessions);
    Tygh::$app['view']->assign('ws_admin_url', 'wss://chat.zwanayo.com/ws/admin');
    Tygh::$app['view']->assign('zwa_chat_admin_api_key', Registry::get('addons.zwa_chat.admin_api_key') ?: Registry::get('addons.zwa_chat.api_key') ?: '');
    Tygh::$app['view']->assign('zwa_chat_api_key',      Registry::get('addons.zwa_chat.api_key') ?: '');
    Tygh::$app['view']->assign('zwa_chat_api_base',     Registry::get('addons.zwa_chat.api_base') ?: 'https://chat.zwanayo.com/api/zwachat');

    return [
        'template' => 'addons/zwa_chat/views/zwa_chat/manage.tpl'
    ];
}
