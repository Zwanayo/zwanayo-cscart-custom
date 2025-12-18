<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

$schema['controllers']['zwa_chat'] = [
    'permissions' => [
        'GET'  => 'manage_zwa_chat',
        'POST' => 'manage_zwa_chat',
    ],
    'modes' => [
        'manage' => ['permissions' => 'manage_zwa_chat'],
        'view'   => ['permissions' => 'manage_zwa_chat'],
        'reply'  => ['permissions' => 'manage_zwa_chat'],
        'close'  => ['permissions' => 'manage_zwa_chat'],
        'assign' => ['permissions' => 'manage_zwa_chat'],
    ],
];

$schema['controllers']['api'] = $schema['controllers']['api'] ?? [];
$schema['controllers']['api']['modes']['zwa_chat'] = [
    'permissions' => 'manage_zwa_chat',
];
$schema['controllers']['api']['modes']['status'] = [
    'permissions' => 'manage_zwa_chat',
];

return $schema;
