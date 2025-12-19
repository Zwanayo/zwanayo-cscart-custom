{*
    Import
    ---
    $bundles

    Local
    ---
    $bundle
*}

{if $bundles}
    {script src="js/addons/product_bundles/frontend/func.js"}

    <div class="ty-product-bundles-promotion-list">
        <div class="ty-mainbox-title">{__("product_bundles.active_bundles")}</div>
        <div class="ab__product_bundles clearfix">
            {foreach $bundles as $bundle}
                {include file="addons/product_bundles/components/pages/bundles_promotion.tpl"
                    bundle=$bundle
                }
            {/foreach}
        </div>
    </div>
{/if}