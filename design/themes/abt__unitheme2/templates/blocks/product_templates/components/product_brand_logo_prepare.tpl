{assign var="brand_feature" value=$product.header_features[$settings.abt__ut2.general.brand_feature_id] scope=parent}
{if empty($brand_feature)}
    {$brand_feature = fn_array_value_to_key($product.header_features, 'feature_id')}
    {assign var="brand_feature" value=$brand_feature[$settings.abt__ut2.general.brand_feature_id] scope=parent}
{/if}

{if empty($brand_feature)}
    {assign var="brand_feature" value=$product.product_features[$settings.abt__ut2.general.brand_feature_id] scope=parent}
{/if}

{if empty($brand_feature)}
    {$brand_feature = fn_array_value_to_key($product.product_features, 'feature_id')}
    {assign var="brand_feature" value=$brand_feature[$settings.abt__ut2.general.brand_feature_id] scope=parent}
{/if}

{if empty($brand_feature)}
    {$brand_feature = ['product_id' => $product.product_id, 'variants_selected_only' => true, 'feature_id' => $settings.abt__ut2.general.brand_feature_id, 'variants' => true, 'existent_only' => true]|fn_get_product_features}
    {if $brand_feature[0][$settings.abt__ut2.general.brand_feature_id]}
        {$brand_feature=$brand_feature[0][$settings.abt__ut2.general.brand_feature_id]}
        {$brand_feature_variant = reset($brand_feature.variants)}
        {$brand_feature.variant=$brand_feature_variant.variant scope=parent}
    {/if}
{/if}