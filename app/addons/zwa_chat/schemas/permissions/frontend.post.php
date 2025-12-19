<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }
$schema['zwa_chat']['modes']['admin_log'] = [
    'permissions' => true, // key-gated inside the controller
];
return $schema;
