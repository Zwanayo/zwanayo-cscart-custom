{strip}
    {* Save product data in JS to use it later when getting section data via AJAX. *}
    {$assign_data = ["config" => ["current_url" => {$config.current_url}]]}
    {if $runtime.controller == "products" && $runtime.mode == "view"}
        {$assign_data["product"] = ["main_category" => $product.main_category, "price" => $product.price]}
    {/if}
<script data-no-defer>
    {$buttons_data=fn_abt__ut2_get_cart_wl_compare_state()}

    (function(_, $) {
        {* Init abt__ut2 - settings, data and functions *}
        $.extend(_, {
            abt__ut2: {
                settings: {$settings.abt__ut2|json_encode nofilter},
                controller : '{$runtime.controller}',
                mode : '{$runtime.mode}',
                device : '{$settings.abt__device}',
                {if $product.product_id}
                {$product_details_view = $product.product_id|fn_get_product_details_view}
                details_layout : '{"/"|explode:$product_details_view|@end|trim|rtrim:".tpl"}',
                {/if}
                temporary: { },
                assign_data: '{fn_encrypt_text(json_encode($assign_data))}',
                request: '{fn_encrypt_text(json_encode($smarty.request))}',
                templates: { },
                cart: {$buttons_data.cart|json_encode nofilter},
                wishlist: {$buttons_data.wishlist|json_encode nofilter},
                compare: {$buttons_data.compare|json_encode nofilter}
            }
        });
    }(Tygh, Tygh.$))

</script>
{/strip}
{script src="js/addons/abt__unitheme2/abt__ut2.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_ajax_blocks.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_grid_tabs.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_fly_menu.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_youtube.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_load_more.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_custom_combination.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_discussion.js"}
{script src="js/addons/abt__unitheme2/abt__ut2_video_banners.js"}

{*{if $settings.abt__ut2.general.lazy_load === "YesNo::YES"|enum}*}
{*    {script src="js/addons/abt__unitheme2/abt__ut2_lazy_load.js"}*}
{*{/if}*}
{if $settings.abt__ut2.product_list.show_cart_status !== 'not-show' || $settings.abt__ut2.product_list.show_favorite_compare_status === "Y"}
    {script src="js/addons/abt__unitheme2/abt__ut2_cart.js"}
{/if}

{if $addons.product_variations.status == "A" && $settings.abt__ut2.general.change_main_image_on_variation_hover.{$settings.abt__device} == "YesNo::YES"|enum}
    {script src="js/addons/abt__unitheme2/abt__ut2_variation_images.js"}
{/if}

{if in_array($settings.abt__ut2.product_list.products_multicolumns.enable_hover_gallery.{$settings.abt__device}, ["lines", "points"])
    ||
    in_array($settings.abt__ut2.product_list.products_without_options.enable_hover_gallery.{$settings.abt__device}, ["lines", "points"])}
    {script src="js/addons/abt__unitheme2/abt__ut2_hover_gallery.js"}
{/if}

{if $settings.abt__ut2.product_list.product_variations.allow_variations_selection[$settings.abt__device] === "YesNo::YES"|enum}
    {script src="js/addons/abt__unitheme2/ut2_select_variation.js"}
{/if}

{if $settings.abt__ut2.general.bfcache.{$settings.abt__device} === "YesNo::YES"|enum}
    {script src="js/addons/abt__unitheme2/abt__ut2_bfcache.js"}
{/if}