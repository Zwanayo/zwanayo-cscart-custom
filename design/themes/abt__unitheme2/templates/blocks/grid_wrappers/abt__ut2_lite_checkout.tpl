{script src="js/tygh/checkout.js"} {* legacy checkout functionality *}
{script src="js/tygh/checkout/lite_checkout.js"} {* lite checkout functionality *}
{script src="js/tygh/checkout/pickup_selector.js"}
{script src="js/tygh/checkout/pickup_search.js"}
{script src="js/tygh/search_pickup_points.js"}

{* login popup *}
{if !$auth.user_id}
    <div id="litecheckout_login_block" class="hidden" title="{__("sign_in")}">
        <div class="ty-login-popup">
            {include file="views/auth/login_form.tpl"
                style="popup"
                id="litecheckout_login_block_inner"
            }
        </div>
    </div>
{/if}

<div class="litecheckout litecheckout__form" id="litecheckout_form">
    <h1 class="litecheckout__page-title">{__("checkout")}</h1>
    <div data-ca-lite-checkout-element="form">
        <form name="litecheckout_payments_form"
            id="litecheckout_payments_form"
            action="{"checkout.place_order"|fn_url}"
            method="post"
            data-ca-lite-checkout-element="checkout-form"
            data-ca-lite-checkout-ready-for-checkout="false"
            class="litecheckout__payment-methods"
        >
            <input
                type="hidden"
                value="1"
                name="ship_to_another"
                data-ca-lite-checkout-field="ship_to_another"
                data-ca-lite-checkout-auto-save-on-change="true"
            >
            <div
                class="litecheckout__group
                {if $runtime.customization_mode.block_manager && $location_data.is_frontend_editing_allowed}
                    bm-block-manager__blocks-place
                {/if}"
                {if $runtime.customization_mode.block_manager && $location_data.is_frontend_editing_allowed}
                    data-ca-block-manager-blocks-place="true"
                {/if}
            >{strip}
                {$content nofilter}
            {/strip}</div>
        <!--litecheckout_payments_form--></form>
    </div>
<!--litecheckout_form--></div>
