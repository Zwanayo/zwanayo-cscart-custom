<?php

use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

if ($mode === 'view_nui') {

    // Admin-only
    if (empty($_SESSION['auth']) || $_SESSION['auth']['user_type'] !== 'A') {
        return [CONTROLLER_STATUS_DENIED];
    }

    $company_id = !empty($_REQUEST['company_id']) ? (int) $_REQUEST['company_id'] : 0;
    if (!$company_id) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }

    $company = db_get_row(
        'SELECT company_id, nui_document_path FROM ?:companies WHERE company_id = ?i',
        $company_id
    );

    if (!$company || empty($company['nui_document_path'])) {
        fn_set_notification('E', __('error'), __('file_not_found'));
        return [CONTROLLER_STATUS_REDIRECT, 'companies.update?company_id=' . $company_id];
    }

    $path = $company['nui_document_path'];

    // If stored path is relative, prefix with root dir
    if ($path[0] !== '/' && strpos($path, '://') === false) {
        $path = rtrim(Registry::get('config.dir.root'), '/\\') . '/' . ltrim($path, '/\\');
    }

    if (!file_exists($path) || !is_readable($path)) {
        fn_set_notification('E', __('error'), __('file_not_found'));
        return [CONTROLLER_STATUS_REDIRECT, 'companies.update?company_id=' . $company_id];
    }

    $ext = strtolower(pathinfo($path, PATHINFO_EXTENSION));

    $mime = 'application/octet-stream';
    if ($ext === 'pdf') {
        $mime = 'application/pdf';
    } elseif (in_array($ext, ['jpg', 'jpeg', 'jpe'], true)) {
        $mime = 'image/jpeg';
    } elseif ($ext === 'png') {
        $mime = 'image/png';
    }

    $filename = basename($path);

    // Stream file to browser
    header('Content-Type: ' . $mime);
    header('Content-Disposition: inline; filename="' . $filename . '"');
    header('Content-Length: ' . filesize($path));

    fn_flush();
    readfile($path);
    exit;
}
