<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

/**
 * Add ZwaChat entries under the existing "Customers" central menu.
 * We extend the schema safely without overwriting existing groups.
 */

$schema = (array) $schema;

// Ensure root nodes exist
if (!isset($schema['central']) || !is_array($schema['central'])) {
    $schema['central'] = [];
}
if (!isset($schema['central']['customers']) || !is_array($schema['central']['customers'])) {
    $schema['central']['customers'] = [
        'position' => 300,
        'items'    => [],
    ];
}
if (!isset($schema['central']['customers']['items']) || !is_array($schema['central']['customers']['items'])) {
    $schema['central']['customers']['items'] = [];
}

// Main ZwaChat node in Customers
$schema['central']['customers']['items']['zwa_chat'] = [
    'attrs'     => ['class' => 'is-addon'],
    'href'      => 'zwa_chat.manage',
    'position'  => 995,
    'subitems'  => [
        'live_messages' => [
            'href'     => 'zwa_chat.manage',
            'position' => 10,
        ],
        'live_list' => [
            'href'     => 'zwa_chat.live_list',
            'position' => 20,
        ],
    ],
];

return $schema;
