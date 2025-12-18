{if $_product.any_variation && ($_product.parent_variation_product || ($_product.product_data.variation_features_variants && $bundle.parent_bundle_id))}
    {script src="js/addons/product_bundles/func.js"}

    <div class="ty-product-bundle__product-features">
        {include file="common/popupbox.tpl" 
            id="product_bundle_features_`$bundle.bundle_id`_`$_product.product_id`_`$id_postfix`"
            href="product_bundles.get_feature_variants?product_id={$product.product_id}&key={$_id}&bundle_id={$bundle.bundle_id}&id_postfix={$id_postfix}"
            link_meta="ty-btn ty-btn__tertiary" 
            text=__("product_bundles.specify_features") 
            content=""
            link_text=__("product_bundles.specify_features") 
        }
    </div>
{elseif $_product.product_data.variation_features}
    {include file="addons/product_variations/components/variation_features.tpl"
        variation_features=$product.variation_features
        features_secondary=true
    }
{/if}