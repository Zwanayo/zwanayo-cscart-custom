<?php

defined('BOOTSTRAP') or die('Access denied');

/**
 * Hook handler: runs when a company (vendor) is updated.
 * Signature-agnostic: we rely on globals instead of parameters,
 * so it works with both update_company and update_company_post hooks.
 */
function fn_zwanayo_vendor_compliance_update_company($company_data)
{
    _fn_zwanayo_vendor_compliance_handle_nui_and_contract();
}

/**
 * Hook handler: post-hook variant for update_company.
 */
function fn_zwanayo_vendor_compliance_update_company_post($company_data)
{
    _fn_zwanayo_vendor_compliance_handle_nui_and_contract();
}

/**
 * Core NUI upload + contract acceptance logic, shared by both hooks.
 */
function _fn_zwanayo_vendor_compliance_handle_nui_and_contract()
{
    // Must be a logged-in vendor
    if (empty($_SESSION['auth']) || $_SESSION['auth']['user_type'] !== 'V') {
        return;
    }

    // Company ID must be present
    if (empty($_REQUEST['company_id'])) {
        return;
    }

    $company_id = (int) $_REQUEST['company_id'];

    // ---------------------------
    // 1) CONTRACT ACCEPTANCE
    // ---------------------------
    $current_version = '1.0';

    if (!empty($_REQUEST['company_data']['zwanayo_accept_contract'])) {
        $ip = isset($_SERVER['REMOTE_ADDR']) ? $_SERVER['REMOTE_ADDR'] : '';
        $ua = isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : '';

        db_query(
            'UPDATE ?:companies 
             SET contract_version = ?s,
                 contract_accepted_at = NOW(),
                 contract_accepted_ip = ?s,
                 contract_accepted_ua = ?s
             WHERE company_id = ?i',
            $current_version,
            $ip,
            $ua,
            $company_id
        );

        fn_set_notification('N', __('notice'), 'Contrat Zwanayo accepté (version ' . $current_version . ').');
    }

    // ---------------------------
    // 2) NUI UPLOAD (only if file present)
    // ---------------------------
    if (empty($_FILES['nui']) || empty($_FILES['nui']['tmp_name'])) {
        // No file => nothing to do on NUI side
        return;
    }

    $allowed = [
        'application/pdf',
        'image/jpeg',
        'image/png',
    ];

    if (!in_array($_FILES['nui']['type'], $allowed, true)) {
        fn_set_notification('E', __('error'), 'Invalid NUI file type');
        return;
    }

    // Directory under var/files
    $base_dir = rtrim(fn_get_files_dir_path(), '/\\') . '/vendor_nui/';
    fn_mkdir($base_dir);

    $ext = pathinfo($_FILES['nui']['name'], PATHINFO_EXTENSION);
    if ($ext === '') {
        $ext = 'dat';
    }

    $filename = 'nui_' . $company_id . '_' . TIME . '.' . $ext;
    $path     = $base_dir . $filename;

    if (!move_uploaded_file($_FILES['nui']['tmp_name'], $path)) {
        fn_set_notification('E', __('error'), 'NUI upload failed');
        return;
    }

    db_query(
        'UPDATE ?:companies 
         SET nui_document_path = ?s,
             nui_uploaded_at = NOW(),
             nui_status = ?s
         WHERE company_id = ?i',
        $path,
        'pending',
        $company_id
    );

    fn_set_notification('N', __('notice'), 'NUI uploaded successfully');
}
