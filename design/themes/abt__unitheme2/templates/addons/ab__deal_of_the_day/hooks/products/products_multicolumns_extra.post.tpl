{if $promotion && $category_group}

{*Remove empty cells*}
{capture name="iteration"}{$iteration + 1}{/capture}

<div class="ty-column{$columns} ab-dotd-more-products">
    <div class="ut2-gl__item" style="aspect-ratio: var(--gl-item-width) / var(--gl-item-height)">
        <div style="height: 100%">
            <div class="ut2-gl__body">
                <div class="ut2-gl__image {if !$product.image_pairs}ut2-gl__no-image{/if}" style="max-height:{$tbh}px;aspect-ratio: {$tbw} / {$tbh};">
                    <a href="{"promotions.view?promotion_id=`$promotion.promotion_id`&cid=`$category_group.category_id`"|fn_url}">
                        <span class="ty-icon ty-icon-arrow-up-right ab-dotd-more-icon"></span>
                        {__('ab__dotd.more_products_from_category', ["[category]" => $category_group.category])}
                    </a>
                </div>
                <div class="ut2-gl__content{if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::YES"|enum} content-on-hover{/if}" style="min-height:{$smarty.capture.abt__ut2_gl_content_height nofilter}px;"></div>
            </div>
        </div>
    </div>
</div>
{/if}