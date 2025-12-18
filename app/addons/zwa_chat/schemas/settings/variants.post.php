<?php
if (!defined('BOOTSTRAP')) { die('Access denied'); }

$schema = [];

$schema['verify_token'] = [
    'type'           => 'text',
    'default_value'  => '',
    'label'          => __('zwa_chat.verify_token'),
    'tooltip'        => __('zwa_chat.verify_token_hint'),
    'section'        => 'webhook',
];

$schema['whatsapp_account_id'] = [
    'type'           => 'text',
    'default_value'  => '',
    'label'          => __('zwa_chat.whatsapp_account_id'),
    'tooltip'        => __('zwa_chat.whatsapp_account_id_hint'),
    'section'        => 'whatsapp',
];

$schema['whatsapp_phone_id'] = [
    'type'           => 'text',
    'default_value'  => '',
    'label'          => __('zwa_chat.whatsapp_phone_id'),
    'tooltip'        => __('zwa_chat.whatsapp_phone_id_hint'),
    'section'        => 'whatsapp',
];

$schema['whatsapp_access_token'] = [
    'type'           => 'text',
    'default_value'  => '',
    'label'          => __('zwa_chat.whatsapp_access_token'),
    'tooltip'        => __('zwa_chat.whatsapp_access_token_hint'),
    'section'        => 'whatsapp',
];

$schema['whatsapp_app_secret'] = [
    'type'           => 'text',
    'default_value'  => '',
    'label'          => __('zwa_chat.whatsapp_app_secret'),
    'tooltip'        => __('zwa_chat.whatsapp_app_secret_hint'),
    'section'        => 'whatsapp',
];

$schema['openai_api_key'] = [
    'type'           => 'password',
    'default_value'  => '',
    'label'          => __('zwa_chat.openai_api_key'),
    'tooltip'        => __('zwa_chat.openai_api_key_hint'),
    'section'        => 'integration',
];

$schema['debug_signature'] = [
    'type'           => 'checkbox',
    'default_value'  => 'N',
    'label'          => __('zwa_chat.debug_signature'),
    'tooltip'        => __('zwa_chat.debug_signature_hint'),
    'section'        => 'webhook',
];

$schema['node_bot_url'] = [
    'type'          => 'text',
    'default_value' => '',
    'label'         => __('zwa_chat.node_bot_url'),
    'tooltip'       => __('zwa_chat.node_bot_url_hint'),
    'section'       => 'integration',
];

$schema['api_url'] = [
    'type'          => 'text',
    'default_value' => '',
    'label'         => __('zwa_chat.api_url'),
    'tooltip'       => __('zwa_chat.api_url_hint'),
    'section'       => 'integration',
];

$schema['widget_url'] = [
    'type'          => 'text',
    'default_value' => '',
    'label'         => __('zwa_chat.widget_url'),
    'tooltip'       => __('zwa_chat.widget_url_hint'),
    'section'       => 'integration',
];

$schema['node_bot_api_key'] = [
    'type'          => 'password',
    'default_value' => '',
    'label'         => __('zwa_chat.node_bot_api_key'),
    'tooltip'       => __('zwa_chat.node_bot_api_key_hint'),
    'section'       => 'integration',
];

$schema['admin_api_key'] = [
    'type'          => 'password',
    'default_value' => '',
    'label'         => __('zwa_chat.admin_api_key'),
    'tooltip'       => __('zwa_chat.admin_api_key_hint'),
    'section'       => 'integration',
];

return $schema;
