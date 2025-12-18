{** block-description:horizontal_filters **}

{script src="js/tygh/product_filters.js"}

{if $block.type == "product_filters"}
    {$ajax_div_ids = "product_filters_*,selected_filters_*,products_search_*,category_products_*,currencies_*,languages_*,product_features_*"}
    {$curl = $config.current_url}
{else}
    {$curl = "products.search"|fn_url}
    {$ajax_div_ids = ""}
{/if}

{$filter_base_url = $curl|fn_query_remove:"result_ids":"full_render":"filter_id":"view_all":"req_range_id":"features_hash":"subcats":"page":"total"}

<div class="ty-horizontal-product-filters cm-product-filters cm-horizontal-filters ut2-filters"
     data-ca-target-id="{$ajax_div_ids}"
     data-ca-base-url="{$filter_base_url|fn_url}"
     data-ca-tooltip-class = "ty-product-filters__tooltip"
     data-ca-tooltip-right-class = "ty-product-filters__tooltip--right"
     data-ca-tooltip-mobile-class = "ty-tooltip--mobile"
     data-ca-tooltip-layout-selector = "[data-ca-tooltip-layout='true']"
     data-ce-tooltip-events-tooltip = "mouseenter"
     id="product_filters_{$block.block_id}">
    <div class="ty-product-filters__wrapper">
        {if $items}

            {foreach from=$items item="filter" name="filters"}

                {$filter_uid = "`$block.block_id`_`$filter.filter_id`"}

                {$reset_url = ""}
                {if $filter.selected_variants || $filter.selected_range}
                    {$reset_url = $filter_base_url}
                    {$fh = $smarty.request.features_hash|fn_delete_filter_from_hash:$filter.filter_id}
                    {if $fh}
                        {$reset_url = $filter_base_url|fn_link_attach:"features_hash=$fh"}
                    {/if}
                {/if}

                <div class="ut2__horizontal-product-filters-dropdown">
                    <div id="sw_elm_filter_{$filter_uid}" class="ty-horizontal-product-filters-dropdown__wrapper {if $settings.abt__device != 'desktop'}cm-abt--ut2-toggle-scroll{/if} cm-combination {if $filter.selected_variants || $filter.selected_range}active{/if}{if $filter.selected_variants|sizeof > 0} selected{/if}">{$filter.filter}{if $filter.selected_variants}<span>{$filter.selected_variants|sizeof}</span>{/if}<i class="ty-horizontal-product-filters-dropdown__icon ty-icon-down-micro"></i></div>
                    {if $settings.abt__device != 'mobile'}
                        <div id="elm_filter_{$filter_uid}" class="cm-popup-box hidden ty-horizontal-product-filters-dropdown__content cm-horizontal-filters-content">
                            <div class="ty-horizontal-product-filters-dropdown__title">
                                <a href="javascript:void(0);" rel="nofollow" class="ut2-btn-close cm-external-click" data-ca-external-click-id="sw_elm_filter_{$filter_uid}"><i class="ut2-icon-baseline-close"></i></span></a>
                            </div>
                            {hook name="blocks:product_filters_variants_element"}
                            {if $filter.slider}
                                {if $filter.feature_type == "ProductFeatures::DATE"|enum}
                                    {include file="blocks/product_filters/components/product_filter_datepicker.tpl" filter_uid=$filter_uid filter=$filter}
                                {else}
                                    {include file="blocks/product_filters/components/product_filter_slider.tpl" filter_uid=$filter_uid filter=$filter}
                                {/if}
                            {else}
                                {include file="blocks/product_filters/components/product_filter_variants.tpl" filter_uid=$filter_uid filter=$filter}
                            {/if}
                            {/hook}
                            {strip}
                                <div class="ty-product-filters__tools">
                                    {if $reset_url}<a class="ty-btn ty-btn__primary outline ty-product-filters__reset-button  cm-ajax cm-ajax-full-render cm-history" href="{$reset_url|fn_url}" data-ca-event="ce.filtersinit" data-ca-target-id="{$ajax_div_ids}"><i class="ty-product-filters__reset-icon ty-icon-cw"></i>{__("reset")}</a>{/if}
                                </div>
                            {/strip}
                        </div>
                    {/if}
                </div>

            {/foreach}

            {if $settings.abt__device == 'mobile'}
                {capture name="products_horizontal_filters_content"}
                    {foreach from=$items item="filter" name="filters"}

                        {$filter_uid = "`$block.block_id`_`$filter.filter_id`"}

                        {$reset_url = ""}
                        {if $filter.selected_variants || $filter.selected_range}
                            {$reset_url = $filter_base_url}
                            {$fh = $smarty.request.features_hash|fn_delete_filter_from_hash:$filter.filter_id}
                            {if $fh}
                                {$reset_url = $filter_base_url|fn_link_attach:"features_hash=$fh"}
                            {/if}
                        {/if}

                        <div id="elm_filter_{$filter_uid}" class="cm-popup-box hidden ty-horizontal-product-filters-dropdown__content cm-horizontal-filters-content">
                            <div class="ty-horizontal-product-filters-dropdown__title">
                                <span>{$filter.filter}</span>
                                <a href="javascript:void(0);" rel="nofollow" class="ut2-btn-close cm-external-click" data-ca-external-click-id="sw_elm_filter_{$filter_uid}"><i class="ut2-icon-baseline-close"></i></span></a>
                            </div>
                            {hook name="blocks:product_filters_variants_element"}
                            {if $filter.slider}
                                {if $filter.feature_type == "ProductFeatures::DATE"|enum}
                                    {include file="blocks/product_filters/components/product_filter_datepicker.tpl" filter_uid=$filter_uid filter=$filter}
                                {else}
                                    {include file="blocks/product_filters/components/product_filter_slider.tpl" filter_uid=$filter_uid filter=$filter}
                                {/if}
                            {else}
                                {include file="blocks/product_filters/components/product_filter_variants.tpl" filter_uid=$filter_uid filter=$filter}
                            {/if}
                            {/hook}
                            {strip}
                                <div class="ty-product-filters__tools">
                                    {if $reset_url}<a class="ty-btn ty-btn__primary outline ty-product-filters__reset-button  cm-ajax cm-ajax-full-render cm-history" href="{$reset_url|fn_url}" data-ca-event="ce.filtersinit" data-ca-target-id="{$ajax_div_ids}"><i class="ty-product-filters__reset-icon ty-icon-cw"></i>{__("reset")}</a>{/if}
                                </div>
                            {/strip}
                        </div>

                    {/foreach}
                {/capture}
            {/if}

        {/if}
    </div>

    {if $settings.abt__device == 'mobile'}
        {$smarty.capture.products_horizontal_filters_content nofilter}
    {/if}

    <!--product_filters_{$block.block_id}--></div>

<div data-ca-tooltip-layout="true" class="hidden">
    <button type="button" data-ca-scroll=".main-content-grid" class="cm-scroll ty-tooltip--link ty-tooltip--filter"><span class="tooltip-arrow"></span></button>
</div>