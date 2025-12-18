{$ab__vg_videos = $product.product_id|fn_ab__vg_get_videos}

{if $ab__vg_videos}
    {$product_images_count = $product_images_count + $ab__vg_videos|@count scope="global"}
{/if}

