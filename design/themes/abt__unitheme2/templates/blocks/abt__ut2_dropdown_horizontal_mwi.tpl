{hook name="blocks:topmenu_dropdown"}

<style>
    :root {
        --ut2-horizontal-menu-block-height: {$block.properties.abt__ut2_menu_min_height|default:430}px;
    }
</style>

{strip}
{if $items}
    <div class="ut2-h__menu{if $block.properties.abt_menu_long_names === "YesNo::YES"|enum} tbm-menu{/if}{if $block.properties.abt__menu_add_horizontal_scroll_sections|default:{"YesNo::YES"|enum} === "YesNo::YES"|enum} ut2-m-slider{/if}">
        <div class="ty-menu__wrapper">

			<a href="javascript:void(0);" onclick="$(this).next().toggleClass('view');$(this).toggleClass('open');" class="ty-menu__menu-btn m-button{if $block.properties.open_on_sticky_panel_button === "Y"} cm-external-triggered{/if}"><i class="ut2-icon-outline-menu"></i></a>

            <ul class="ty-menu__items cm-responsive-menu">
                {hook name="blocks:topmenu_dropdown_top_menu"}

                {$settings_cols = min(6, $block.properties.abt__ut2_columns_count|default:4)}
                {foreach from=$items item="item1" name="item1"}
                    {assign var="item1_url" value=$item1|fn_form_dropdown_object_link:$block.type}
                    {assign var="unique_elm_id" value="topmenu_`$block.block_id`_`$block.snapping_id`_`$item1_url|md5`"}
                    {assign var="subitems_count" value=$item1.$childs|count}

                    <li class="ty-menu__item{if !$item1.$childs} ty-menu__item-nodrop{/if} cm-menu-item-responsive{if $item1.class} {$item1.class}{/if}" data-subitems-count="{$item1.$childs|count}" data-settings-cols="{$settings_cols}">

                        {if $item1.$childs}
							<a class="ty-menu__item-toggle visible-phone cm-responsive-menu-toggle">
								<i class="ut2-icon-outline-expand_more"></i>
                            </a>
                        {/if}

                        <a href="{$item1_url|default:"javascript:void(0)"}"{if $item1_url && $item1.new_window === "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__item-link a-first-lvl{if $item1.$childs} childs{/if}">
	                        <span{if $item1.abt__ut2_mwi__status === "YesNo::YES"|enum && $item1.abt__ut2_mwi__icon} class="item-icon"{/if}>
	                        {if $item1.abt__ut2_mwi__status === "YesNo::YES"|enum && $item1.abt__ut2_mwi__icon && $settings.abt__device !== "mobile"}{include file="common/image.tpl" images=$item1.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true lazy_load=false}{/if}
                                <span{if $block.properties.abt_menu_long_names === "YesNo::YES"|enum} style="max-width: {$block.properties.abt_menu_long_names_max_width|intval|default:100}px"{/if}>
                                    {strip}
                                    {$item1.$name nofilter}
                                    {if $item1.abt__ut2_mwi__status === "YesNo::YES"|enum && $item1.abt__ut2_mwi__label}
                                        <span class="m-label" style="color: {$item1.abt__ut2_mwi__label_color}; background-color: {$item1.abt__ut2_mwi__label_background}; {if $item1.abt__ut2_mwi__label_background === "#ffffff"}border: 1px solid {$item2.abt__ut1_mwi__label_color}{else}border: 1px solid {$item1.abt__ut2_mwi__label_background};{/if}">{$item1.abt__ut2_mwi__label}<span class="arrow" style="border-color: {if $item1.abt__ut2_mwi__label_background === "#ffffff"}{$item1.abt__ut2_mwi__label_color}{else}{$item1.abt__ut2_mwi__label_background}{/if} transparent transparent transparent;"></span></span>
                                    {/if}
                                    {/strip}
                                </span>
	                        </span>
	                    </a>

                        {if $item1.$childs}
                            <div class="ty-menu__submenu" id="{$unique_elm_id}">
                                {$col_width = 100 / $settings_cols}
                                {include file="blocks/menu/components/horizontal/`$block.properties.abt__ut2_filling_type|default:'column_filling'`.tpl"}
                            </div>
                        {/if}
                    </li>
                {/foreach}
                {/hook}
            </ul>
        </div>
    </div>
{/if}
{/strip}
{/hook}

<script>
    (function(_, $) {
        _.tr({
            abt__ut2_go_back: '{__("go_back")}',
            abt__ut2_go_next: '{__("next")}',
        });
    })(Tygh, Tygh.$);
</script>
{if $block.properties.abt__menu_add_horizontal_scroll_sections|default:{"YesNo::YES"|enum} === "YesNo::YES"|enum}
    {script src="js/addons/abt__unitheme2/abt__ut2_horizontal_menu_slider.js"}
{/if}