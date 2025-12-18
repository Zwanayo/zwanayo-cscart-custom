{** block-description:tmpl_abt__ut2_blocks_checkout_summary **}

<div class="ty-checkout-summary" id="checkout_info_summary_{$block.snapping_id}">

    <table class="ty-checkout-summary__block">
        <tbody>
            <tr>
                <td class="ty-checkout-summary__item">{__("products_amount")}:</td>
                <td class="ty-checkout-summary__item ty-right" data-ct-checkout-summary="items">
                    <span>{$cart.amount} {__("items")}</span>
                </td>
            </tr>
            <tr>
                <td class="ty-checkout-summary__item">{__("amount")}:</td>
                <td class="ty-checkout-summary__item ty-right" data-ct-checkout-summary="items">
                    <span>{include file="common/price.tpl" value=$cart.display_subtotal}</span>
                </td>
            </tr>

            {if !$cart.shipping_failed
                && $cart.chosen_shipping
                && $cart.shipping_required
                && $cart.display_shipping_cost
            }
            <tr>
                <td class="ty-checkout-summary__item">{__("shipping")}:</td>
                <td class="ty-checkout-summary__item ty-right" data-ct-checkout-summary="shipping">
                    <span>{include file="common/price.tpl" value=$cart.display_shipping_cost}</span>
                </td>
            </tr>
            {/if}

            {if ($cart.discount|floatval)}
                <tr class="ty-checkout-summary__order_discount">
                    <td class="ty-checkout-summary__item">{__("including_discount")}</td>
                    <td class="ty-checkout-summary__item ty-right discount-price">
                        <span>{include file="common/price.tpl" value="-`$cart.discount`"}</span>
                    </td>
                </tr>
            {/if}

            {if ($cart.subtotal_discount|floatval)}
                <tr class="ty-checkout-summary__order_discount">
                    <td class="ty-checkout-summary__item">{__("order_discount")}:</td>
                    <td class="ty-checkout-summary__item ty-right discount-price" data-ct-checkout-summary="order-discount">
                        <span>{include file="common/price.tpl" value="-`$cart.subtotal_discount`"}</span>
                    </td>
                </tr>
                {hook name="checkout:discount_summary"}
                {/hook}
            {/if}

            {if $cart.payment_surcharge && !$take_surcharge_from_vendor}
                <tr>
                    <td class="ty-checkout-summary__item">{$cart.payment_surcharge_title|default:__("payment_surcharge")}</td>
                    <td class="ty-checkout-summary__item ty-right" data-ct-checkout-summary="payment-surcharge">
                        <span>{include file="common/price.tpl" value=$cart.payment_surcharge}</span>
                    </td>
                </tr>
                {math equation="x+y" x=$cart.total y=$cart.payment_surcharge assign="_total"}
            {/if}

            {if $cart.taxes}

                {foreach from=$cart.taxes item="tax"}
                    <tr>
                        <td class="ty-checkout-summary__item" data-ct-checkout-summary="tax-name {$tax.description}">
                            {__("taxes")}: <span class="ty-checkout-summary__taxes-name">{$tax.description} <bdi>({include file="common/modifier.tpl" mod_value=$tax.rate_value mod_type=$tax.rate_type}{if $tax.price_includes_tax == "Y" && ($settings.Appearance.cart_prices_w_taxes != "Y" || $settings.Checkout.tax_calculation == "subtotal")} {__("included")}</bdi>{/if})</span>
                        </td>
                        <td class="ty-checkout-summary__item ty-right" data-ct-checkout-summary="taxes">
                            <span class="ty-checkout-summary__taxes-amount">{include file="common/price.tpl" value=$tax.tax_subtotal}</span>
                        </td>
                    </tr>
                {/foreach}
            {/if}

            {hook name="checkout:summary"}
            {/hook}
        </tbody>
        <tbody>
            <tr>
                <th class="ty-checkout-summary__total" colspan="2" data-ct-checkout-summary="order-total">
                    <div>
                        {__("order_total")}
                        <span class="ty-checkout-summary__total-sum">{include file="common/price.tpl" value=$_total|default:$cart.total}</span>
                    </div>
                </th>
            </tr>
        </tbody>
    </table>
<!--checkout_info_summary_{$block.snapping_id}--></div>

{if $cart.points_info.reward}
    <div class="ty-reward-points__info clearfix">
        <span class="ty-float-right">+{__("points_lowercase", [$cart.points_info.reward])}</span>
    </div>
{/if}

{hook name="checkout:applied_discount_coupons"}
    {capture name="promotion_info"}
        {hook name="checkout:applied_coupons_items"}
            {foreach from=$cart.coupons item="coupon" key="coupon_code"}
            <li class="ty-coupons__item">
                {__("coupon")} "{$coupon_code}"
                {assign var="_redirect_url" value=$config.current_url|escape:url}
                {assign var="coupon_code" value=$coupon_code|escape:url}
                {include file="buttons/button.tpl" but_href="checkout.delete_coupon?coupon_code=`$coupon_code`&redirect_url=`$_redirect_url`" but_role="delete" but_meta="ty-coupons__item-delete cm-ajax cm-ajax-full-render" but_target_id="checkout*,cart_status*,cart_items,litecheckout_form"}
            </li>
            {/foreach}
            {if $cart.applied_promotions}
                <li class="ty-coupons__item">
                    {include file="views/checkout/components/applied_promotions.tpl"}
                </li>
            {/if}
        {/hook}
    {/capture}
    <div id="checkout_promotions_info_{$block.snapping_id}">
        {if $smarty.capture.promotion_info|trim}
            <ul class="ty-coupons__list ty-discount-info">
                {if $cart.has_coupons}
                    <li class="ty-caret-info"><span class="ty-caret-outer"></span><span class="ty-caret-inner"></span></li>
                {/if}
                {$smarty.capture.promotion_info nofilter}
            </ul>
        {/if}
    <!--checkout_promotions_info_{$block.snapping_id}--></div>
{/hook}
