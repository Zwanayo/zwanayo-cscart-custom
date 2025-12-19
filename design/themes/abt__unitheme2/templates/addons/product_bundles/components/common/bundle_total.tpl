{*
    Import
    ---
    $bundle
    $show_add_all_to_cart
*}

{$show_add_all_to_cart = $show_add_all_to_cart|default:true}

{if $bundle.total_price}

    <div class="ty-product-bundles-bundle-form__total">
        
        <span class="ty-product-bundle__plus chain-equally"><svg width="24" height="24" fill="none" xmlns="http://www.w3.org/2000/svg" class="b5d8"><path fill-rule="evenodd" clip-rule="evenodd" d="M21 8a1 1 0 00-1-1H4a1 1 0 000 2h16a1 1 0 001-1zm0 8a1 1 0 00-1-1H4a1 1 0 100 2h16a1 1 0 001-1z" fill="currentColor"></path></svg></span>
        
        <div class="ty-product-bundles-bundle-form__total-inner">
            {* Total title *}
            <strong class="ty-product-bundles-bundle-form__total-title">
                {__("product_bundles.price_for_all")}
            </strong>

            {* If auth user or show price for anonymous shopping *}
            {if $auth.user_id || $settings.Checkout.allow_anonymous_shopping !== "hide_price_and_add_to_cart"}

                {* Prices *}
                <div class="ty-product-bundles-bundle-form__price"
                    id="product_bundles_bundle_total_price_{$bundle.bundle_id}">
                    
                    <div class="ty-product-bundles-bundle-form__price-discount">
                        <span class="ty-product-bundles-bundle-form__price-discount-title">
                            {__("product_bundles.order_discount")}:
                        </span>
                        <span class="ty-product-bundles-bundle-form__price-discount-price">
                            {include file="common/price.tpl"
                                value=($bundle.total_price - $bundle.discounted_price)
                            }
                        </span>
                    </div>
                    <span class="ty-product-bundles-bundle-form__price-old ty-strike">
                        {include file="common/price.tpl"
                            value=$bundle.total_price
                        }
                    </span>
                    <span class="ty-product-bundles-bundle-form__price-new">
                        {include file="common/price.tpl"
                            value=$bundle.discounted_price
                        }
                    </span>
                    {if $settings.Appearance.show_prices_taxed_clean === "YesNo::YES"|enum && $auth.tax_exempt !== "YesNo::YES"|enum && $bundle.is_tax_exists}
                        {if $bundle.discounted_price != $bundle.taxed_price && $bundle.taxed_price}
                            <span class="ty-list-price ty-nowrap" id="line_product_price_{$obj_prefix}{$obj_id}">({include file="common/price.tpl" value=$bundle.taxed_price span_id="product_price_`$obj_prefix``$obj_id`" class="ty-list-price ty-nowrap"} {__("inc_tax")})</span>
                        {else}
                            <span class="ty-list-price ty-nowrap ty-tax-include">({__("including_tax")})</span>
                        {/if}
                    {/if}
                <!--product_bundles_bundle_total_price_{$bundle.bundle_id}--></div>

                {* Add all to cart button *}
                {if $show_add_all_to_cart && ($auth.user_id || $settings.Checkout.allow_anonymous_shopping !== "hide_add_to_cart_button")}
                    <div class="ty-product-bundles-bundle-form__submit" id="wrap_chain_button_{$bundle.bundle_id}">
                        {include file="buttons/button.tpl"
                            but_text=__("product_bundles.add_all_to_cart")
                            but_id="bundle_button_`$bundle.bundle_id`"
                            but_meta="ty-btn__secondary cm-dialog-closer"
                            but_name="dispatch[checkout.add]"
                            but_role="action"
                        }
                    </div>
                {/if}
            {else}
                {* Sign in to view price button *}
                <p>{__("product_bundles.sign_in_to_view_price")}</p>
            {/if}
        </div>
    </div>
{/if}
