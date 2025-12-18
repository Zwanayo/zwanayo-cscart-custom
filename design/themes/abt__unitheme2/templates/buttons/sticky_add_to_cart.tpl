{if $smarty.capture.abt__ut2_cart_button_id}
    {$but_role = 'act'}
    <div class="ut2-pb__sticky_add_to_cart cm-external-click{if $product.product_id} cm-reload-{$product.product_id}{/if}" data-ca-external-click-id="{$smarty.capture.abt__ut2_cart_button_id}" id="ut2_pb__sticky_add_to_cart">
        <div class="ut2-pb__sticky_add_to_cart-price">
            {include file="common/price.tpl" value=$product.price}
        </div>
        {include file="buttons/add_to_cart.tpl" but_id=$but_id but_name="dispatch[checkout.add..`$obj_id`]" but_role=$but_role block_width=$block_width obj_id=$obj_id product=$product but_meta=$add_to_cart_meta but_text=__("add_to_cart") show_price_in_button=false}
<!--ut2_pb__sticky_add_to_cart--></div>
{/if}
