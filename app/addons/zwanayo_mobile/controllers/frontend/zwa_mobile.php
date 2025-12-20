<?php

if (!defined('BOOTSTRAP')) { die('Access denied'); }

if ($_SERVER['REQUEST_METHOD'] === 'GET' && $mode === 'orders') {
    header('Content-Type: application/json; charset=utf-8');

    $page = isset($_REQUEST['page']) ? max(1, (int) $_REQUEST['page']) : 1;
    $items_per_page = isset($_REQUEST['items_per_page']) ? (int) $_REQUEST['items_per_page'] : 10;
    $items_per_page = $items_per_page > 0 ? min($items_per_page, 100) : 10;

    if (empty($auth['user_id'])) {
        fn_set_status_header(401);
        fn_echo(json_encode([
            'error' => true,
            'message' => 'Unauthorized',
            'orders' => [],
            'pagination' => [
                'page' => $page,
                'items_per_page' => $items_per_page,
                'total_items' => 0,
            ],
        ]));
        exit;
    }

    $params = [
        'user_id'        => $auth['user_id'],
        'page'           => $page,
        'items_per_page' => $items_per_page,
        'sort_by'        => 'date',
        'sort_order'     => 'desc',
    ];

    list($orders, $search) = fn_get_orders($params, 0);

    $mapped_orders = array_values(array_map(static function ($order) {
        return [
            'order_id'  => isset($order['order_id']) ? (int) $order['order_id'] : 0,
            'status'    => isset($order['status']) ? (string) $order['status'] : '',
            'total'     => isset($order['total']) ? (float) $order['total'] : 0,
            'timestamp' => isset($order['timestamp']) ? (int) $order['timestamp'] : 0,
        ];
    }, $orders ?: []));

    $result = [
        'orders' => $mapped_orders,
        'pagination' => [
            'page'           => isset($search['page']) ? (int) $search['page'] : $page,
            'items_per_page' => isset($search['items_per_page']) ? (int) $search['items_per_page'] : $items_per_page,
            'total_items'    => isset($search['total_items']) ? (int) $search['total_items'] : 0,
        ],
    ];

    fn_echo(json_encode($result));
    exit;
}

return [CONTROLLER_STATUS_NO_PAGE];
