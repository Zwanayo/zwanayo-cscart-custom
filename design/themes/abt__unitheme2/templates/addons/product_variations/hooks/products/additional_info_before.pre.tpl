{$limit = $settings.abt__ut2.product_list.product_variations.limit}

{if $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] != 'variations' && $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] != 'features_and_variations'}
	{$limit = 0}
{/if}

{if $show_features && $product.variation_features_variants}
    {capture name="variation_features_variants"}
        {$product.variation_features_variants=fn_abt__ut2_prepare_variation_features_variants($product.variation_features_variants, $product.abt__ut2_features)}

        {foreach $product.variation_features_variants as $variation_feature}
            {if $variation_feature.display_on_catalog === "YesNo::YES"|enum}

                {if $limit > 0}
                
                {if $smarty.capture.variants_count < $variation_feature@index}
                {capture name="variants_count"}{$variation_feature@index + 1}{/capture}
                {/if}

                <div class="ut2-lv__features-item">
                    <p class="ut2-lv__features-description">
                        {$variation_feature.description}:
                    </p>
                    {$printed_variations = 0}
                    {foreach $variation_feature.variants as $variant}
						{if $printed_variations < $limit && ($variant.product_id || $addons.product_variations.variations_show_all_possible_feature_variants === "YesNo::YES"|enum)}


                                {* Color varian not work *}
                                {if $variation_feature.filter_style == 'color'}
                                    {if $settings.abt__ut2.product_list.product_variations.display_as_links === "YesNo::YES"|enum && $variant.product_id}
                                        <a href="{fn_url("products.view?product_id=`$variant.product_id`")}" class="ut2-lv__color-variant{if $variant.active} active{/if}" style="background-color: {$variant.color}">&nbsp;</a>
                                    {else}
                                        <span class="ut2-lv__color-variant{if $variant.active} active{/if}" style="background-color: {$variant.color}">&nbsp;</span>
                                    {/if}
                                {else}
                                    {if $settings.abt__ut2.product_list.product_variations.display_as_links === "YesNo::YES"|enum && $variant.product_id}
                                        <a href="{fn_url("products.view?product_id=`$variant.product_id`")}" class="ut2-lv__features-variant{if $variant.active} active{/if}">{$variant.variant}</a>   
                                    {else}
                                        <span class="ut2-lv__features-variant{if $variant.active} active{/if}">{$variant.variant}</span>
                                    {/if}
                                {/if}

                            {if $settings.abt__ut2.product_list.product_variations.display_as_links === "YesNo::YES"|enum && $variant.product_id}
                                </a>
                            {/if}
						{/if}
                        {$printed_variations = $printed_variations +1}
                    {/foreach}
                    {if $variation_feature.variants|count > $limit}<span class="ut2-lv__more">({__("more")} +{$variation_feature.variants|count - $limit})</span>{/if}
                </div>
                {/if}

            {/if}
        {/foreach}

    {/capture}
    {if $smarty.capture.variation_features_variants|trim}
        <div class="ut2-lv__item-features">
            {ab__hide_content bot_type="ALL"}
                {$smarty.capture.variation_features_variants nofilter}
            {/ab__hide_content}
        </div>
    {/if}
{/if}
{if $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] === 'variations'}
    {$hide_features = true scope=parent}
{/if}