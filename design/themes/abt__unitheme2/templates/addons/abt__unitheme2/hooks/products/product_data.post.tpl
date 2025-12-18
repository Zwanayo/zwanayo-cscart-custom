
{capture name="abt__service_buttons_id"}{if $block.properties}ut2_list_buttons_{$obj_id}_{$block.block_id}_{$selected_layout|default:{str_replace("/", "_", substr($block.properties.template|default:"", 0,-4))}}{/if}{/capture}


{$c_name = "add_to_cart_`$obj_id`"}
{if $details_page &&  $smarty.capture.$c_name|strpos:'checkout.add..'}
    {capture name="abt__ut2_cart_button_id"}{$_but_id}{/capture}
{/if}
