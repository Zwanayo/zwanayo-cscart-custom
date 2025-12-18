{** block-description:block_abt__ut2_lite_checkout_place_order_button **}

{capture name="image_verification"}{include file="common/image_verification.tpl" option="checkout"}{/capture}

{if $smarty.capture.image_verification}
    <div class="litecheckout__group">
        {$smarty.capture.image_verification nofilter}
    </div>
{/if}

<div class="litecheckout__group litecheckout__submit-order" id="litecheckout_final_section">
    {include file="views/checkout/components/final_section.tpl"
    is_payment_step=true
    suffix=$payment.payment_id
    }
<!--litecheckout_final_section--></div>