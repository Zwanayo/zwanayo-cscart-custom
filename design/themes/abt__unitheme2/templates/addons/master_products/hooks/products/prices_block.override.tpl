{if !$product.company_id && !$product.master_product_id}
{strip}
    {if $product.price|floatval || $product.zero_price_action == "P" || ($hide_add_to_cart_button == "Y" && $product.zero_price_action == "A")}
        {capture name="master_product_price_{$obj_prefix}{$obj_id}"}
            <span class="ty-master-products-products-prices-block__price ty-price{if !$product.price|floatval && !$product.zero_price_action} hidden{/if}" {""}
                  id="line_discounted_price_{$obj_prefix}{$obj_id}"
            >
                {include file="common/price.tpl"
                    value=$product.price
                    span_id="discounted_price_`$obj_prefix``$obj_id`"
                    class="ty-price-num"
                    live_editor_name="product:price:{$product.product_id}"
                    live_editor_phrase=$product.base_price
                }
            </span>
        {/capture}
        {if $addons.master_products.allow_buy_default_common_product === "YesNo::YES"|enum && $details_page && !$quick_view}
            {__("master_products.best_price", [
                "[formatted_price]" => $smarty.capture["master_product_price_{$obj_prefix}{$obj_id}"],
                "[link_class]" => "cm-scroll",
                "[data_scroll]" => "#tabs_content"
            ])}
        {else}
            {$other_offers_link = "products.view&product_id=`$product.product_id`#tabs_content"|fn_url}
            {$smarty.capture["master_product_price_{$obj_prefix}{$obj_id}"] nofilter}
            <a href="{$other_offers_link}" title="{__("master_products.vendor_products_filling")}" class="go_to_other_offers cm-tooltip"><i class="ut2-icon-local_offer"></i></a>
        {/if}
    {/if}
{/strip}
{/if}
