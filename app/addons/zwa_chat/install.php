<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * Runs on add-on installation. Creates the zwa_chat_messages and zwa_chat_logs tables.
 */
function fn_zwa_chat_install() {
    db_query("
        CREATE TABLE IF NOT EXISTS ?:zwa_chat_messages (
            message_id VARCHAR(64) NOT NULL,
            sender     VARCHAR(32) NOT NULL,
            chat_id    VARCHAR(64) NOT NULL,
            body       TEXT,
            timestamp  INT UNSIGNED,
            PRIMARY KEY (message_id)
        ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
    ");
    db_query("
        CREATE TABLE IF NOT EXISTS ?:zwa_chat_logs (
            log_id     INT AUTO_INCREMENT,
            message_id VARCHAR(64) NOT NULL,
            status     VARCHAR(32),
            updated_at INT UNSIGNED,
            PRIMARY KEY (log_id),
            INDEX (message_id)
        ) ENGINE=MyISAM DEFAULT CHARSET=utf8;
    ");
}
