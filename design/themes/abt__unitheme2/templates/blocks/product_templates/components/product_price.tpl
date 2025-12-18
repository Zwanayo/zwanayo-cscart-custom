{* Product page component price *}

<div class="pr-{$settings.abt__ut2.product_list.price_display_format} ut2-pb__price-wrap{if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim} prices-container{/if}">

    <div class="ty-product-prices">
        {if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}
            {hook name="products:main_price"}
                {if $smarty.capture.$price|trim}
                    <div class="ut2-pb__price-actual">
                        {$smarty.capture.$price nofilter}
                    </div>
                {/if}
                {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}
            {/hook}
            {/if}

            {if $smarty.capture.$old_price|trim || $smarty.capture.$clean_price|trim || $smarty.capture.$list_discount|trim}
            <div class="ut2-pb__price-old">
                {$smarty.capture.$clean_price nofilter}
                {$smarty.capture.$list_discount nofilter}
            </div>

            {if $product.prices}
                <div class="ut2__qty-discounts">{include file="views/products/components/products_qty_discounts.tpl"}</div>
            {/if}
        {/if}

        {assign var="product_amount" value="product_amount_`$obj_id`"}
        {$smarty.capture.$product_amount nofilter}
    </div>

    {if $settings.abt__ut2.general.brand_feature_id}
        {include file="blocks/product_templates/components/product_brand_logo_prepare.tpl"}
        {if $brand_feature}
            {hook name="products:brand"}
            {if $settings.abt__ut2.products.view.show_brand_format[$settings.abt__device] == "logo"}
                <div class="ut2-pb__product-brand">
                    {include file="views/products/components/product_features_short_list.tpl" features=array($brand_feature) feature_image=true hide_name=true feature_link=true}
                </div>
            {/if}
            {/hook}
        {/if}
    {/if}
</div>
