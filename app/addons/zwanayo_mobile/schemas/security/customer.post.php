<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

$schema['zwa_mobile'] = [
    'modes' => [
        'orders' => [
            'permissions' => true,
        ],
    ],
];

return $schema;
