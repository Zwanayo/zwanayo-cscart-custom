<?php
use Tygh\Registry;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

/*
if ($mode === 'place_order' && !empty($order_id)) {
    $order_info = fn_get_order_info($order_id);

    $data = [
        'order_id' => $order_info['order_id'],
        'order_status' => $order_info['status'],
        'total' => $order_info['total'],
        'customer' => [
            'name' => $order_info['firstname'] . ' ' . $order_info['lastname'],
            'phone' => $order_info['phone']
        ]
    ];

    fn_log_event('general', 'notice', '🔥 Order webhook fired for order_id ' . $order_info['order_id']);
    fn_http_post_json('https://chat.zwanayo.com/orders/hook', $data);
}
*/
