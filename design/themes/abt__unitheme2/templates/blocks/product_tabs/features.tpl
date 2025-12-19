{** block-description:features **}
{if $product.product_features}
{$ab__search_similar_in_category = $settings.abt__ut2.products.search_similar_in_category.{$settings.abt__device} == "YesNo::YES"|enum}
    {if $ab__search_similar_in_category}
        <div class="cm-ab-similar-filter-container {if $settings.abt__ut2.products.view.show_features_in_two_col[$settings.abt__device] == "YesNo::YES"|enum}fg-two-col{/if}" data-ca-base-url="{"categories.view?category_id=`$product.main_category`"|fn_url}">
        {script src="js/addons/abt__unitheme2/abt__ut2_search_similar.js"}
    {elseif $settings.abt__ut2.products.view.show_features_in_two_col[$settings.abt__device] == "YesNo::YES"|enum}
        <div class="fg-two-col">
    {/if}

    {include file="views/products/components/product_features.tpl" product_features=$product.product_features details_page=true ab__search_similar_in_category=$ab__search_similar_in_category ab__features_count=$product.product_features|count}

    {if $ab__search_similar_in_category}
        {if $ab__enable_similar_filter}
            {include file="buttons/button.tpl" but_text=__("ab__ut2.search_similar") but_meta="abt__ut2_search_similar_in_category_btn" but_icon="ut2-icon-filter-empty"}
        {/if}
        </div>
    {elseif $settings.abt__ut2.products.view.show_features_in_two_col[$settings.abt__device] == "YesNo::YES"|enum}
        </div>
    {/if}
    {if $ab__search_similar_in_category && !$ab__enable_similar_filter}
        <div class="outside-margin"></div>
    {/if}
{/if}