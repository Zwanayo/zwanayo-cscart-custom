{* Product page component rating *}

{hook name="products:discussion_rating_block"}
    {if $addons.product_reviews.status == "ObjectStatuses::ACTIVE"|enum}
        {if $product.average_rating}
            {include file="addons/product_reviews/views/product_reviews/components/product_rating_overview_short.tpl"
                average_rating=$product.average_rating
                total_product_reviews=$product.product_reviews_count
                button=true
            }
        {else}
            <div class="ty-product-review-product-rating-overview-short">
                <div class="ty-product-review-reviews-stars ty-product-review-reviews-stars--large" data-ca-product-review-reviews-stars-full="0"></div>
            
                {include file="addons/product_reviews/views/product_reviews/components/product_rating_overview_short.tpl"
                    average_rating=$product.average_rating
                    total_product_reviews=$product.product_reviews_count
                    button=true
                }
            </div>
        {/if}
    {else}
        {assign var="rating" value="rating_`$obj_id`"}
        {if $product.discussion_type && $product.discussion_type != 'D' && $product.discussion.posts && $product.discussion.search.total_items > 0}
            <div class="ut2-pb__rating">
                <div class="ty-discussion__rating-wrapper" id="average_rating_product">
                    {$_tabs=fn_array_value_to_key($tabs, 'html_id')}
                    {$add_scroll = !$_tabs.discussion || $_tabs.discussion.show_in_popup != 'Y'}
                    {$smarty.capture.$rating|trim nofilter}<a class="ty-discussion__review-a cm-external-click"{if $add_scroll} data-ca-scroll="discussion"{/if} data-ca-external-click-id="discussion">{$product.discussion.search.total_items} {__("reviews", [$product.discussion.search.total_items])}</a>{if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum && !$discussion.disable_adding}{include file="addons/discussion/views/discussion/components/new_post_button.tpl" name=__("write_review") obj_id=$obj_id obj_prefix="main_info_title_" style="text" object_type="Addons\\Discussion\\DiscussionObjectTypes::PRODUCT"|enum locate_to_review_tab=true}{/if}
                </div>
            </div>
        {elseif $product.discussion_type && $product.discussion_type != 'D'}
            <div class="ut2-pb__rating">
                <div class="ty-discussion__rating-wrapper">
                    <span class="ty-nowrap no-rating"><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i><i class="ty-icon-star-empty"></i></span>
                    {if $discussion.type !== "Addons\\Discussion\\DiscussionTypes::TYPE_DISABLED"|enum && !$discussion.disable_adding}{include file="addons/discussion/views/discussion/components/new_post_button.tpl" name=__("write_review") obj_id=$obj_id obj_prefix="main_info_title_" style="text" object_type="Addons\\Discussion\\DiscussionObjectTypes::PRODUCT"|enum locate_to_review_tab=true}{/if}
                </div>
            </div>
        {/if}
    {/if}
{/hook}