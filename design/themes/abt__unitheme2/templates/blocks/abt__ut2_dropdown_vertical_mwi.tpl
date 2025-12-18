{hook name="blocks:topmenu_dropdown"}

<style>
    :root {
        --ut2-vertical-menu-block-height: {$block.properties.abt__ut2_menu_min_height|default:430}px;
    }
</style>

{strip}
{if $items}
    {if $block.properties.elements_per_column_third_level_view < 1}
        {$block.properties.elements_per_column_third_level_view = 1}
    {/if}
    {$block.properties.abt_menu_ajax_load = "YesNo::NO"|enum}
    {if $settings.abt__device === "desktop"}
        <div class="ut2-menu__backdrop cm-external-click" style="display: none" data-ca-external-click-id="sw_dropdown_{$block.snapping_id}" ></div>
    {/if}

    <div class="ut2-menu__header-mobile" style="display: none">{$block.name}</div>
    <div class="ut2-menu-vetrtical">
        <div class="ut2-menu__inbox{if $block.properties.open_on_sticky_panel_button === "Y"} cm-external-triggered{/if}{if $block.properties.abt__menu_compact_view === "YesNo::YES"|enum} compact{/if}">
            <ul class="ty-menu__items cm-responsive-menu">
                {hook name="blocks:topmenu_dropdown_top_menu"}

                {$settings_cols = min(6, $block.properties.abt__ut2_columns_count|default:4)}
                {foreach from=$items item="item1" name="item1"}
                    {assign var="item1_url" value=$item1|fn_form_dropdown_object_link:$block.type}
                    {if $settings.abt__device === "desktop"}
                        {assign var="url_mobile" value=$item1_url}
                    {/if}
                    {assign var="unique_elm_id" value="topmenu_{$block.block_id}_{$block.snapping_id}_{substr(crc32(serialize($item1)), 0, 10)}"}
                    {assign var="subitems_count" value=$item1.$childs|count}

                    <li class="ty-menu__item{if !$item1.$childs} ty-menu__item-nodrop{/if} cm-menu-item-responsive first-lvl{if $smarty.foreach.item1.last} last{/if}{if $item1.class} {$item1.class}{/if}" data-subitems-count="{$item1.$childs|count}" data-settings-cols="{$settings_cols}">
                        {if $item1.$childs}
                            <span class="ty-menu__item-toggle ty-menu__menu-btn visible-phone cm-responsive-menu-toggle">
                                <i class="ut2-icon-outline-expand_more"></i>
                            </span>
                        {/if}

                        <a href="{if $item1.$childs|count < 1}{$item1_url|default:"javascript:void(0)"}{else}{$url_mobile|default:"javascript:void(0)"}{/if}"{if $item1_url && $item1.new_window == "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__item-link a-first-lvl">
                            <span class="menu-lvl-ctn {if $item1.abt__ut2_mwi__status == 'Y' && $item1.abt__ut2_mwi__desc|strip_tags|trim}exp-wrap{/if}">
                                {if $item1.abt__ut2_mwi__status == 'Y' && $item1.abt__ut2_mwi__icon}
                                    {include file="common/image.tpl" images=$item1.abt__ut2_mwi__icon class="ut2-mwi-icon" width=$image_data.width height=$image_data.height no_ids=true lazy_load=false}
                                {/if}
                                <span>
                                    <span class="v-center">
                                        {strip}
                                        {$item1.$name nofilter}
                                        {if $item1.abt__ut2_mwi__status == 'Y' && $item1.abt__ut2_mwi__label}
                                            <span class="m-label"
                                                  style="color: {$item1.abt__ut2_mwi__label_color}; background-color: {$item1.abt__ut2_mwi__label_background}; {if $item1.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$item1.abt__ut2_mwi__label_color}{else}border: 1px solid {$item1.abt__ut2_mwi__label_background};{/if}">{$item1.abt__ut2_mwi__label}</span>
                                        {/if}
                                        {/strip}
                                    </span>
                                    {if $item1.abt__ut2_mwi__desc|strip_tags|trim}
                                        <span class="exp-mwi-text">{$item1.abt__ut2_mwi__desc|strip_tags|trim}</span>
                                    {/if}
                                </span>
                                {if $item1.$childs}<i class="icon-right-dir ut2-icon-outline-arrow_forward"></i>{/if}
                            </span>
                        </a>
                        {if $item1.$childs}
                            {capture name="children"}
                                {$col_width = 100 / $settings_cols}
                                {include file="blocks/menu/components/vertical/`$block.properties.abt__ut2_filling_type|default:'column_filling'`.tpl"}
                            {/capture}

                            {if $block.properties.abt_menu_ajax_load != 'Y'}
                                <div class="ty-menu__submenu" id="{$unique_elm_id}">
                                    {if $item1_url}<a href="{$item1_url}" class="ty-menu__item-link link-parent" style="display: none" target="_self">{__('all')} - {$item1.$name} <span class="ty-btn ty-btn__primary">{__('view')}</span></a>{/if}
                                    {$smarty.capture.children nofilter}
                                </div>
                            {else}
                                <div class="abt__ut2_am ty-menu__submenu" id="{$unique_elm_id}_{$smarty.const.DESCR_SL}_{$settings.abt__device}"></div>
                                {$smarty.capture.children|fn_abt__ut2_ajax_menu_save:$unique_elm_id}
                            {/if}
                        {/if}
                    </li>
                {/foreach}
                {/hook}
            </ul>
        </div>
    </div>
{/if}
{if $block.properties.abt_menu_ajax_load == "YesNo::YES"|enum && !$smarty.capture.ut2_mwi_ajax_upload_included}
    {capture name="ut2_mwi_ajax_upload_included"}1{/capture}

    {include file="blocks/menu/components/ajax_upload.tpl"}

    is-hover-menu
{/if}
{/strip}
{/hook}