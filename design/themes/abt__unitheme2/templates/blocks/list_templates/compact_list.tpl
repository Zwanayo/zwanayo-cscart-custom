{if $products}

	{$tmpl='short_list'}
	
	{* Thumb *}
    {assign var="tbw" value=$settings.abt__ut2.product_list.$tmpl.image_width[$settings.abt__device]|default:100px}   
    {assign var="tbh" value=$settings.abt__ut2.product_list.$tmpl.image_height[$settings.abt__device]|default:100px}

    {script src="js/tygh/exceptions.js"}

    {if !$no_pagination}
        {include file="common/pagination.tpl"}
    {/if}

    {if !$no_sorting}
        {include file="views/products/components/sorting.tpl"}
    {/if}

    {assign var="image_width" value=$image_width|default:100}
    {assign var="image_height" value=$image_height|default:100}

    {$show_labels_in_title = false}
    
    <div class="ty-compact-list">
        {hook name="products:product_compact_list_view"}

        {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="{"`$runtime.controller`_`$runtime.mode`"}" position="top"}{/if}
        {foreach from=$products item="product" key="key" name="products"}
            {assign var="obj_id" value=$product.product_id}
            {assign var="obj_id_prefix" value="`$obj_prefix``$product.product_id`"}
            {include file="common/product_data.tpl" hide_form=false product=$product product_labels_position="left-top" show_labels_in_title=false}
            {hook name="products:product_compact_list"}
                <div class="ty-compact-list__item {if $settings.abt__ut2.product_list.decolorate_out_of_stock_products == "YesNo::YES"|enum && $product.amount < 1 && $product.out_of_stock_actions != "OutOfStockActions::BUY_IN_ADVANCE"|enum} decolorize{/if}" {if $ut2_load_more && $smarty.foreach.products.first} data-ut2-load-more="first-item"{/if}>

                    {assign var="form_open" value="form_open_`$obj_id`"}
                    {$smarty.capture.$form_open nofilter}

                        <div class="ty-compact-list__content">

                            {hook name="products:product_compact_list_image"}
                            <div class="ty-compact-list__image">
                                <a href="{"products.view?product_id=`$product.product_id`"|fn_url}">
                                    {include file="common/image.tpl" image_width=$tbw image_height=$tbh images=$product.main_pair obj_id=$obj_id_prefix}
                                </a>
                                {assign var="product_labels" value="product_labels_`$obj_prefix``$obj_id`"}
                                {$smarty.capture.$product_labels nofilter}
                            </div>
                            {/hook}

                            <div class="ty-compact-list__title">
                                {assign var="name" value="name_$obj_id"}
                                <span>
                                {$smarty.capture.$name nofilter}

                                {if $settings.abt__device == "mobile"}
                                    <div class="ty-dropdown-box">
                                        <div id="sw_box_w_c_{$obj_id}" class="cm-combination"><i class="ut2-icon-more_vert"></i></div>
                                        <div id="box_w_c_{$obj_id}" class="cm-popup-box ty-dropdown-box__content hidden">
                                        {if $addons.wishlist.status == "ObjectStatuses::ACTIVE"|enum && !$hide_wishlist_button && $settings.abt__ut2.product_list.button_wish_list_view[$settings.abt__device] == "YesNo::YES"|enum}
                                            {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text" but_label=true}
                                        {/if}
                                        {if $settings.General.enable_compare_products == "YesNo::YES"|enum && !$hide_compare_list_button && $settings.abt__ut2.product_list.button_compare_view[$settings.abt__device] == "YesNo::YES"|enum}
                                            {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id but_label=true}
                                        {/if}
                                        </div>
                                    </div>
                                {/if}
                                </span>

                                {include file="blocks/product_list_templates/components/average_rating.tpl"}
    							
    							{if $settings.abt__ut2.product_list.short_list.show_sku[$settings.abt__device] == "YesNo::YES"|enum && $product.product_code}
    							    <div class="ty-compact-list__sku">
                                        {$sku = "sku_`$obj_id`"}
                                        {$smarty.capture.$sku nofilter}
                                    </div>
                                {/if}
                                
                                {if $settings.abt__ut2.product_list.short_list.show_amount[$settings.abt__device] == "YesNo::YES"|enum}
    							    <div class="ty-compact-list__amount">
                                        {assign var="product_amount" value="product_amount_`$obj_id`"}
                                        {$smarty.capture.$product_amount nofilter}
                                    </div>
                                {/if}

                                {hook name="products:ab__mv_vendor_info"}{/hook}
                                {hook name="products:ab__s_pictograms_pos_1"}{/hook}
                            </div>

                            <div class="ty-compact-list__controls">

		                        <div class="ty-compact-list__price pr-{$settings.abt__ut2.product_list.price_display_format}{if $product.list_discount || $product.discount} pr-color{/if}">
		                            <div>
		                                {assign var="old_price" value="old_price_`$obj_id`"}
		                                {if $smarty.capture.$old_price|trim}{$smarty.capture.$old_price nofilter}{/if}

		                                {assign var="price" value="price_`$obj_id`"}
		                                {$smarty.capture.$price nofilter}
									</div>
		                                {assign var="clean_price" value="clean_price_`$obj_id`"}
		                                {$smarty.capture.$clean_price nofilter}
		                        </div>
                                <div class="ut2-compact-list__buttons">
                                    {if $show_add_to_cart}
                                        {assign var="add_to_cart" value="add_to_cart_`$obj_id`"}
                                        {$smarty.capture.$add_to_cart nofilter}
                                    {/if}
                                    {if !$smarty.capture.capt_options_vs_qty}
                                        {assign var="product_options" value="product_options_`$obj_id`"}
                                        {$smarty.capture.$product_options nofilter}

                                        {assign var="qty" value="qty_`$obj_id`"}
                                        {$smarty.capture.$qty nofilter}
                                    {/if}
                                    {if $settings.abt__device != "mobile"}
                                    <div class="ut2-cl-bt" id="{$smarty.capture.abt__service_buttons_id}">
                                        {if !$quick_view && $settings.Appearance.enable_quick_view == "YesNo::YES"|enum}
                                            {include file="views/products/components/quick_view_link.tpl" quick_nav_ids=$quick_nav_ids}
                                        {/if}
                                        {if $addons.wishlist.status == "ObjectStatuses::ACTIVE"|enum && !$hide_wishlist_button && $settings.abt__ut2.product_list.button_wish_list_view[$settings.abt__device] == "YesNo::YES"|enum}
                                            {include file="addons/wishlist/views/wishlist/components/add_to_wishlist.tpl" but_id="button_wishlist_`$obj_prefix``$product.product_id`" but_name="dispatch[wishlist.add..`$product.product_id`]" but_role="text"}
                                        {/if}
                                        {if $settings.General.enable_compare_products == "YesNo::YES"|enum && !$hide_compare_list_button && $settings.abt__ut2.product_list.button_compare_view[$settings.abt__device] == "YesNo::YES"|enum}
                                            {include file="buttons/add_to_compare_list.tpl" product_id=$product.product_id}
                                        {/if}
                                    <!--{$smarty.capture.abt__service_buttons_id}--></div>
                                    {/if}
                                </div>
                            </div>
                        </div>

                    {assign var="form_close" value="form_close_`$obj_id`"}
                    {$smarty.capture.$form_close nofilter}
                </div>
            {/hook}
        {/foreach}

        {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="{"`$runtime.controller`_`$runtime.mode`"}" position="bottom" object="products"}{/if}

        {/hook}
    </div>

{if !$no_pagination}
    {include file="common/pagination.tpl" force_ajax=$force_ajax}
{/if}

{/if}