<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

use Tygh\Registry;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Your chat logic here (get data, reply, etc.)
    $data = json_decode(file_get_contents('php://input'), true);

    // Respond with JSON
    header('Content-Type: application/json');
    echo json_encode(['ok' => true, 'reply' => 'ZwaChat response!']);
    exit;
}