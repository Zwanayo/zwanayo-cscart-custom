{** block-description:abt__ut2__scroller_advanced **}
{$tmpl='products_multicolumns'}

{if $block.properties.enable_quick_view == "YesNo::YES"|enum && $settings.abt__device != "mobile"}
    {$quick_nav_ids = $items|fn_fields_from_multi_level:"product_id":"product_id"}
{/if}

{if $block.properties.hide_add_to_cart_button == "YesNo::YES"|enum}
    {assign var="show_add_to_cart" value=false}
{else}
    {assign var="show_add_to_cart" value=true}
{/if}

{if $block.properties.show_price == "YesNo::YES"|enum}
    {assign var="show_price" value=true}
    {assign var="show_old_price" value=true}
    {assign var="show_clean_price" value=true}
{else}
    {assign var="show_price" value=false}
    {assign var="show_old_price" value=false}
    {assign var="show_clean_price" value=false}
{/if}

{assign var="show_name" value=true}
{assign var="show_rating" value=true}
{assign var="show_list_discount" value=$settings.abt__ut2.product_list.$tmpl.show_you_save[$settings.abt__device]|default:{"YesNo::NO"|enum} == "YesNo::YES"|enum}
{assign var="show_sku" value=$settings.abt__ut2.product_list.$tmpl.show_sku[$settings.abt__device]|default:{"YesNo::NO"|enum} == "YesNo::YES"|enum}
{assign var="show_qty" value=$settings.abt__ut2.product_list.$tmpl.show_qty[$settings.abt__device]|default:{"YesNo::NO"|enum} == "YesNo::YES"|enum}
{assign var="show_brand_logo" value=$settings.abt__ut2.product_list.$tmpl.show_brand_logo[$settings.abt__device]|default:{"YesNo::NO"|enum} == "YesNo::YES"|enum}
{assign var="hide_qty_label" value=true}
{assign var="show_product_amount" value=$settings.abt__ut2.product_list.$tmpl.show_amount[$settings.abt__device]|default:{"YesNo::NO"|enum} == "YesNo::YES"|enum}
{assign var="show_amount_label" value=false}
{assign scope='parent' var='show_product_labels' value=true}
{assign scope='parent' var='show_discount_label' value=true}
{assign scope='parent' var='show_shipping_label' value=true}
{assign var="show_list_buttons" value=false}
{assign var="but_role" value="action"}

{$show_labels_in_title = false}
{$button_type_add_to_cart = $settings.abt__ut2.product_list.$tmpl.show_button_add_to_cart[$settings.abt__device]}

{include file="blocks/product_list_templates/components/grid_list_settings.tpl"}

{* Thumb *}
{if !empty($block.properties.thumbnail_width)}
    {assign var="tbw" value=$block.properties.thumbnail_width}
{else}
    {assign var="tbw" value=$settings.abt__ut2.product_list.$tmpl.image_width[$settings.abt__device]|default:$settings.Thumbnails.product_lists_thumbnail_width}
{/if}
{if !empty($block.properties.abt__ut2_thumbnail_height)}
    {assign var="tbh" value=$block.properties.abt__ut2_thumbnail_height}
{else}
    {assign var="tbh" value=$settings.abt__ut2.product_list.$tmpl.image_height[$settings.abt__device]|default:$settings.Thumbnails.product_lists_thumbnail_height}
{/if}

