{if $product}
    {$suffix="product_{$product.product_id}" scope="parent"}
{else}
    {$suffix="n{$block.block_id}" scope="parent"}
{/if}

