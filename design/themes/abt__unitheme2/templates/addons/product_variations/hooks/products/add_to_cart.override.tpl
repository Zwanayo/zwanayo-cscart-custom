{$show_select_variations_button=$show_select_variations_button|default:true}

{if $settings.abt__ut2.product_list.product_variations.allow_variations_selection[$settings.abt__device] === "YesNo::YES"|enum && !$details_page && $product.has_child_variations && $show_select_variations_button && $force_show_add_to_cart_button != "Y"}

    {if $smarty.request.redirect_url}
        {$current_url = $smarty.request.redirect_url|urlencode}
    {else}
        {$current_url = $config.current_url|urlencode}
    {/if}

    {hook name="products:add_to_cart"}
    {if $settings.abt__device == "mobile"}
        <span class="ty-btn ut2-btn__options ty-btn__primary ty-btn__add-to-cart cm-ab-load-select-variation-content" data-ca-product-id="{$product.product_id}"><span class="ty-icon ut2-icon-use_icon_cart"></span><bdi>{__("add_to_cart")}</bdi></span>
    {else}
        {ab__hide_content bot_type="ALL"}
        {include file="common/popupbox.tpl"
        href="products.ut2_select_variation?product_id={$product.product_id}&prev_url={$current_url}"
        text=__("add_to_cart")
        id="ut2_select_variation_{$obj_prefix}{$product.product_id}"
        link_text=__("add_to_cart")
        link_icon="ut2-icon-use_icon_cart"
        link_icon_first=true
        title=__("add_to_cart")
        link_meta="ty-btn ut2-btn__options ty-btn__primary ty-btn__add-to-cart cm-dialog-destroy-on-close"
        content=""
        dialog_additional_attrs=["data-ca-product-id" => $product.product_id, "data-ca-dialog-purpose" => "ut2_select_variantion"]
        }
        {/ab__hide_content}
    {/if}
    {/hook}
{/if}