{* FIXME: Don't move this file *}
{script src="js/tygh/product_image_gallery.js"}

{assign var="obj_prefix" value="`$block.block_id`000"}
{$block.block_id = {"`$block.block_id`_{uniqid()}"} scope=parent}

{if $block.properties.outside_navigation == "YesNo::YES"|enum}
    <div class="owl-theme ty-owl-controls">
        <div class="owl-controls clickable owl-controls-outside"  id="owl_outside_nav_{$block.block_id}">
            <div class="owl-buttons">
                <div id="owl_prev_{$obj_prefix}" class="owl-prev"><i class="ty-icon-left-open-thin"></i></div>
                <div id="owl_next_{$obj_prefix}" class="owl-next"><i class="ty-icon-right-open-thin"></i></div>
            </div>
        </div>
    </div>
{/if}

<div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list ty-scroller grid-list">
    {foreach from=$items item="product" name="for_products"}
        {hook name="products:product_scroller_advanced_list"}
            <div class="ut2-gl__item{if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount <= 0} out-of-stock{/if}" style="--gl-lines-in-name-product: {$settings.abt__ut2.product_list.$tmpl.lines_number_in_name_product[$settings.abt__device]};">

                {* Start ut2-gl *}
                {if $product}
                    {assign var="obj_id" value=$product.product_id}
                    {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}

                    {include file="common/product_data.tpl" product=$product product_labels_position="left-top" show_labels_in_title=$show_labels_in_title}

                    {hook name="products:product_multicolumns_list"}
                    {assign var="form_open" value="form_open_`$obj_id`"}
                    {$smarty.capture.$form_open nofilter}

                        <div class="ut2-gl__body{if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount < 1 && $product.out_of_stock_actions != "OutOfStockActions::BUY_IN_ADVANCE"|enum} decolorize{/if}">

                            <div class="ut2-gl__image" style="max-height:{$tbh}px">
                                {include file="views/products/components/product_icon.tpl"
                                product=$product
                                image_width=$tbw
                                image_height=$tbh
                                thumbnails_size=$thumbnails_size
                                show_gallery=false}

                                {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
                                {$smarty.capture.$product_labels nofilter}

                                <div class="ut2-w-c-q__buttons {if $settings.abt__ut2.product_list.hover_buttons_w_c_q[$settings.abt__device] == "YesNo::YES"|enum}w_c_q-hover{/if}" {if $smarty.capture.abt__service_buttons_id}id="{$smarty.capture.abt__service_buttons_id}"{/if}>
                                    {if !$quick_view && $settings.Appearance.enable_quick_view == "YesNo::YES"|enum && $settings.abt__device != "mobile"}
                                        {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids}
                                    {/if}
                                    {if $addons.wishlist.status == "ObjectStatuses::ACTIVE"|enum && !$hide_wishlist_button && $settings.abt__ut2.product_list.button_wish_list_view[$settings.abt__device] == "YesNo::YES"|enum}
                                        {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
                                    {/if}
                                    {if $settings.General.enable_compare_products == "YesNo::YES"|enum && !$hide_compare_list_button && $settings.abt__ut2.product_list.button_compare_view[$settings.abt__device] == "YesNo::YES"|enum || $product.feature_comparison == "YesNo::YES"|enum && $settings.abt__ut2.product_list.button_compare_view[$settings.abt__device] == "YesNo::YES"|enum}
                                        {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
                                    {/if}
                                    <!--{$smarty.capture.abt__service_buttons_id}--></div>

                                {if $show_brand_logo && $settings.abt__ut2.general.brand_feature_id > 0}
                                    {$b_feature=$product.abt__ut2_features[$settings.abt__ut2.general.brand_feature_id]}
                                    {if $b_feature.variants[$b_feature.variant_id].image_pairs}
                                        <div class="brand-img">
                                            {include file="common/image.tpl" image_height=20 images=$b_feature.variants[$b_feature.variant_id].image_pairs no_ids=true}
                                        </div>
                                    {/if}
                                {/if}
                            </div>

                            {capture name="product_multicolumns_list_control_data_wrapper"}
                                {if $show_add_to_cart && $button_type_add_to_cart != 'none'}
                                    {assign var="qty" value="qty_`$obj_id`"}

                                    <div class="ut2-gl__control
                                    {if $settings.abt__ut2.product_list.$tmpl.show_qty[$settings.abt__device] == "YesNo::YES"|enum && $smarty.capture.$qty|strip_tags:false|replace:"&nbsp;":""|trim|strlen} ut2-view-qty{/if}{if $button_type_add_to_cart != 'none'} {$button_type_add_to_cart}{/if}" {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}style="min-height: {$smarty.capture.abt__ut2_pr_block_height  nofilter}px;"{/if}>
                                        {capture name="product_multicolumns_list_control_data"}
                                            {hook name="products:product_multicolumns_list_control"}
                                            {$add_to_cart = "add_to_cart_`$obj_id`"}
                                            {$smarty.capture.$add_to_cart nofilter}

                                            {if $show_qty && $smarty.capture.$qty|strip_tags:false|replace:"&nbsp;":""|trim|strlen}
                                                {$smarty.capture.$qty nofilter}
                                            {/if}

                                            {/hook}
                                        {/capture}
                                        {$smarty.capture.product_multicolumns_list_control_data nofilter}
                                    </div>
                                {/if}
                            {/capture}

                            {if $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::YES"|enum}
                                {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                                    <div class="ut2-gl__mix-price-and-button {if $show_qty}qty-wrap{/if}" style="align-items: flex-start;">
                                {/if}

                                <div class="ut2-gl__price{if $product.price == 0} ut2-gl__no-price{/if}	pr-{$settings.abt__ut2.product_list.price_display_format}{if $product.list_discount || $product.discount} pr-color{/if}" style="min-height: {$smarty.capture.abt__ut2_pr_block_height  nofilter}px;">
                                    {hook name="products:list_price_block"}
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
                                    {/hook}
                                </div>

                                {if $button_type_add_to_cart == 'icon' && $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::YES"|enum || $button_type_add_to_cart == 'icon_button' && $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::YES"|enum}
                                    {if $smarty.capture.product_multicolumns_list_control_data|trim}
                                        {$smarty.capture.product_multicolumns_list_control_data_wrapper nofilter}
                                    {/if}
                                {/if}

                                {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                                    </div>
                                {/if}
                            {/if}

                            <div class="ut2-gl__content" style="min-height: {$smarty.capture.abt__ut2_gl_content_height nofilter}px">

                                {if $product.product_code}
                                    {assign var="sku" value="sku_$obj_id"}
                                    {$smarty.capture.$sku nofilter}
                                {/if}

                                <div class="ut2-gl__name">
                                    {if $item_number == "YesNo::YES"|enum}
                                        <span class="item-number">{$cur_number}.&nbsp;</span>
                                        {math equation="num + 1" num=$cur_number assign="cur_number"}
                                    {/if}

                                    {assign var="name" value="name_$obj_id"}
                                    {$smarty.capture.$name nofilter}
                                </div>

                                {include file="blocks/product_list_templates/components/average_rating.tpl"}

                                {if $settings.abt__ut2.product_list.$tmpl.show_amount[$settings.abt__device] == "YesNo::YES"|enum}
                                    <div class="ut2-gl__amount">
                                        {assign var="product_amount" value="product_amount_`$obj_id`"}
                                        {$smarty.capture.$product_amount nofilter}
                                    </div>
                                {/if}

                                {if $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::NO"|enum}
                                {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                                <div class="ut2-gl__mix-price-and-button {if $show_qty}qty-wrap{/if}">
                                    {/if}
                                    {/if}

                                    {if $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::NO"|enum}
                                        <div class="ut2-gl__price{if $product.price == 0} ut2-gl__no-price{/if}	pr-{$settings.abt__ut2.product_list.price_display_format}{if $product.list_discount || $product.discount} pr-color{/if}" style="min-height: {$smarty.capture.abt__ut2_pr_block_height nofilter}px;">
                                            {hook name="products:list_price_block"}
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
                                            {/hook}
                                        </div>
                                    {/if}

                                    {if $button_type_add_to_cart == 'text' || $button_type_add_to_cart == 'icon_and_text'}
                                        {if $smarty.capture.product_multicolumns_list_control_data|trim}
                                            {$smarty.capture.product_multicolumns_list_control_data_wrapper nofilter}
                                        {/if}
                                    {elseif $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::NO"|enum }
                                        {if $smarty.capture.product_multicolumns_list_control_data|trim}
                                            {$smarty.capture.product_multicolumns_list_control_data_wrapper nofilter}
                                        {/if}
                                    {/if}

                                    {if $settings.abt__ut2.product_list.price_position_top|default:{"YesNo::YES"|enum} == "YesNo::NO"|enum}
                                    {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
                                </div>
                                {/if}
                                {/if}

                            </div>{* End "ut2-gl__content" conteiner *}

                            {hook name="products:ab__mv_vendor_info"}{/hook}
                        </div>

                    {hook name="products:product_list_form_close_tag"}
                    {assign var="form_close" value="form_close_`$obj_id`"}
                    {$smarty.capture.$form_close nofilter}
                    {/hook}

                    {/hook}
                {/if}
                {* End ut2-gl *}

            </div>
        {/hook}
    {/foreach}
</div>

{include file="common/scroller_init.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`"}
