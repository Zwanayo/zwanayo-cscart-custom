<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

$phone = $_REQUEST['phone'] ?? '';
$messages = db_get_array(
    'SELECT entry_id, sender_phone, message_text, ts 
       FROM ?:zwa_chat_messages
      WHERE sender_phone = ?s
      ORDER BY ts ASC',
    $phone
);

header('Content-Type: application/json');
echo json_encode($messages);
exit;