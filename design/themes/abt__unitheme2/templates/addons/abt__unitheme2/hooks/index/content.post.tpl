{$block_snapping_id_replacement="sticky_item"}
{assign var="dropdown_id" value=$block_snapping_id_replacement}
{assign var="r_url" value=$config.current_url|escape:url}

{$smarty.capture.bottom_content nofilter}

{if $smarty.request.dispatch != 'checkout.checkout'}
<div class="ut2-sticky-panel__wrap {if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}labels-true{/if}">

    {* Add-to-Cart button *}
    {if $settings.abt__ut2.products.view.show_sticky_add_to_cart[$settings.abt__device] == "YesNo::YES"|enum}
        {if !defined("AJAX_REQUEST") || $smarty.request.result_ids == "tygh_main_container"}
            {include file="buttons/sticky_add_to_cart.tpl"}
        {/if}
    {/if}

    {* Sticky panel - links wrap *}
    {if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel[$settings.abt__device] == "YesNo::YES"|enum}

    {hook name="index:sticky_panel"}
    <div class="ut2-sticky-panel">
    
        {* Home *}
        {if $settings.abt__ut2.general.sticky_panel.link_home[$settings.abt__device] == "YesNo::YES"|enum}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.link_home.position}style="order:{$settings.abt__ut2.general.sticky_panel.link_home.position}"{/if}>
        	{$url=""}
        	{if $use_vendor_url && (isset($smarty.request.company_id) || isset($object_id))}
        		{if $smarty.request.company_id}
        			{$url="companies.view&company_id=`$smarty.request.company_id`"}
        		{else}
        			{$url="companies.view&company_id=`$object_id`"}
        		{/if}
        	{/if}
    
        	<a href="{$url|fn_url}" class="ut2-sticky-panel__link{if $smarty.request.dispatch=="index.index"} active{/if}"><i class="ut2-icon-home_page"></i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("home")}</span>{/if}</a>
        </div>
        {/if}
        
        {* Menu *}
        {if $settings.abt__ut2.general.sticky_panel.catalog[$settings.abt__device] == "YesNo::YES"|enum}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.catalog.position}style="order:{$settings.abt__ut2.general.sticky_panel.catalog.position}"{/if}>
    
        	<a class="ut2-sticky-panel__link cm-external-trigger"><i class="ut2-icon-outline-menu"></i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("menu")}</span>{/if}</a>
        </div>
        {/if}

        {* Search *}
        {if $settings.abt__ut2.general.sticky_panel.search[$settings.abt__device] == "YesNo::YES"|enum}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.search.position}style="order:{$settings.abt__ut2.general.sticky_panel.search.position}"{/if}>
            <a id="on_dropdown_{$block_snapping_id_replacement}_search" href="javascript:void(0);" rel="nofollow" class="ut2-btn-search ut2-sticky-panel__link cm-combination cm-abt--ut2-toggle-scroll"><i class="ut2-icon-search"></i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("search")}</span>{/if}</a>
            <a id="off_dropdown_{$block_snapping_id_replacement}_search" href="javascript:void(0);" rel="nofollow" class="ut2-btn-search ut2-sticky-panel__link cm-combination cm-abt--ut2-toggle-scroll" style="display:none;"><i class="ut2-icon-baseline-close"></i></a>

            <div id="dropdown_{$block_snapping_id_replacement}_search" class=" ty-search-block hidden">
                <form action="{""|fn_url}" name="search_form" method="get">
                    <input type="hidden" name="match" value="all" />
                    <input type="hidden" name="subcats" value="Y" />
                    <input type="hidden" name="pcode_from_q" value="Y" />
                    <input type="hidden" name="pshort" value="Y" />
                    <input type="hidden" name="pfull" value="Y" />
                    <input type="hidden" name="pname" value="Y" />
                    <input type="hidden" name="pkeywords" value="Y" />
                    <input type="hidden" name="search_performed" value="Y" />
    
                    {hook name="search:additional_fields"}{/hook}
    
                    {strip}
                        {if $settings.General.search_objects}
                            {assign var="search_title" value=__("search")}
                        {else}
                            {assign var="search_title" value=__("search_products")}
                        {/if}
                        <input type="text" name="q" value="{$search.q}" autocomplete="off" id="search_input{$smarty.capture.search_input_id}" title="{$search_title}" class="ty-search-block__input cm-hint" />
                        {if $settings.General.search_objects}
                            {include file="buttons/magnifier.tpl" but_name="search.results" alt=__("search")}
                        {else}
                            {include file="buttons/magnifier.tpl" but_name="products.search" alt=__("search")}
                        {/if}
                    {/strip}
    
                    {capture name="search_input_id"}{$block_snapping_id_replacement}{/capture}
    
                </form>
            </div>
        </div>
        {/if}
    
        {* Cart mini *}
        {if $settings.abt__ut2.general.sticky_panel.cart[$settings.abt__device] == "YesNo::YES"|enum}
            {$block.properties.products_links_type = "thumb"}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.cart.position}style="order:{$settings.abt__ut2.general.sticky_panel.cart.position}"{/if}>
                <div class="ty-dropdown-box" id="cart_status_{$dropdown_id}">
                    <div id="sw_dropdown_{$dropdown_id}" class="ty-dropdown-box__title cm-combination cm-abt--ut2-toggle-scroll">
                        <a href="{"checkout.cart"|fn_url}" class="ut2-sticky-panel__link" id="cart_icon_{$dropdown_id}">
                            <i class="ut2-icon-use_icon_cart filled">{if $smarty.session.cart.amount}<em class="count">{$smarty.session.cart.amount}</em>{/if}</i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("cart")}</span>{/if}
                        <!--cart_icon_{$dropdown_id}--></a>
                    </div>
                    <div id="dropdown_{$dropdown_id}" class="ty-dropdown-box__content ty-dropdown-box__content--cart hidden">
                        
                        <a href="javascript:void(0);" data-ca-external-click-id="sw_dropdown_{$dropdown_id}" rel="nofollow" class="cm-external-click ut2-btn-close cm-abt--ut2-toggle-scroll" ><i class="ut2-icon-baseline-close"></i></a>
                        <div class="ty-dropdown-box__title">{__("cart")}</div>
                        
                        {hook name="checkout:minicart"}
                            <div class="cm-cart-content cm-cart-content-thumb" id="cart_content_{$dropdown_id}">
                                    <div class="ty-cart-items">
                                        {if $smarty.session.cart.amount}
                                            <ul class="ty-cart-items__list">
                                                {hook name="index:cart_status"}
                                                    {assign var="_cart_products" value=$smarty.session.cart.products|array_reverse:true}
                                                    {foreach from=$_cart_products key="key" item="product" name="cart_products"}
                                                        {hook name="checkout:minicart_product"}
                                                        {if !$product.extra.parent}
                                                            <li class="ty-cart-items__list-item">
                                                                {hook name="checkout:minicart_product_info"}
    
                                                                <div class="ty-cart-items__list-item-image">
                                                                    <a href="{"products.view?product_id=`$product.product_id`"|fn_url}">
                                                                    {include file="common/image.tpl" image_width="40" image_height="40" images=$product.main_pair no_ids=true lazy_load=false}
                                                                    </a>
                                                                </div>
    
                                                                <div class="ty-cart-items__list-item-desc">
                                                                    <a href="{"products.view?product_id=`$product.product_id`"|fn_url}">{$product.product|default:fn_get_product_name($product.product_id) nofilter}</a>
                                                                <p>
                                                                    <span>{$product.amount}</span><span>&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price span_id="price_`$key`_`$dropdown_id`" class="none"}
                                                                </p>
                                                                </div>
                                                                <div class="ty-cart-items__list-item-tools">
                                                                    {if (!$runtime.checkout || $force_items_deletion) && !$product.extra.exclude_from_calculate}
                                                                        {include file="buttons/button.tpl" but_href="checkout.delete.from_status?cart_id=`$key`&redirect_url=`$r_url`" but_meta="cm-ajax cm-ajax-full-render" but_target_id="cart_content*,cart_icon*" but_role="delete" but_name="delete_cart_item"}
                                                                    {/if}
                                                                </div>
                                                                {/hook}
                                                            </li>
                                                        {/if}
                                                        {/hook}
                                                    {/foreach}
                                                {/hook}
                                            </ul>
                                        {else}
                                            <div class="ty-cart-items__empty ty-center">{__("cart_is_empty")}</div>
                                        {/if}
                                    </div>
    
                                    <div class="cm-cart-buttons ty-cart-content__buttons buttons-container{if $smarty.session.cart.amount} full-cart{else} hidden{/if}">
                                            
                                        {hook name="checkout:cart_subtotal"}
                                        {if $smarty.session.cart.amount > 1 || $product.extra.buy_together}
                                        <div class="ut2-mini-cart__subtotal b-top">{__("total_items")}:&nbsp;<span class="ty-float-right">{$smarty.session.cart.amount}&nbsp;{__("items")} {__("for")}<br><strong>{include file="common/price.tpl" value=$smarty.session.cart.display_subtotal}</strong></span><br>&nbsp;</div>
                                        {/if}
                                        {/hook}

                                        <a href="{"checkout.cart"|fn_url}" rel="nofollow" class="ty-btn ty-btn__secondary">{__("view_cart")}</a>
                                        {if $settings.Checkout.checkout_redirect != "YesNo::YES"|enum}
                                            {include file="buttons/proceed_to_checkout.tpl" but_text=__("checkout")}
                                        {/if}
                                    </div>
                            <!--cart_content_{$dropdown_id}--></div>
                        {/hook}
                    </div>
            <!--cart_status_{$dropdown_id}--></div>
        </div>
        {/if}
    
        {* Wishlist *}
        {if $settings.abt__ut2.general.sticky_panel.wishlist[$settings.abt__device] == "YesNo::YES"|enum}
        {if $addons.wishlist.status == "A" && !$hide_wishlist_button}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.wishlist.position}style="order:{$settings.abt__ut2.general.sticky_panel.wishlist.position}"{/if}>
                {$wishlist_count = fn_abt__ut2_polyfill_fn_wishlist_get_count()}
                <div id="abt__ut2_wishlist_count">
                    <a class="ut2-sticky-panel__link{if $smarty.request.dispatch=="wishlist.view"} active{/if}" href="{"wishlist.view"|fn_url}" rel="nofollow"><i class="ut2-icon-baseline-favorite-border">{if $wishlist_count > 0}<em class="count">{$wishlist_count}</em>{/if}</i><span>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}{__("wishlist")}</span>{/if}</a>
                    <!--abt__ut2_wishlist_count--></div>
            </div>
        {/if}
        {/if}
    
        {* Compare *}
        {if $settings.abt__ut2.general.sticky_panel.comparison[$settings.abt__device] == "YesNo::YES"|enum}
        {if $settings.General.enable_compare_products == "YesNo::YES"|enum && !$hide_compare_list_button || $product.feature_comparison == "YesNo::YES"|enum}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.comparison.position}style="order:{$settings.abt__ut2.general.sticky_panel.comparison.position}"{/if}>
                {assign var="compared_products" value=""|fn_get_comparison_products}
                <div id="abt__ut2_compared_products">
                    <a class="ut2-sticky-panel__link{if $smarty.request.dispatch=="product_features.compare"} active{/if}" href="{"product_features.compare"|fn_url}" rel="nofollow"><i class="ut2-icon-addchart">{if $compared_products}<em class="count">{$compared_products|count}</em>{/if}</i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("compare")}</span>{/if}</a>
                <!--abt__ut2_compared_products--></div>
            </div>
        {/if}
        {/if}
    
        {* Account *}
        {if $settings.abt__ut2.general.sticky_panel.account[$settings.abt__device] == "YesNo::YES"|enum}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.account.position}style="order:{$settings.abt__ut2.general.sticky_panel.account.position}"{/if}>
                <div class="ty-dropdown-box" id="account_info_{$block_snapping_id_replacement}_acc">
                    <div id="sw_dropdown_{$block_snapping_id_replacement}_acc" class="ty-dropdown-box__title cm-combination cm-abt--ut2-toggle-scroll">
                        <a class="ut2-sticky-panel__link" href="{"profiles.update"|fn_url}"><i class="ut2-icon-outline-account-circle"></i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("abt__ut2.settings.general.sticky_panel.account")}</span>{/if}</a>
                    </div>
                    <div id="dropdown_{$block_snapping_id_replacement}_acc" class="ty-dropdown-box__content hidden">
    
                        <a href="javascript:void(0);" rel="nofollow" class="ut2-btn-close cm-combination cm-abt--ut2-toggle-scroll" id="off_dropdown_{$block_snapping_id_replacement}_acc"><i class="ut2-icon-baseline-close"></i></a>
                        <div class="ty-dropdown-box__title">{__("account")}</div>
                        
                        {assign var="return_current_url" value=$config.current_url|escape:url}
                        <ul class="ty-account-info">
                            {hook name="profiles:my_account_menu"}
                            {if $auth.user_id}
                                {if $user_info.firstname || $user_info.lastname}
                                    <li class="ty-account-info__item  ty-account-info__name ty-dropdown-box__item">{$user_info.firstname} {$user_info.lastname}</li>
                                {else}
                                    <li class="ty-account-info__item ty-dropdown-box__item ty-account-info__name">{$user_info.email}</li>
                                {/if}
                                <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"profiles.update"|fn_url}" rel="nofollow" >{__("profile_details")}</a></li>
                                {if $settings.General.enable_edp == "YesNo::YES"|enum}
                                    <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"orders.downloads"|fn_url}" rel="nofollow">{__("downloads")}</a></li>
                                {/if}
                            {elseif $user_data.firstname || $user_data.lastname}
                                <li class="ty-account-info__item  ty-dropdown-box__item ty-account-info__name">{$user_data.firstname} {$user_data.lastname}</li>
                            {elseif $user_data.email}
                                <li class="ty-account-info__item ty-dropdown-box__item ty-account-info__name">{$user_data.email}</li>
                            {/if}
                                <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"orders.search"|fn_url}" rel="nofollow">{__("orders")}</a></li>
                                {if $settings.General.enable_compare_products == 'Y'}
                                    {assign var="compared_products" value=""|fn_get_comparison_products}
                                    <li class="ty-account-info__item ty-dropdown-box__item"><a class="ty-account-info__a underlined" href="{"product_features.compare"|fn_url}" rel="nofollow">{__("view_comparison_list")}{if $compared_products} ({$compared_products|count}){/if}</a></li>
                                {/if}
                            {/hook}
                        </ul>
        
                        {if $settings.Appearance.display_track_orders == 'Y'}
                            <div class="ty-account-info__orders updates-wrapper track-orders" id="track_orders_block_{$block_snapping_id_replacement}">
                                <form action="{""|fn_url}" method="POST" class="cm-ajax cm-post cm-ajax-full-render" name="track_order_quick">
                                    <input type="hidden" name="result_ids" value="track_orders_block_*" />
                                    <input type="hidden" name="return_url" value="{$smarty.request.return_url|default:$config.current_url}" />
        
                                    <div class="ty-account-info__orders-txt">{__("track_my_order")}</div>
        
                                    <div class="ty-account-info__orders-input ty-control-group ty-input-append">
                                        <label for="track_order_item{$block_snapping_id_replacement}" class="cm-required hidden">{__("track_my_order")}</label>
                                        <input type="text" size="20" class="ty-input-text cm-hint" id="track_order_item{$block_snapping_id_replacement}" name="track_data" value="{__("order_id")}{if !$auth.user_id}/{__("email")}{/if}" />
                                        {include file="buttons/go.tpl" but_name="orders.track_request" alt=__("go")}
                                        {include file="common/image_verification.tpl" option="track_orders" align="left" sidebox=true}
                                    </div>
                                </form>
                                <!--track_orders_block_{$block_snapping_id_replacement}--></div>
                        {/if}
        
                        <div class="ty-account-info__buttons buttons-container">
                            {if $auth.user_id}
                                {$is_vendor_with_active_company="MULTIVENDOR"|fn_allowed_for && ($auth.user_type == "V") && ($auth.company_status == "A")}
                                {if $is_vendor_with_active_company}
                                    <a href="{$config.vendor_index|fn_url}" rel="nofollow" class="ty-btn ty-btn__primary" target="_blank">{__("go_to_admin_panel")}</a>
                                {/if}
                                <a href="{"auth.logout?redirect_url=`$return_current_url`"|fn_url}" rel="nofollow" class="ty-btn {if $is_vendor_with_active_company}ty-btn__tertiary{else}ty-btn__primary{/if}">{__("sign_out")}</a>
                            {else}
                                <a href="{if $runtime.controller == "auth" && $runtime.mode == "login_form"}{$config.current_url|fn_url}{else}{"auth.login_form?return_url=`$return_current_url`"|fn_url}{/if}" data-ca-target-id="login_block{$block_snapping_id_replacement}" class="cm-dialog-opener cm-dialog-auto-size ty-btn ty-btn__secondary" rel="nofollow">{__("sign_in")}</a><a href="{"profiles.add"|fn_url}" rel="nofollow" class="ty-btn ty-btn__primary">{__("register")}</a>
                                <div  id="login_block{$block_snapping_id_replacement}" class="hidden" title="{__("sign_in")}">
                                    <div class="ty-login-popup">
                                        {include file="views/auth/login_form.tpl" style="popup" id="popup`$block_snapping_id_replacement`"}
                                    </div>
                                </div>
                            {/if}
                        </div>
                <!--account_info_{$block_snapping_id_replacement}--></div>
                </div>
            </div>
        {/if}
        
        {* Phones *}
        {if $settings.abt__ut2.general.sticky_panel.phones[$settings.abt__device] == "YesNo::YES"|enum}
            <div class="ut2-sticky-panel__item" {if $settings.abt__ut2.general.sticky_panel.phones.position}style="order:{$settings.abt__ut2.general.sticky_panel.phones.position}"{/if}>
                <div class="ty-dropdown-box" id="phones_info_acc">
                    <div id="sw_dropdown_phones_info_acc" class="ty-dropdown-box__title cm-combination cm-abt--ut2-toggle-scroll">
                        <a class="ut2-sticky-panel__link" href="javascript:void(0);" rel="nofollow"><i class="ut2-icon-local_phone"></i>{if $settings.abt__ut2.general.sticky_panel.enable_sticky_panel_labels[$settings.abt__device] == "YesNo::YES"|enum}<span>{__("abt__ut2.settings.general.sticky_panel.phones")}</span>{/if}</a>
                    </div>
                    <div id="dropdown_phones_info_acc" class="ty-dropdown-box__content hidden">
                        <a href="javascript:void(0);" rel="nofollow" class="ut2-btn-close cm-combination cm-abt--ut2-toggle-scroll" id="off_dropdown_phones_info_acc"><i class="ut2-icon-baseline-close"></i></a>
                        <div class="ty-dropdown-box__title">{__("abt__ut2.settings.general.sticky_panel.phones")}</div>
                        <div class="ut2-pn__items">
                        {hook name="abt__ut2_sticky_panel:phones"}
                            <p>
                                {if $settings.Company.company_phone|trim}
                                    <a href="tel:{$settings.Company.company_phone}"><bdi>{$settings.Company.company_phone}</bdi></a>
                                {/if}
                                {if $settings.Company.company_phone_2|trim}
                                    <a href="tel:{$settings.Company.company_phone_2}"><bdi>{$settings.Company.company_phone_2}</bdi></a>
                                {/if}
                                <!-- Edit work time -->
                                <small>{__('call_request.work_time')}</small>
                            </p>
                        {/hook}

                            <hr>
                            {if $settings.Company.company_orders_department|trim}
                                <p>
                                    <small>Email</small>
                                    <a href="mailto:{$settings.Company.company_orders_department|trim}" style="font-weight:normal;font-size: inherit;">{$settings.Company.company_orders_department}</a>
                                </p>
                            {/if}

                            {if $settings.Company.company_country|fn_get_country_name || $settings.Company.company_city || $settings.Company.company_address}
                                <p>
                                    <small>{__("address")}</small>
                                <div>{$settings.Company.company_country|fn_get_country_name}, {$settings.Company.company_city}, {$settings.Company.company_address}</div>
                                </p>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        {/if}
    </div>
    {/hook}
    {/if}
</div>
{/if}

