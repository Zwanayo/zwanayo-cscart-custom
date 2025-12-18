{** block-description:products **}

{if $block.properties.hide_add_to_cart_button == "YesNo::YES"|enum}
    {assign var="_show_add_to_cart" value=false}
{else}
    {assign var="_show_add_to_cart" value=true}
{/if}

{if $block.properties.hide_options == "YesNo::YES"|enum}
    {assign var="_show_product_options" value=false}
{else}
    {assign var="_show_product_options" value=true}
{/if}

{include file="blocks/list_templates/products_list.tpl" 
products=$items 
no_sorting="YesNo::YES"|enum
obj_prefix="`$block.block_id`000" 
no_pagination=true
show_name=true 
show_sku=true 
show_rating=true
show_rating_num=true
show_features=true 
show_prod_descr=true 
show_old_price=true 
show_price=true 
show_clean_price=true 
show_list_discount=true
show_product_labels=true
product_labels_mini=true
show_discount_label=true
show_shipping_label=true
show_product_amount=true
show_brand_logo=$settings.abt__ut2.product_list.products_without_options.show_brand_logo[$settings.abt__device]|default:{"YesNo::NO"|enum} == "YesNo::YES"|enum
show_product_options=$_show_product_options 
show_qty=true 
show_min_qty=true 
show_product_edp=true 
show_add_to_cart=$_show_add_to_cart 
show_list_buttons=true 
show_descr=true 
but_role="action" 
item_number=$block.properties.item_number
show_product_labels=true
show_discount_label=true
show_shipping_label=true}