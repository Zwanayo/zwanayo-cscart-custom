<div id="checkout_info_products_{$block.snapping_id}">
    {if $runtime.controller == "checkout"}
        <div class="ab-checkout-header-title">
            {include file="blocks/static_templates/abt__ut2__title_block.tpl" }
            <div class="ab-checkout-edit">
                <a href="{"checkout.cart"|fn_url}" rel="nofollow"><i class="ty-icon-edit"></i>&nbsp;{__('edit')}</a>
            </div>
        </div>
    {/if}
    <ul class="ty-order-products__list order-product-list">
        {hook name="block_checkout:cart_items"}
        {foreach from=$cart_products key="key" item="product" name="cart_products"}
            {hook name="block_checkout:cart_products"}
            {if !$cart.products.$key.extra.parent}
                <li class="ty-order-products__item">

                    {if $runtime.controller == "checkout"}
                        <div class="ab-checkout-product-base">
                            <div class="ab-checkout-product-icon">
                                {include file="common/image.tpl" image_width=80 image_height=80 images=$product.main_pair obj_id=$product.product_id}
                            </div>
                            <div class="ab-checkout-product-title">
                                {hook name="block_checkout:ab__cart_product"}
                                <div>
                                    <bdi><a class="litecheckout__order-products-p"
                                            href="{"products.view?product_id=`$product.product_id`"|fn_url}">{$product.product nofilter}</a>
                                    </bdi>
                                </div>

                                {if $product.product_code}
                                    <p class="ab-checkout-product-code">{__('code')}:&nbsp;{$product.product_code}</p>
                                {/if}

                                <!--VARIATIONS-->
                                {if $product.variation_features}
                                    <div class="ab-checkout-product-variations">
                                        {foreach $product.variation_features as $v_feature}
                                            <p>{$v_feature.description}: <b>{$v_feature.variant}</b></p>
                                        {/foreach}
                                    </div>
                                {/if}

                                {if $product.product_options}
                                    <p class="ab-checkout-product-options">
                                        {include file="common/options_info.tpl" product_options=$product.product_options no_block=true}
                                    </p>
                                {/if}
                                {/hook}
                            </div>
                        </div>

                        <div class="ab-checkout-product-exinfo">
                            <div class="ab-checkout-product-exinfo-col ab-checkout-product-exinfo-price">
                                <div class="ab-checkout-product-exinfo-header">{__('price')}</div>
                                <div>{include file="common/price.tpl" value=$product.display_price}</div>
                                <div class="ty-strike">
                                    {$full_price = 0}

                                    {if $product.promotions}
                                        {$full_price=$product.base_price}
                                    {else}
                                        {$pd = fn_get_product_data($product.product_id, $auth)}
                                        {$full_price = $pd.price}
                                        {if $pd.list_price > 0}
                                            {$full_price = $pd.list_price}
                                        {/if}
                                    {/if}

                                    {foreach $product.product_options as $lp_product_option}
                                        {if empty($lp_product_option.variants)}{continue}{/if}
                                        {$lp_option = $lp_product_option.variants[$lp_product_option.value]}

                                        {if $lp_option.modifier_type == 'A'}
                                            {$full_price = $full_price + $lp_option.modifier}
                                        {elseif $lp_option.modifier_type == 'P'}
                                            {$full_price = $full_price + $full_price*$lp_option.modifier/100}
                                        {/if}
                                    {/foreach}

                                    {if $full_price > 0 && $full_price > $product.display_price}
                                        {include file="common/price.tpl" value=$full_price}
                                    {/if}
                                </div>
                            </div>
                            <div class="ab-checkout-product-exinfo-col">
                                <div class="ab-checkout-product-exinfo-header">{__('qty')}</div>
                                <div>{$product.amount}</div>
                            </div>
                            <div class="ab-checkout-product-exinfo-col ab-checkout-product-exinfo-amount">
                                <div class="ab-checkout-product-exinfo-header">{__('amount')}</div>
                                <div>{include file="common/price.tpl" value=$product.display_subtotal}</div>
                            </div>
                        </div>
                    {else}
                        <div class="ab-checkout-product-info">
                            <bdi><a class="litecheckout__order-products-p"
                                    href="{"products.view?product_id=`$product.product_id`"|fn_url}">{$product.product nofilter}</a>
                            </bdi>

                            {if !$product.exclude_from_calculate}
                                {include file="buttons/button.tpl" but_href="checkout.delete?cart_id=`$key`&redirect_mode=`$runtime.mode`" but_meta="ty-order-products__item-delete delete" but_target_id="cart_status*" but_role="delete" but_name="delete_cart_item"}
                            {/if}
                            {hook name="products:product_additional_info"}
                            {/hook}
                            <div class="ty-order-products__price">
                                <span>{$product.amount}</span><span
                                        dir="{$language_direction}">&nbsp;x&nbsp;</span>{include file="common/price.tpl" value=$product.display_price}
                            </div>

                            {include file="common/options_info.tpl" product_options=$product.product_options no_block=true}
                        </div>
                    {/if}
                    {if $runtime.controller == "checkout"}
                        {if !$product.exclude_from_calculate}
                            <div class="ab-checkout-product-exinfo-remove">
                                {include file="buttons/button.tpl" but_href="checkout.delete?cart_id=`$key`&redirect_mode=`$runtime.mode`" but_meta="ty-order-products__item-delete delete" but_target_id="cart_status*" but_role="delete" but_name="delete_cart_item"}
                            </div>
                        {/if}
                    {/if}
                    {hook name="block_checkout:product_extra"}{/hook}
                </li>
            {/if}
            {/hook}
        {/foreach}
        {/hook}
    </ul>
    <!--checkout_info_products_{$block.snapping_id}--></div>
