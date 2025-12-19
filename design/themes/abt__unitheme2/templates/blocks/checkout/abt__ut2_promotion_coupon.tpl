{** block-description:tmpl_abt__ut2_blocks_promotion_coupon **}

{if $cart|fn_display_promotion_input_field}
<div>
    <form class="cm-ajax cm-ajax-force cm-ajax-full-render" name="coupon_code_form{$position}" action="{""|fn_url}" method="post" id="coupon_code_form{$position}">
        <input type="hidden" name="result_ids" value="checkout*,cart_status*,cart_items,payment-methods,litecheckout_form" />
        <input type="hidden" name="redirect_url" value="{$config.current_url}" />

        {hook name="checkout:discount_coupons"}
            <div class="ty-discount-coupon__control-group ty-input-append">
                <label for="coupon_field{$position}" class="hidden cm-required">{__("promo_code")}</label>
                <input type="text" class="ty-input-text cm-hint" id="coupon_field{$position}" name="coupon_code" size="40" value="{__("promo_code")}" />
                {include file="buttons/go.tpl" but_name="checkout.apply_coupon" alt=__("apply") but_text=__("apply")}
            </div>
        {/hook}
    </form>
</div>
{/if}