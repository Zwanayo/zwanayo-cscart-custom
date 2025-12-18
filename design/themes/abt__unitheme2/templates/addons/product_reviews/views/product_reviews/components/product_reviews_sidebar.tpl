{*
    $product
    $product_id
    $locate_to_product_review_tab
    $product_reviews
*}

<aside class="ty-product-review-reviews-sidebar
    {if $product_reviews}
        ty-product-review-reviews-sidebar--with-reviews    
    {/if}
    ">

    {include file="addons/product_reviews/views/product_reviews/components/write_product_review.tpl"
        name=__("product_reviews.write_review")
        product_id=$product_id
        locate_to_product_review_tab=$locate_to_product_review_tab
    }

</aside>