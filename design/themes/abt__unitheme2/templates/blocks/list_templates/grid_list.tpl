{strip}
{if $products}
    {$tmpl='products_multicolumns'}

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

    {$button_type_add_to_cart = $settings.abt__ut2.product_list.$tmpl.show_button_add_to_cart[$settings.abt__device]}

	{include file="blocks/product_list_templates/components/show_features_conditions.tpl"}
	{include file="blocks/product_list_templates/components/grid_list_settings.tpl"}

    {if !($ab__add_ajax_loading_button && $smarty.const.AJAX_REQUEST)}
        {script src="js/tygh/exceptions.js"}
    {/if}

    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}

    {if !$no_sorting}
        {include file="views/products/components/sorting.tpl"}
    {/if}

    {if !$show_empty && !$native_scroller}
        {split data=$products size=$columns|default:"2" assign="splitted_products"}
    {else}
        {split data=$products size=$columns|default:"2" assign="splitted_products" skip_complete=true}
    {/if}

    {$show_labels_in_title = false}

    {math equation="100 / x" x=$columns|default:"2" assign="cell_width"}
    {if $item_number == "YesNo::YES"|enum}
        {assign var="cur_number" value=1}
    {/if}

    {if !($ab__add_ajax_loading_button && $smarty.const.AJAX_REQUEST)}
        {* FIXME: Don't move this file *}
        {script src="js/tygh/product_image_gallery.js"}
    {/if}

    {if $settings.Appearance.enable_quick_view == "YesNo::YES"|enum && $settings.abt__device != "mobile"}
        {$quick_nav_ids = $products|fn_fields_from_multi_level:"product_id":"product_id"}
    {/if}

    <div class="grid-list {$show_custom_class}{if $ab__add_ajax_loading_button} {/if}{if $native_scroller} ut2-native-scroller{/if}" style="--gl-lines-in-name-product: {$settings.abt__ut2.product_list.$tmpl.lines_number_in_name_product[$settings.abt__device]};">

        {if $ab__add_ajax_loading_button}<div class="grid-list__load-more">{/if}
        {if $native_scroller}<div>{/if}
        {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="`$runtime.controller`_`$runtime.mode`" position="top" object="products"}{/if}

        {foreach from=$splitted_products item="sproducts" name="sprod"}
            {foreach from=$sproducts item="product" name="sproducts"}

                <div class="ty-column{if $native_scroller}{$block.properties.item_quantity|default:5}{else}{$columns}{/if}"{if $ut2_load_more && $smarty.foreach.sprod.first && $smarty.foreach.sproducts.first} data-ut2-load-more="first-item"{/if}>

                    {if $product}
                        {assign var="obj_id" value=$product.product_id}
                        {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id``$settings.abt__device`"}

                        {include file="common/product_data.tpl" product=$product product_labels_position="left-top" show_labels_in_title=false}

                        <div class="ut2-gl__item {if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount <= 0} out-of-stock{/if}" style="aspect-ratio: var(--gl-item-width) / var(--gl-item-height)">

                        {hook name="products:product_multicolumns_list"}

                        {assign var="form_open" value="form_open_`$obj_id`"}
                        {$smarty.capture.$form_open nofilter}

                        <div class="ut2-gl__body{if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::YES"|enum} content-on-hover{/if}{if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount < 1 && $product.out_of_stock_actions != "OutOfStockActions::BUY_IN_ADVANCE"|enum} decolorize{/if}">

                            <div class="ut2-gl__image {if !$product.image_pairs}ut2-gl__no-image{/if}" style="max-height:{$tbh}px;aspect-ratio: {$tbw} / {$tbh};">
                                {include file="views/products/components/product_icon.tpl"
                                product=$product
                                image_width=$tbw
                                image_height=$tbh
                                thumbnails_size=$thumbnails_size
                                show_gallery=$settings.abt__ut2.product_list.{$tmpl}.show_gallery.{$settings.abt__device} != "YesNo::NO"|enum}

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
                                        {if $settings.abt__ut2.product_list.$tmpl.show_buttons_on_hover[$settings.abt__device] == "YesNo::YES"|enum && !$native_scroller} hidden{/if}
                                        {if $settings.abt__ut2.product_list.$tmpl.show_qty[$settings.abt__device] == "YesNo::YES"|enum && $smarty.capture.$qty|strip_tags:false|replace:"&nbsp;":""|trim|strlen} ut2-view-qty{/if}{if $button_type_add_to_cart != 'none'} {$button_type_add_to_cart}{/if}" {if $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}style="min-height: {$smarty.capture.abt__ut2_pr_block_height nofilter}px;"{/if}>
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
                                    <div class="ut2-gl__mix-price-and-button {if $show_qty}qty-wrap{/if}">
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

                            <div class="ut2-gl__content{if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::YES"|enum} content-on-hover{/if}" style="min-height:{$smarty.capture.abt__ut2_gl_content_height nofilter}px;">

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

                                {if $show_features || $show_descr}
                                    {if empty($block.properties) && $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::NO"|enum && !$native_scroller}
                                        <div class="ut2-gl__bottom">
                                            {hook name="products:additional_info_before"}{/hook}
                                            {if $show_descr && $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] != "features_and_variations"}
                                                {assign var="prod_descr" value="prod_descr_`$obj_id`"}
                                                {$smarty.capture.$prod_descr nofilter}
                                            {/if}

                                            {hook name="products:ab__s_pictograms_pos_1"}{/hook}

                                            {if $product.abt__ut2_features && !$hide_features}
                                                <div class="ut2-gl__feature">
                                                    {assign var="product_features" value="product_features_`$obj_id`"}
                                                    {$smarty.capture.$product_features nofilter}
                                                </div>
                                            {/if}

                                            {hook name="products:ab__s_pictograms_pos_2"}{/hook}
                                        </div>
                                    {/if}
                                {/if}

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

                            {if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::YES"|enum && $settings.abt__device != "mobile" && !$native_scroller}
                                <div class="ut2-gl__bottom">
                                    {hook name="products:additional_info"}{/hook}
                                    {hook name="products:additional_info_before"}{/hook}

                                    {if $show_descr && $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] != "features_and_variations"}
                                        {assign var="prod_descr" value="prod_descr_`$obj_id`"}
                                        {$smarty.capture.$prod_descr nofilter}
                                    {/if}

                                    {hook name="products:ab__s_pictograms_pos_1"}{/hook}

                                    {if $show_features and $product.abt__ut2_features && !$hide_features}
                                        <div class="ut2-gl__feature">
                                            {assign var="product_features" value="product_features_`$obj_id`"}
                                            {$smarty.capture.$product_features nofilter}
                                        </div>
                                    {/if}

                                    {hook name="products:ab__s_pictograms_pos_2"}{/hook}
                                    {hook name="products:additional_info_after"}{/hook}
                                </div>
                            {/if}
                        </div>
                        {hook name="products:product_list_form_close_tag"}
                            {assign var="form_close" value="form_close_`$obj_id`"}
                            {$smarty.capture.$form_close nofilter}
                        {/hook}
                    {/hook}
                    </div>
                    {/if}
                </div>

            {/foreach}

            {if $show_empty && $smarty.foreach.sprod.last}
                {assign var="iteration" value=$smarty.foreach.sproducts.iteration}
                {capture name="iteration"}{$iteration}{/capture}
                {hook name="products:$tmpl_extra"}
                {/hook}
                {assign var="iteration" value=$smarty.capture.iteration}
                {if $iteration % $columns != 0}
                    {math assign="empty_count" equation="c - it%c" it=$iteration c=$columns}
                    {section loop=$empty_count name="empty_rows"}
                        <div class="ty-column{$columns}">
                            <div class="ut2-gl__item ut2-product-empty" style="aspect-ratio: var(--gl-item-width) / var(--gl-item-height)">
                                <div class="ut2-gl__body">
                                <span class="ty-product-empty__text">{__("empty")}</span>
                                <div class="ut2-gl__image" style="min-height: {$tbh}px;"></div>
                                <div class="ut2-gl__content" style="min-height:{$smarty.capture.abt__ut2_gl_content_height nofilter}px;">
                                </div>
                                </div>
                            </div>
                        </div>
                    {/section}
                {/if}
            {/if}
        {/foreach}

        {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="`$runtime.controller`_`$runtime.mode`" position="bottom" object="products"}{/if}
        {if $native_scroller}</div>{/if}

        {if $ab__add_ajax_loading_button}
	    </div>
            {$page = $block.content.items.page|default:1}
            {$id = "ut2_load_more_block_`$block.block_id`_`$block.snapping_id`"}
            {$load_more_total = $ut2_total_products_block_{$block.block_id}}
            {if $block.content.items.limit && $block.content.items.limit < $load_more_total}
                {$load_more_total = $block.content.items.limit}
            {/if}

            {$products_left = $load_more_total - $page * $block.properties.number_of_columns}

            {hook name="products:ut2_load_more_block"}
                {if $products_left > 0}
                    {if $products_left > $block.properties.number_of_columns && $block.properties.abt__ut2_loading_type == "onclick"}
                        {$show_more_num = $block.properties.number_of_columns}
                    {else}
                        {$show_more_num = $products_left}
                    {/if}

                    {$show_more_button='abt__ut2.load_more.show_more.products'}
                    {if $block.type != 'main'}
                        {$show_more_button='abt__ut2.load_more.show_more'}
                    {/if}

                    <div id="{$id}_{$page + 1}" {if $page > 1 && $block.properties.abt__ut2_loading_type == "onclick_and_scroll"}class="hidden"{/if}>
                                <span id="{$id}_button" class="ty-btn ty-btn__secondary ty-ab-load-more-btn"
                                      data-ca-snapping="{$block.snapping_id}"
                                      data-ca-grid-id="{$block.grid_id}"
                                      data-ca-block-id="{$block.block_id}"
                                      data-ca-current-page="{$page}"
                                      data-ca-load-type="{$block.properties.abt__ut2_loading_type}"
                                      data-ca-request-params="{fn_encrypt_text(json_encode($smarty.request))}"
                                >{__($show_more_button, [$show_more_num])}</span>
                        <!--{$id_{$page + 1}}--></div>
                {/if}
            {/hook}
        {/if}
    </div>

    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}

{/if}

{capture name="mainbox_title"}{$title}{/capture}
{/strip}
