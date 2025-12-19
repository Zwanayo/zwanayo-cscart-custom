<?php
defined('BOOTSTRAP') or die('Access denied');

if ($_SERVER['REQUEST_METHOD'] === 'POST' && $mode === 'upload_nui') {

    if (empty($_SESSION['auth'])
        || $_SESSION['auth']['user_type'] !== 'V'
        || empty($_SESSION['auth']['company_id'])
    ) {
        return [CONTROLLER_STATUS_DENIED];
    }

    $vendor_id = (int) $_SESSION['auth']['company_id'];

    if (empty($_FILES['nui']['tmp_name'])) {
        fn_set_notification('E', __('error'), __('no_file_uploaded'));
        return [CONTROLLER_STATUS_REDIRECT, 'companies.update'];
    }

    $allowed = ['application/pdf', 'image/jpeg', 'image/png'];
    if (!in_array($_FILES['nui']['type'], $allowed, true)) {
        fn_set_notification('E', __('error'), __('invalid_file_type'));
        return [CONTROLLER_STATUS_REDIRECT, 'companies.update'];
    }

    $dir = fn_get_files_dir_path() . 'vendor_nui/';
    fn_mkdir($dir);

    $ext = pathinfo($_FILES['nui']['name'], PATHINFO_EXTENSION);
    $filename = 'nui_' . $vendor_id . '_' . TIME . '.' . $ext;
    $path = $dir . $filename;

    if (!move_uploaded_file($_FILES['nui']['tmp_name'], $path)) {
        fn_set_notification('E', __('error'), __('cannot_upload_file'));
        return [CONTROLLER_STATUS_REDIRECT, 'companies.update'];
    }

    db_query(
        'UPDATE ?:companies
         SET nui_document_path = ?s,
             nui_uploaded_at = NOW()
         WHERE company_id = ?i',
        $path,
        $vendor_id
    );

    fn_set_notification('N', __('notice'), 'NUI uploaded successfully');

    return [CONTROLLER_STATUS_REDIRECT, 'companies.update'];
}
