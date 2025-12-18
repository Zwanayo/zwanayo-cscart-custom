<div class="ty-gift-certificate-coupon ty-discount-coupon__control-group ty-input-append">
    <label for="coupon_field{$position}" class="cm-hint">{__("promo_code_or_certificate")}</label>
    <input type="text" class="ty-input-text cm-hint" id="coupon_field{$position}" name="coupon_code" size="25" value="" />
    {include file="buttons/go.tpl" but_name="checkout.apply_coupon" alt=__("apply") but_text=__("apply")}
</div>