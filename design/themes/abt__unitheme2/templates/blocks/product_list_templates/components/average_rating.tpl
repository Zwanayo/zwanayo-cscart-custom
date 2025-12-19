{hook name="products:product_rating"}
{strip}
    <div class="ut2-gl__rating ut2-rating-stars {if $addons.product_reviews.status == "ObjectStatuses::ACTIVE"|enum}r-block{/if}">
        {if $show_labels_in_title == false}
            {hook name="products:video_gallery"}{/hook}
            {hook name="products:dotd_product_label"}{/hook}
        {/if}
        {if $addons.product_reviews.status == "ObjectStatuses::ACTIVE"|enum}
            {if $product.average_rating}
                {include file="addons/product_reviews/views/product_reviews/components/product_reviews_stars.tpl"
                rating=$product.average_rating
                link=true
                product=$product
                }
            {elseif $settings.abt__ut2.product_list.show_rating == "YesNo::YES"|enum}
                {if $settings.abt__ut2.product_list.show_rating_num == "YesNo::YES"|enum}<div class="ut2-rating-stars-empty">{/if}
                <div class="ty-product-review-reviews-stars {if $settings.abt__ut2.product_list.show_rating_num == "YesNo::YES"|enum}ty-product-review-reviews-stars-one{/if}"
                     data-ca-product-review-reviews-stars-full="0"></div>
                {if $settings.abt__ut2.product_list.show_rating_num == "YesNo::YES"|enum}
                    <span class="ut2-rating-stars-num">0.0</span>
                    </div>{/if}
            {/if}
        {elseif $settings.abt__ut2.product_list.show_rating == "YesNo::YES"|enum}
            {assign var="rating" value="rating_$obj_id"}
            {if $smarty.capture.$rating|strlen > 40 && $product.discussion_type && $product.discussion_type != "D"}
                {$smarty.capture.$rating|trim nofilter}
            {elseif $addons.discussion.status == "ObjectStatuses::ACTIVE"|enum}
                <span class="ty-nowrap ty-stars"><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i></span>
            {/if}
        {/if}
    </div>
{/strip}
{/hook}