<?php
use Tygh\Registry;
use Tygh\Db\Connection as Db;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * GET /5M84iEg4I.php?dispatch=zwachat_admin.feed&since_id=0&limit=50
 * Admin-only JSON feed of recent chat messages.
 */
if ($mode === 'feed') {
    // Require admin session
    if (AREA !== 'A' || empty($_SESSION['auth']['user_id']) || $_SESSION['auth']['user_type'] !== 'A') {
        return [CONTROLLER_STATUS_DENIED];
    }

    header('Content-Type: application/json; charset=utf-8');

    $since_id = isset($_REQUEST['since_id']) ? (int) $_REQUEST['since_id'] : 0;
    $limit    = isset($_REQUEST['limit']) ? max(1, min(100, (int) $_REQUEST['limit'])) : 50;

    // Table name; adjust if your prefix differs
    $table = Registry::ifGet('config.table_prefix', 'cscart_') . 'zwa_chat_log';

    // If your logging helper writes to a different table/fields, modify this SELECT.
    /** @var Db $db */
    $db = Tygh::$app['db'];

    if ($since_id > 0) {
        $rows = $db->getArray(
            "SELECT id, session, sender, channel, message AS text, created_at AS ts
             FROM ?:`$table`
             WHERE id > ?i
             ORDER BY id DESC
             LIMIT ?i",
            $since_id, $limit
        );
    } else {
        $rows = $db->getArray(
            "SELECT id, session, sender, channel, message AS text, created_at AS ts
             FROM ?:`$table`
             ORDER BY id DESC
             LIMIT ?i",
            $limit
        );
    }

    // Normalize timestamps → ms
    foreach ($rows as &$r) {
        if (!empty($r['ts']) && !is_numeric($r['ts'])) {
            $r['ts'] = (strtotime($r['ts']) ?: time()) * 1000;
        } else {
            $r['ts'] = (int) $r['ts'];
            if ($r['ts'] < 10_000_000_000) { $r['ts'] *= 1000; } // sec → ms
        }
    }
    unset($r);

    echo json_encode([
        'ok'        => true,
        'count'     => count($rows),
        'max_id'    => $rows ? max(array_column($rows, 'id')) : $since_id,
        'messages'  => $rows,
    ], JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    exit;
}
