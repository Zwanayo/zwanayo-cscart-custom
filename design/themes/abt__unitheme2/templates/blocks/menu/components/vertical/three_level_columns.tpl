{if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}
    {$cols_tree_level = 1}
{else}
    {$cols_tree_level = $settings_cols}
{/if}
{$items_in_big_cols = ($subitems_count / $cols_tree_level)|ceil}
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
                {if !empty($item2.$childs)}
                    <span class="ty-menu__item-toggle visible-phone cm-responsive-menu-toggle">
                        <i class="ut2-icon-outline-expand_more"></i>
                    </span>
                    <div class="ty-menu__submenu {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level {/if}{if $item2.abt__ut2_mwi__text && $item2.abt__ut2_mwi__text_position !== "bottom" && $settings.abt__device === "desktop"}tree-level-img {/if}" {if $item1.abt__ut2_mwi__dropdown =="YesNo::YES"|enum && $settings.abt__device !== "mobile"}style="min-height: var(--ut2-vertical-menu-block-height)"{/if}>
                        {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}
                            {$max_amount3=2*$block.properties.elements_per_column_third_level_view}
                            {$item2.$childs=array_slice($item2.$childs, 0, $max_amount3, true)}

                            {foreach from=array_chunk($item2.$childs, ceil($item2.$childs|count / $cols_tree_level), true) item="item2_childs"}
                                {if $item2_childs}
                                    <div class="ty-menu__submenu-list {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level-col {if $item2_childs|count > 19}double-cols {/if}{else}{if $item2_childs|count > $Viewlimit}hiddenCol {/if}{/if}cm-responsive-menu-submenu" data-cols-count="{$settings_cols}" style="{if $item2_childs|count > $Viewlimit && $item1.abt__ut2_mwi__dropdown ==="YesNo::NO"|enum}--menu-items:{$Viewlimit};{/if}{if $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum && $settings.abt__device !== "mobile"}width:{$col_width}%;{if $settings_cols > 2}max-width:{$col_width}%{/if}{/if}">
                                    {hook name="blocks:topmenu_dropdown_3levels_col_elements"}
                                    {if $item2.$name && $item2.href && $settings.ab__device === "mobile"}
                                        <div class="ty-menu__submenu-item">
                                            <a href="{$item2.href|fn_url}" {if $item2_url && $item1.new_window === "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__submenu-link{if $item2.class} {$item2.class}{/if}" title="">
                                                {if $block.properties.abt_menu_icon_items === "YesNo::YES"|enum && $item2.abt__ut2_mwi__icon && $settings.abt__device === "desktop"}
                                                    {include file="common/image.tpl" images=$item2.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true}
                                                {/if}
                                                {if $item2_url}<span class="link-parent">{__('all')} {$item2.item nofilter}</span>{/if}
                                            </a>
                                        </div>
                                    {/if}
                                    {foreach from=$item2_childs item="item3" name="item3"}
                                        {assign var="item3_url" value=$item3|fn_form_dropdown_object_link:$block.type}
                                        <div class="ty-menu__submenu-item">
                                            <a href="{$item3_url|default:"javascript:void(0)"}"{if $item3_url && $item1.new_window === "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__submenu-link{if $item3.class} {$item3.class}{/if}" title="{$item3.$name nofilter}">
                                                {if $block.properties.abt_menu_icon_items === "YesNo::YES"|enum && $item3.abt__ut2_mwi__icon && $settings.abt__device === "desktop"}
                                                    {include file="common/image.tpl" images=$item3.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true}
                                                {/if}
                                                <span class="v-center">
                                                    {strip}
                                                        {$item3.$name nofilter}
                                                        {if $item3.abt__ut2_mwi__status === "YesNo::YES"|enum && $item3.abt__ut2_mwi__label}
                                                            <span class="m-label" style="color: {$item3.abt__ut2_mwi__label_color}; background-color: {$item3.abt__ut2_mwi__label_background}; {if $item3.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$item3.abt__ut2_mwi__label_color}{else}border: 1px solid {$item3.abt__ut2_mwi__label_background};{/if}">{$item3.abt__ut2_mwi__label}</span>
                                                        {/if}
                                                    {/strip}
                                                </span>
                                            </a>
                                        </div>
                                    {/foreach}
                                    {/hook}
                                    </div>
                                {/if}
                            {/foreach}
                        {else}
                            {if $item2.$childs}<div class="ty-menu__submenu-list {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level-col {if $item2.$childs|count > 19}double-cols {/if}{else}{if $item2.$childs|count > $Viewlimit}hiddenCol {/if}{/if}cm-responsive-menu-submenu" data-cols-count="{$settings_cols}" {if $item2.$childs|count > $Viewlimit && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum}style="--menu-items:{$Viewlimit};"{/if}>
                                {hook name="blocks:topmenu_dropdown_3levels_col_elements"}
                                {if $item2.$name && $item2.href && $settings.ab__device === "mobile"}
                                    <div class="ty-menu__submenu-item">
                                        <a href="{$item2.href|fn_url}" {if $item2_url && $item1.new_window === "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__submenu-link{if $item2.class} {$item2.class}{/if}" title="">
                                            {if $block.properties.abt_menu_icon_items === "YesNo::YES"|enum && $item2.abt__ut2_mwi__icon && $settings.abt__device === "desktop"}
                                                {include file="common/image.tpl" images=$item2.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true}
                                            {/if}
                                            {if $item2_url}<span class="link-parent">{__('all')} {$item2.$name nofilter}</span>{/if}
                                        </a>
                                    </div>
                                {/if}
                                {foreach from=$item2.$childs item="item3" name="item3"}
                                    {assign var="item3_url" value=$item3|fn_form_dropdown_object_link:$block.type}
                                    <div class="ty-menu__submenu-item">
                                        <a href="{$item3_url|default:"javascript:void(0)"}"{if $item3_url && $item1.new_window === "YesNo::YES"|enum} target="_blank"{/if} class="ty-menu__submenu-link{if $item3.class} {$item3.class}{/if}" title="{$item3.$name nofilter}">
                                            {if $block.properties.abt_menu_icon_items === "YesNo::YES"|enum && $item3.abt__ut2_mwi__icon && $settings.abt__device === "desktop"}
                                                {include file="common/image.tpl" images=$item3.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true}
                                            {/if}
                                            <span class="v-center">
                                                {strip}
                                                    {$item3.$name nofilter}
                                                    {if $item3.abt__ut2_mwi__status === "YesNo::YES"|enum && $item3.abt__ut2_mwi__label}
                                                        <span class="m-label" style="color: {$item3.abt__ut2_mwi__label_color}; background-color: {$item3.abt__ut2_mwi__label_background}; {if $item3.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$item3.abt__ut2_mwi__label_color}{else}border: 1px solid {$item3.abt__ut2_mwi__label_background};{/if}">{$item3.abt__ut2_mwi__label}</span>
                                                    {/if}
                                                {/strip}
                                            </span>
                                        </a>
                                    </div>
                                {/foreach}
                                {/hook}
                                </div>
                            {/if}
                        {/if}
                        {if $block.properties.abt__menu_compact_view !== "YesNo::YES"|enum && $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum && $item2.abt__ut2_mwi__text && $settings.abt__device !== "mobile"}
                            <div class="ut2-mwi-html {$item2.abt__ut2_mwi__text_position} hidden-phone" style="min-height: var(--ut2-vertical-menu-block-height)">{$item2.abt__ut2_mwi__text nofilter}</div>
                        {/if}
                        {if $item2.$childs|count > $Viewlimit && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum}
                            <a href="{if $block.properties.abt__ut2_view_more_btn_behavior|default:'view_items' === 'view_items'}javascript:void(0);" onMouseOver="$(this).prev().addClass('view');$(this).addClass('hidden');{else}{$item2_url|default:"javascript:void(0)"}" rel="nofollow{/if}" class="ut2-more" title=""><span>{__("more")}</span></a>
                        {/if}
                        {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum && $item2_url && $item2.show_more && $settings.abt__device === "desktop"}
                            <div class="ty-menu__submenu-alt-link"><a class="ty-btn-text" href="{$item2_url}" title="">{__("text_topmenu_more", ["[item]" => $item2.$name])}</a></div>
                        {/if}
                    </div>
                {/if}
            </div>
        {/foreach}
    </div>
{/foreach}

{script src="js/addons/abt__unitheme2/abt__ut2_column_calculator.js"}