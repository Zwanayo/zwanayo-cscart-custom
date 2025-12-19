{if $products}
    {$tmpl='products_without_options'}
	{assign var='show_list_buttons' value=false}

	{* Thumb *}
    {assign var="tbw" value=$settings.abt__ut2.product_list.$tmpl.image_width[$settings.abt__device]|default:$settings.Thumbnails.product_lists_thumbnail_width}
    {assign var="tbh" value=$settings.abt__ut2.product_list.$tmpl.image_height[$settings.abt__device]|default:$settings.Thumbnails.product_lists_thumbnail_height}

	{$show_labels_in_title = false}
    {$defaul_show_brand_logo = $settings.abt__ut2.product_list.products_without_options.show_brand_logo[$settings.abt__device] == "YesNo::YES"|enum}
    {$show_brand_logo = $show_brand_logo|default:$defaul_show_brand_logo}

	{include file="blocks/product_list_templates/components/show_features_conditions.tpl"}

    {script src="js/tygh/exceptions.js"}

    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}

    {if !$no_sorting}
        {include file="views/products/components/sorting.tpl"}
    {/if}

    {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="{"`$runtime.controller`_`$runtime.mode`"}" position="top" object="products"}{/if}
    {foreach from=$products item=product key=key name="products"}
        {capture name="capt_options_vs_qty"}{/capture}

        {hook name="products:product_block"}
            {assign var="obj_id" value=$product.product_id}
            {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}

            {include file="common/product_data.tpl" product=$product min_qty=true product_labels_position="left-top" show_labels_in_title=false}

            <div class="ty-product-list {if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount < 1 && $product.out_of_stock_actions != "OutOfStockActions::BUY_IN_ADVANCE"|enum}decolorize{/if} clearfix"{if $ut2_load_more && $smarty.foreach.products.first} data-ut2-load-more="first-item"{/if}>

                {assign var="form_open" value="form_open_`$obj_id`"}
                {$smarty.capture.$form_open nofilter}
                {if $bulk_addition}
                    <input class="cm-item ty-float-right ty-product-list__bulk" type="checkbox" id="bulk_addition_{$obj_prefix}{$product.product_id}" name="product_data[{$product.product_id}][amount]" value="{if $js_product_var}{$product.product_id}{else}1{/if}" {if ($product.zero_price_action == "R" && $product.price == 0)}disabled="disabled"{/if} />
                {/if}

                <div class="ut2-pl__image" {if $settings.abt__device == "desktop"}style="width: {$tbw|intval}px;max-height: {$tbh|intval}px"{/if}>
                    {assign var="product_link" value="products.view?product_id=`$product.product_id`"|fn_url}
                    {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
                    {$smarty.capture.$product_labels nofilter}

                    {hook name="products:product_block_image"}
                    {if $settings.abt__ut2.product_list.{$tmpl}.enable_hover_gallery.{$settings.abt__device} === "YesNo::NO"|enum}
                        <div class="ty-center-block">
                            <div class="ty-thumbs-wrapper owl-carousel cm-image-gallery ty-scroller"
                                 data-ca-items-count="1"
                                 data-ca-items-responsive="true"
                                 data-ca-scroller-item="1"
                                 data-ca-scroller-item-desktop="1"
                                 data-ca-scroller-item-desktop-small="1"
                                 data-ca-scroller-item-tablet="1"
                                 data-ca-scroller-item-mobile="1"
                                 data-ca-product-list="{$tmpl}"
                                 id="icons_{$obj_id_prefix}">
                                {if $product.main_pair}
                                    <div class="cm-gallery-item cm-item-gallery ty-scroller__item">
                                        <a href="{$product_link}">
                                        {include file="common/image.tpl" image_width=$tbw image_height=$tbh obj_id=$obj_id_prefix images=$product.main_pair class="img-ab-hover-gallery"}
                                        </a>
                                    </div>
                                {/if}
                                {foreach from=$product.image_pairs item="image_pair"}
                                    {if $image_pair}
                                        <div class="cm-gallery-item cm-item-gallery ty-scroller__item">
                                            <a href="{"$product_link"}">
                                                {include file="common/image.tpl" no_ids=true
                                                images=$image_pair
                                                image_width=$tbw
                                                image_height=$tbh
                                                }
                                            </a>
                                        </div>
                                    {/if}
                                {/foreach}
                            </div>
                        </div>
                        {script src="js/tygh/product_image_gallery.js"}
                    {else}
                        <div class="cm-reload-{$obj_prefix}{$obj_id} image-reload" id="list_image_update_{$obj_prefix}{$obj_id}">
                            {if !$hide_links}
                                <a href="{$product_link}">
                                <input type="hidden" name="image[list_image_update_{$obj_prefix}{$obj_id}][link]" value="{"products.view?product_id=`$product.product_id`"|fn_url}" />
                            {/if}

                            <input type="hidden" name="image[list_image_update_{$obj_prefix}{$obj_id}][data]" value="{$obj_id_prefix},{$tbw},{$tbw},product" />
                            {include file="common/image.tpl" image_width=$tbw image_height=$tbh obj_id=$obj_id_prefix images=$product.main_pair class="img-ab-hover-gallery"}
                               {if in_array($settings.abt__ut2.product_list.products_without_options.enable_hover_gallery.{$settings.abt__device}, ["lines", "points"])}
                                    {include file="views/products/components/ab__hover_gallery.tpl"
                                        image_pairs=$product.image_pairs
                                        image_width=$tbw
                                        image_height=$tbh
                                        additional_class=$settings.abt__ut2.product_list.products_without_options.enable_hover_gallery.{$settings.abt__device}
                                    }
                                {/if}
                            {if !$hide_links}
                                </a>
                            {/if}
                        <!--list_image_update_{$obj_prefix}{$obj_id}--></div>
                    {/if}
                    {/hook}

                    <div class="ut2-w-c-q__buttons {if $settings.abt__ut2.product_list.hover_buttons_w_c_q[$settings.abt__device] == "YesNo::YES"|enum}w_c_q-hover{/if}" {if $smarty.capture.abt__service_buttons_id}id="{$smarty.capture.abt__service_buttons_id}"{/if}>
                        {if $addons.wishlist.status == "ObjectStatuses::ACTIVE"|enum && !$hide_wishlist_button && $settings.abt__ut2.product_list.button_wish_list_view[$settings.abt__device] == "YesNo::YES"|enum}
                            {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
                        {/if}
                        {if $settings.General.enable_compare_products == "YesNo::YES"|enum && !$hide_compare_list_button && $settings.abt__ut2.product_list.button_compare_view[$settings.abt__device] == "YesNo::YES"|enum || $product.feature_comparison == "YesNo::YES"|enum && $settings.abt__ut2.product_list.button_compare_view[$settings.abt__device] == "YesNo::YES"|enum}
                            {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
                        {/if}
                    <!--{$smarty.capture.abt__service_buttons_id}--></div>
                </div>

                <div class="ut2-pl__content">
                {hook name="products:product_block_content"}
                    {if $js_product_var}
                        <input type="hidden" id="product_{$obj_prefix}{$product.product_id}" value="{$product.product}" />
                    {/if}
                    {* res_delete_1 *}
                    {if $item_number == "YesNo::YES"|enum}<strong>{$smarty.foreach.products.iteration}.&nbsp;</strong>{/if}
                    {* /res_delete_1 *}

                    <div class="ut2-pl__info" style="min-height: {$settings.Thumbnails.product_lists_thumbnail_height}px">
                        <div class="ut2-pl__item-name">
                            {assign var="name" value="name_$obj_id"}
                            <bdi>{$smarty.capture.$name nofilter}</bdi>

                            {if $show_brand_logo && $settings.abt__ut2.general.brand_feature_id > 0}
                                {$b_feature = $product.abt__ut2_features[$settings.abt__ut2.general.brand_feature_id]}
                                {if $b_feature.variants[$b_feature.variant_id].image_pairs}
                                    <div class="brand-img" style="height:20px">
                                        {include file="common/image.tpl" image_height=20 images=$b_feature.variants[$b_feature.variant_id].image_pairs no_ids=true}
                                    </div>
                                {/if}
                            {/if}
                        </div>
                        
                        <div class="ut2-pl__extra-block clearfix">
                            {include file="blocks/product_list_templates/components/average_rating.tpl"}

                            {if $product.product_code}{assign var="sku" value="sku_$obj_id"}{$smarty.capture.$sku nofilter}{/if}
                        </div>

						{assign var="prod_descr" value="prod_descr_`$obj_id`"}
                        {if $show_descr && $smarty.capture.$prod_descr}
                            <div class="ut2-pl__description">
                                {$smarty.capture.$prod_descr nofilter}
                            </div>
                            
                            {hook name="products:additional_info_before"}{/hook}
                        {/if}

                        {hook name="products:additional_info"}{/hook}
                        {hook name="products:ab__s_pictograms_pos_1"}{/hook}

						{if $show_features && !$hide_features && $product.abt__ut2_features && $settings.abt__ut2.product_list.$tmpl.item_bottom_content[$settings.abt__device] != 'none'}
                            <div class="ut2-pl__feature">
                                {assign var="product_features" value="product_features_`$obj_id`"}
                                {$smarty.capture.$product_features nofilter}
                            </div>
                        {/if}

                        {hook name="products:ab__s_pictograms_pos_2"}{/hook}

                    </div>

                    <div class="ut2-pl__control">
                        {hook name="products:list_price_block"}
                        <div class="ut2-pl__price {if $product.price == 0}ut2-gl__no-price{/if}	pr-{$settings.abt__ut2.product_list.price_display_format}{if $product.list_discount || $product.discount} pr-color{/if}">
                            <div>
                                {assign var="old_price" value="old_price_`$obj_id`"}
                                {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}

                                {assign var="price" value="price_`$obj_id`"}
                                {$smarty.capture.$price nofilter}
                            </div>
                            <div>
                                {assign var="list_discount" value="list_discount_`$obj_id`"}
                                {$smarty.capture.$list_discount nofilter}

                                {assign var="clean_price" value="clean_price_`$obj_id`"}
                                {$smarty.capture.$clean_price nofilter}
							</div>
                        </div>
                        {/hook}

                        {if !$smarty.capture.capt_options_vs_qty}
                            <div class="ty-product-list__option">
                                {assign var="product_options" value="product_options_`$obj_id`"}
                                {$smarty.capture.$product_options nofilter}
                            </div>

                            {assign var="product_amount" value="product_amount_`$obj_id`"}
                            {$smarty.capture.$product_amount nofilter}

                            {if $settings.abt__device == "mobile"}{hook name="products:ab__mv_vendor_info"}{/hook}{/if}

                            <div class="ut2-pl__qty-wrap">
                                {if $settings.abt__ut2.product_list.$tmpl.show_qty[$settings.abt__device] == "YesNo::YES"|enum}
                                    {assign var="qty" value="qty_`$obj_id`"}
                                    {$smarty.capture.$qty nofilter}
                                {/if}

                                {assign var="min_qty" value="min_qty_`$obj_id`"}
                                {$smarty.capture.$min_qty nofilter}

                                {assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
                                {$smarty.capture.$add_to_cart nofilter}
                            </div>
                        {/if}

                        {assign var="product_edp" value="product_edp_`$obj_id`"}
                        {$smarty.capture.$product_edp nofilter}

                        {if $settings.abt__device != "mobile"}{hook name="products:ab__mv_vendor_info"}{/hook}{/if}
                    </div>
                {/hook}
                </div>
                {hook name="products:product_list_form_close_tag"}
                    {assign var="form_close" value="form_close_`$obj_id`"}
                    {$smarty.capture.$form_close nofilter}
                {/hook}
            </div>
            {if !$smarty.foreach.products.last}{/if}
        {/hook}
    {/foreach}
    {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="{"`$runtime.controller`_`$runtime.mode`"}" position="bottom" object="products"}{/if}

    {if $bulk_addition}
        <script>
            (function(_, $) {

                $(document).ready(function() {

                    $.ceEvent('on', 'ce.commoninit', function(context) {
                        if (context.find('input[type=checkbox][id^=bulk_addition_]').length) {
                            context.find('.cm-picker-product-options').switchAvailability(true, false);
                        }
                    });

                    $(_.doc).on('click', '.cm-item', function() {
                        $('#opt_' + $(this).prop('id').replace('bulk_addition_', '')).switchAvailability(!this.checked, false);
                    });
                });

            }(Tygh, Tygh.$));
        </script>
    {/if}

    {if !$no_pagination}
        {include file="common/pagination.tpl" force_ajax=$force_ajax}
    {/if}

{/if}

{capture name="mainbox_title"}{$title}{/capture}