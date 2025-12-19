{** block-description:abt__ut2__my_account **}

<div class="ut2-account-info">
    {assign var="return_current_url" value=$config.current_url|escape:url}
    
    {if $auth.user_id}
        {if $user_info.firstname || $user_info.lastname}
            <div class="ut2-account-info__avatar">{fn_substr($user_info.firstname, 0, 1)}</div>
            <p><a class="ut2-account-info__a" href="{"profiles.update"|fn_url}" rel="nofollow">{$user_info.firstname} {$user_info.lastname}<br/><span>{$user_info.email}</span>
            </a></p>
        {/if}

        <div class="ut2-account-info__buttons">
            {if $auth.user_id}
                {$is_vendor_with_active_company="MULTIVENDOR"|fn_allowed_for && ($auth.user_type == "V") && ($auth.company_status == "A")}
                {if $is_vendor_with_active_company}
                    <a href="{$config.vendor_index|fn_url}" rel="nofollow" class="ty-btn ty-btn__primary" target="_blank">{__("go_to_admin_panel")}</a>
                {/if}
                <a href="{"auth.logout?redirect_url=`$return_current_url`"|fn_url}" rel="nofollow" class="ty-btn {if $is_vendor_with_active_company}ty-btn__tertiary{else}ty-btn__primary{/if}">{__("sign_out")}</a>
            {else}
                <a href="{if $runtime.controller == "auth" && $runtime.mode == "login_form"}{$config.current_url|fn_url}{else}{"auth.login_form?return_url=`$return_current_url`"|fn_url}{/if}" data-ca-target-id="login_block{$block.snapping_id}" class="cm-dialog-opener cm-dialog-auto-size ty-btn ty-btn__secondary" rel="nofollow">{__("sign_in")}</a><a href="{"profiles.add"|fn_url}" rel="nofollow" class="ty-btn ty-btn__primary">{__("register")}</a>
                <div  id="login_block{$block.snapping_id}" class="hidden" title="{__("sign_in")}">
                    <div class="ty-login-popup">
                        {include file="views/auth/login_form.tpl" style="popup" id="popup`$block.snapping_id`"}
                    </div>
                </div>
            {/if}
        </div>
        
    {else}
        <div class="ut2-account-info__avatar"><i class="ut2-icon-outline-account-circle"></i></div>
        <p><a href="{if $runtime.controller == "auth" && $runtime.mode == "login_form"}{$config.current_url|fn_url}{else}{"auth.login_form?return_url=`$return_current_url`"|fn_url}{/if}" data-ca-target-id="login_block{$block.snapping_id}" data-ca-dialog-title="{__("sign_in")}" class="underlined cm-dialog-opener cm-dialog-auto-size" rel="nofollow">{__("sign_in")}</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href="{"profiles.add"|fn_url}" class="underlined" rel="nofollow">{__("register")}</a><br/><span>{__("abt__ut2_sign_in_please")}</span></p>
    {/if}
<!--account_info_{$block.snapping_id}--></div>

{if $settings.abt__device == "mobile"}
    {assign var="return_current_url" value=$config.current_url|escape:url}
    <nav class="ut2-fm ut2-account-links">
        <div class="ut2-fmw toggle-it">
        <div class="ut2-mt">{__("account")}<i></i></div>
        <div class="ut2-lfl">
            <p><a href="{"orders.search"|fn_url}" rel="nofollow">{__("orders")}</a></p>
            <p><a href="{"wishlist.view"|fn_url}" rel="nofollow">{__("wishlist")}</a></p>

            {if $settings.General.enable_compare_products == 'Y'}
                {$compared_products_ids = $smarty.session.comparison_list}
                <p><a href="{"product_features.compare"|fn_url}" rel="nofollow">{__("comparison_list")}{if $compared_products_ids} ({$compared_products_ids|count}){/if}</a></p>
            {/if}
            
            {if $settings.General.enable_edp == "YesNo::YES"|enum}
                <p><a href="{"orders.downloads"|fn_url}" rel="nofollow">{__("downloads")}</a></p>
            {/if}
        </div>
        {if $settings.Appearance.display_track_orders == 'Y'}
            <div class="ty-account-info__orders updates-wrapper track-orders" id="track_orders_block_{$block.snapping_id}">
                <form action="{""|fn_url}" method="POST" class="cm-ajax cm-post cm-ajax-full-render" name="track_order_quick">
                    <input type="hidden" name="result_ids" value="track_orders_block_*" />
                    <input type="hidden" name="return_url" value="{$smarty.request.return_url|default:$config.current_url}" />
        
                    <div class="ty-account-info__orders-txt">{__("track_my_order")}</div>
        
                    <div class="ty-account-info__orders-input ty-control-group ty-input-append">
                        <label for="track_order_item{$block.snapping_id}" class="cm-required hidden">{__("track_my_order")}</label>
                        <input type="text" size="20" class="ty-input-text cm-hint" id="track_order_item{$block.snapping_id}" name="track_data" value="{__("order_id")}{if !$auth.user_id}/{__("email")}{/if}" />
                        {include file="buttons/go.tpl" but_name="orders.track_request" alt=__("go")}
                        {include file="common/image_verification.tpl" option="track_orders" align="left" sidebox=true}
                    </div>
                </form>
                <!--track_orders_block_{$block.snapping_id}--></div>
        {/if}
        </div>
    </nav>
{/if}
