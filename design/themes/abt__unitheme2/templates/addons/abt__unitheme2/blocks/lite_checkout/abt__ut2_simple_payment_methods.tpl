<div class="litecheckout__group b--pay-way
    {if $block.properties.abt__ut2_as_select == "YesNo::YES"|enum}
        b--pay-way_mode_select
    {else}
        b--pay-way_mode_radio-list
    {/if}" id="litecheckout_step_payment">

    <div class="b--pay-way__in">

        {hook name="checkout:payments"}

            {if $cart.payment_id}
                {include file="addons/abt__unitheme2/blocks/components/abt__ut2_checkout_payments.tpl"}
            {else}
                <div class="litecheckout__item">
                    <p>
                        {__("text_no_payments_required")}
                    </p>
                </div>
            {/if}

        {/hook}

    </div>{* /.b--pay-way__in *}
<!--litecheckout_step_payment--></div>

{if "DEVELOPMENT"|defined && $smarty.const.DEVELOPMENT && $auth.act_as_user}
    <div class="litecheckout__group">
        <div class="litecheckout__item">
            <label>
                <input type="checkbox" id="skip_payment" name="skip_payment" value="{"YesNo::YES"|enum}" class="checkbox" />
                {__("skip_payment")}
            </label>
        </div>
    </div>
{/if}