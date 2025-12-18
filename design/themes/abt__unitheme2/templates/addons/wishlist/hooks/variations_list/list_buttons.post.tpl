{if $show_add_to_wishlist}
    <div class="ty-valign-top">
        {include file="buttons/button.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_meta="ty-btn__tertiary ty-add-to-wish" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text" but_icon="ut2-icon-baseline-favorite-border" but_title=__("abt__ut2.add_to_wishlist.tooltip") but_tooltip=true but_onclick=$but_onclick but_href=$but_href}
    </div>
{/if}
