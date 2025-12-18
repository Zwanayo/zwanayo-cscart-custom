<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

use Tygh\Registry;

// ⬇️ REQUIRED: Register hooks here
fn_register_hooks(
    'place_order',
    'change_order_status_pre',
    'update_addon_status_pre',
    'update_addon_status_post',
    'index:footer'
);

// Register API endpoints so pretty routes like /api/status work without dispatch
if (function_exists('fn_register_api_endpoint')) {
    // GET /api/status  -> status.index (API controller)
    fn_register_api_endpoint('status', 'status.index', ['GET', 'HEAD']);

    // POST /api/log         -> zwa_chat.log
    // POST /api/admin_log   -> zwa_chat.admin_log
    fn_register_api_endpoint('log', 'zwa_chat.log', ['POST']);
    fn_register_api_endpoint('admin_log', 'zwa_chat.admin_log', ['POST']);
}

// (Compat) Also register API controller maps for dispatch-style calls
if (function_exists('fn_register_api_controller')) {
    // /api/?dispatch=status.index
    fn_register_api_controller('status', [
        'index' => ['GET', 'HEAD'],
    ]);
    // /api/?dispatch=zwa_chat.log and zwa_chat.admin_log
    fn_register_api_controller('zwa_chat', [
        'log'       => ['POST'],
        'admin_log' => ['POST'],
    ]);
}

// Optional: Load your class
require_once(Registry::get('config.dir.addons') . 'zwa_chat/src/Bot.php');

// Autoload your class (if needed)
$existing = Registry::get('autoload');
if (!is_array($existing)) {
    $existing = [];
}
Registry::set('autoload', array_merge(
    $existing,
    [
        'ZwaChat\\Bot' => 'app/addons/zwa_chat/src/Bot.php',
    ]
));

// Optional: Run on addon install
function fn_zwa_chat_install()
{
    $sql = <<<SQL
CREATE TABLE IF NOT EXISTS `?:zwa_chat_messages` (
    `message_id` VARCHAR(255) NOT NULL,
    `sender`     VARCHAR(32)  NOT NULL,
    `body`       TEXT         NOT NULL,
    `timestamp`  DATETIME     NOT NULL,
    `status`     VARCHAR(32)  NOT NULL DEFAULT 'received',
    `updated_at` DATETIME     NULL,
    PRIMARY KEY (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SQL;

    db_query($sql);
}
