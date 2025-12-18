{if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}
    {$cols_tree_level = 1}
{else}
    {$cols_tree_level = $settings_cols}
{/if}

{$second_level_counter = 0}

{hook name="blocks:topmenu_dropdown_3levels_cols"}
    <div class="ty-menu__submenu-items cm-responsive-menu-submenu {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level {elseif $item1.abt__ut2_mwi__text && $item1.abt__ut2_mwi__text_position !== "bottom"}with-pic {/if}row-filling {$dropdown_class}" data-cols-count="{$cols_tree_level}" {if $settings.abt__device === "desktop"}style="height: var(--ut2-horizontal-menu-block-height)"{/if}>

        {$Viewlimit=$block.properties.no_hidden_elements_second_level_view|default:5}

        <div {if $settings.abt__device !== "mobile"}style="height: var(--ut2-horizontal-menu-block-height)"{/if}>
            {foreach from=$item1.$childs item="item2" name="item2"}
                <div class="ty-menu__submenu-col" {if $settings.abt__device !== "mobile" && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum}style="width:{$col_width}%;"{/if}>
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

                        {if $item2.$childs}<span class="ty-menu__item-toggle visible-phone cm-responsive-menu-toggle"><i class="ut2-icon-outline-expand_more"></i></span>{/if}

                        {if !empty($item2.$childs)}
                            <div class="ty-menu__submenu {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level {/if}{if $item2.abt__ut2_mwi__text && $item2.abt__ut2_mwi__text_position !== "bottom" && $settings.ab__device === "desktop"} tree-level-img{/if}">
                                {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}
                                    {$max_amount3=2*$block.properties.elements_per_column_third_level_view}
                                    {$item2.$childs=array_slice($item2.$childs, 0, $max_amount3, true)}

                                    {foreach from=array_chunk($item2.$childs, ceil($item2.$childs|count / $cols_tree_level), true) item="item2_childs"}
                                        {if $item2_childs}
                                            <div class="ty-menu__submenu-list {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level-col {if $item2_childs|count > 19}double-cols {/if}{elseif $item2_childs|count > $Viewlimit}hiddenCol {/if}cm-responsive-menu-submenu" data-cols-count="{$settings_cols}" {if $item2_childs|count > $Viewlimit && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum}style="--menu-items:{$Viewlimit}"{/if}>
                                                {hook name="blocks:topmenu_dropdown_3levels_col_elements"}
                                                {if $item2.href && $settings.ab__device !== "desktop"}
                                                    <div class="ty-menu__submenu-item">
                                                        <a href="{$item2.href|fn_url}" {if $item2_url && $item1.new_window === "YesNo::YES"|enum}target="_blank"{/if} class="ty-menu__submenu-link{if $item2.class} {$item2.class}{/if}" title="">
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
                                                        <a href="{$item3_url|default:"javascript:void(0)"}" {if $item3_url && $item1.new_window === "YesNo::YES"|enum}target="_blank"{/if} class="ty-menu__submenu-link {if $item3.class}{$item3.class}{/if}" title="">
                                                    <span class="v-center">
                                                        {strip}
                                                            {$item3.$name nofilter}
                                                            {if $item3.abt__ut2_mwi__status === "YesNo::YES"|enum && $item3.abt__ut2_mwi__label}
                                                                <span class="m-label" style="color: {$item3.abt__ut2_mwi__label_color}; background-color: {$item3.abt__ut2_mwi__label_background};{if $item3.abt__ut2_mwi__label_background === '#ffffff'}border: 1px solid {$item3.abt__ut2_mwi__label_color}{else}border: 1px solid {$item3.abt__ut2_mwi__label_background};{/if}">{$item3.abt__ut2_mwi__label}</span>
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
                                    {if $item2.$childs}
                                        <div class="ty-menu__submenu-list {if $item2.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level-col {if $item2_childs|count > 19}double-cols {/if}{elseif $item2.$childs|count > $Viewlimit} hiddenCol {/if}cm-responsive-menu-submenu" data-cols-count="{$settings_cols}" {if $item2.$childs|count > $Viewlimit}style="--menu-items:{$Viewlimit};"{/if}>
                                            {hook name="blocks:topmenu_dropdown_3levels_col_elements"}
                                            {if $item2.href && $settings.ab__device !== "desktop"}
                                                <div class="ty-menu__submenu-item">
                                                    <a href="{$item2.href|fn_url}" {if $item2_url && $item1.new_window === "YesNo::YES"|enum}target="_blank"{/if} class="ty-menu__submenu-link {if $item2.class}{$item2.class}{/if}" title="">
                                                        {if $block.properties.abt_menu_icon_items === "YesNo::YES"|enum && $item2.abt__ut2_mwi__icon && $settings.abt__device === "desktop"}
                                                            {include file="common/image.tpl" images=$item2.abt__ut2_mwi__icon class="ut2-mwi-icon" no_ids=true}
                                                        {/if}
                                                        {if $item2_url}<span class="link-parent">{__('all')} {$item2.item nofilter}</span>{/if}
                                                    </a>
                                                </div>
                                            {/if}
                                            {foreach from=$item2.$childs item="item3" name="item3"}
                                                {assign var="item3_url" value=$item3|fn_form_dropdown_object_link:$block.type}
                                                <div class="ty-menu__submenu-item{if $item3.class} {$item3.class}{/if}">
                                                    <a href="{$item3_url|default:"javascript:void(0)"}" {if $item3_url && $item1.new_window === "YesNo::YES"|enum}target="_blank"{/if} class="ty-menu__submenu-link" title="">
                                                <span class="v-center">
                                                    {strip}
                                                        {$item3.$name nofilter}
                                                        {if $item3.abt__ut2_mwi__status === "YesNo::YES"|enum && $item3.abt__ut2_mwi__label}
                                                            <span class="m-label" style="color: {$item3.abt__ut2_mwi__label_color};background-color: {$item3.abt__ut2_mwi__label_background};{if $item3.abt__ut2_mwi__label_background === "#ffffff"}border: 1px solid {$item3.abt__ut2_mwi__label_color}{else}border: 1px solid {$item3.abt__ut2_mwi__label_background};{/if}">{$item3.abt__ut2_mwi__label}</span>
                                                        {/if}
                                                    {/strip}
                                                </span>
                                                    </a>
                                                </div>
                                            {/foreach}
                                            {/hook}
                                        </div>
                                    {/if}
                                    {if $item2.$childs|count > $Viewlimit}
                                        <a {if $block.properties.abt__ut2_view_more_btn_behavior|default:"view_items" === "view_items"}href="javascript:void(0);" onMouseOver="$(this).prev().addClass('view');$(this).addClass('hidden');"{else}href="{$item2_url|default:"javascript:void(0)"}" rel="nofollow"{/if} class="ut2-more" title=""><span>{__("more")}</span></a>
                                    {/if}
                                {/if}
                                {if $block.properties.abt__menu_compact_view !== "YesNo::YES"|enum && $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum && $item2.abt__ut2_mwi__text && $settings.abt__device !== "mobile"}
                                    <div class="ut2-mwi-html {$item2.abt__ut2_mwi__text_position} hidden-phone" style="height: var(--ut2-horizontal-menu-block-height)">{$item2.abt__ut2_mwi__text nofilter}</div>
                                {/if}
                            </div>
                        {/if}
                    </div>
                </div>
            {/foreach}
            {if $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum && $item1.abt__ut2_mwi__text && $item1.abt__ut2_mwi__text_position === "bottom" && $settings.abt__device !== "mobile"}
                <div class="ut2-mwi-html {$item1.abt__ut2_mwi__text_position} hidden-phone" style="height: var(--ut2-horizontal-menu-block-height)">{$item1.abt__ut2_mwi__text nofilter}</div>
            {/if}
        </div>

        {if $item1.show_more && $item1_url && $settings.abt__device === "desktop"}
            <div class="ty-menu__submenu-alt-link"><a class="ty-btn-text" href="{$item1_url}" title="">{__("text_topmenu_more", ["[item]" => $item1.$name])}</a></div>
        {/if}
        {if $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum && $item1.abt__ut2_mwi__text && $item1.abt__ut2_mwi__text_position !== "bottom" && $settings.abt__device !== "mobile"}
            <div class="ut2-mwi-html {$item1.abt__ut2_mwi__text_position} hidden-phone" style="height: var(--ut2-horizontal-menu-block-height)">{$item1.abt__ut2_mwi__text nofilter}</div>
        {/if}
    </div>
{/hook}