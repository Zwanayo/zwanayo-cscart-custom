{if !fn_ab__mb_has_template($ab__motivation_items, "addons/ab__motivation_block/blocks/components/item_templates/geo_maps.tpl")}
    {include
        file = "addons/geo_maps/views/geo_maps/shipping_estimation.tpl"
        shipping_methods = null
        product_id = $shipping_estimation_product_id|default:null
    }
{/if}