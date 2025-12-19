<?php
// ZwaChat Status API controller – simple health check endpoint for API area.
//
// Usage:
//   GET  /api/?dispatch=status.index   -> { status: "OK", store_name: "...", time: "..." }
//   HEAD /api/?dispatch=status.index   -> 200 with no body
//
// Notes:
// - Runs under API area; CSRF is not required.
// - Keep this controller minimal and side‑effect free.

use Tygh\Api\Response;
use Tygh\Registry;
use Tygh\Tygh;

if (!defined('BOOTSTRAP')) { die('Access denied'); }

$method = isset($_SERVER['REQUEST_METHOD']) ? strtoupper($_SERVER['REQUEST_METHOD']) : 'GET';
$is_get_like = ($method === 'GET' || $method === 'HEAD');

// In API controllers, `$mode` may be unset; normalize to 'index'
if (!isset($mode) || $mode === null || $mode === '') {
    $mode = 'index';
}

if ($mode === 'index') {
    if ($is_get_like) {
        $data = [
            'status'     => 'OK',
            'store_name' => (string) Registry::get('settings.Company.company_name'),
            'time'       => date(DATE_ISO8601),
        ];

        if ($method === 'HEAD') {
            Tygh::$app['api.response']->status = Response::STATUS_OK;
        } else {
            Tygh::$app['api.response']->setData($data);
        }
    } else {
        Tygh::$app['api.response']->status = Response::STATUS_METHOD_NOT_ALLOWED;
    }
} else {
    Tygh::$app['api.response']->status = Response::STATUS_NOT_FOUND;
}
