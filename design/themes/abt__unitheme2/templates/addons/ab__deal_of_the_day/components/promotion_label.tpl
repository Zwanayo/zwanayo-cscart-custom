{if $product.promotions && fn_ab__dotd_filter_applied_promotions(array_keys($product.promotions), ['show_label_in_products_lists' => true, 'exclude_hidden' => true])}
    <span class="ab_dotd_product_label ut2-icon-local_activity cm-tooltip" title="{__('ab__dotd_product_label')}"></span>
{/if}