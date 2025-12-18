{if $show_add_to_wishlist}
    {include file="buttons/button.tpl" 
            but_id="button_wishlist_`$obj_prefix``$product.product_id`" 
            but_meta="ut2-add-to-wish cm-tooltip" 
            but_name="dispatch[wishlist.add..`$product.product_id`]" 
            but_role="text" 
            but_icon="ut2-icon-baseline-favorite-border" 
            but_onclick=$but_onclick 
            but_href=$but_href
    }
{/if}