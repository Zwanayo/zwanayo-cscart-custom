{$items_in_big_cols = ($subitems_count / $settings_cols)|ceil}
{$big_cols_count = $subitems_count % $settings_cols}

{$splited_elements = fn_abt__ut2_split_elements_for_menu($item1.$childs, $settings_cols, $items_in_big_cols, $big_cols_count)}
{$second_level_counter = 0}

{foreach from=$splited_elements item="row"}
    {$Viewlimit=$block.properties.no_hidden_elements_second_level_view|default:5}

    <div class="ty-menu__submenu-col" {if $settings.abt__device !== "mobile"}style="{if $item1.abt__ut2_mwi__dropdown == "YesNo::NO"|enum}width:{$col_width}%;{else}min-height: var(--ut2-vertical-menu-block-height);{/if}"{/if}>
        {foreach from=$row item="item2" name="item2"}
            <div class="second-lvl" data-elem-index="{$second_level_counter}">
                {$second_level_counter = $second_level_counter + 1}

                {assign var="item2_url" value=$item2|fn_form_dropdown_object_link:$block.type}
                <div class="ty-menu__submenu-item-header{if $item2.abt__ut2_mwi__icon && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum} ut2-mwi-icon-wrap{/if}{if empty($item2.$childs)} no-items{/if}">
                    <a {if $settings.abt__device !== "mobile" || !$item2.childs}href="{$item2_url|default:"javascript:void(0)"}"{else}href="javascript:void(0)"{/if}{if $item2_url && $item1.new_window === "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__submenu-link {if $item2.class}{$item2.class}{/if}">
                        {if $item2.abt__ut2_mwi__icon && $block.properties.abt_menu_icon_items === "YesNo::YES"|enum && $settings.abt__device !== "mobile"}
                            {include file="common/image.tpl" images=$item2.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true}
                        {/if}
                        <span class="v-center">
                            {strip}
                                {$item2.$name nofilter}
                                {if $item2.abt__ut2_mwi__status === "YesNo::YES"|enum && $item2.abt__ut2_mwi__label}
                                    <span class="m-label" style="color: {$item2.abt__ut2_mwi__label_color};background-color: {$item2.abt__ut2_mwi__label_background}; {if $item2.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$item2.abt__ut2_mwi__label_color}{else}border: 1px solid {$item2.abt__ut2_mwi__label_background};{/if}">{$item2.abt__ut2_mwi__label}</span>
                                {/if}
                            {/strip}
                        </span>
                    </a>
                    {if $item2.$childs && $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}<i class="icon-right-dir ut2-icon-outline-arrow_forward"></i>{/if}
                </div>
            </div>
        {/foreach}
    </div>
{/foreach}

{script src="js/addons/abt__unitheme2/abt__ut2_column_calculator.js"}