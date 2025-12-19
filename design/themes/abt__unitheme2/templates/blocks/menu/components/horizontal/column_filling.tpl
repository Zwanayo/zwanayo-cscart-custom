{* Only two levels. horizontal output *}
{if !$item1.$childs|fn_check_second_level_child_array:$childs}
    {hook name="blocks:topmenu_dropdown_2levels_elements"}
    {$has_icon = false}
    {foreach $item1.$childs as $child}
        {if $child.abt__ut2_mwi__icon}
            {$has_icon = true}
        {/if}
    {/foreach}

        <div class="ty-menu__submenu-items cm-responsive-menu-submenu {if $item1.abt__ut2_mwi__text && $item1.abt__ut2_mwi__text_position !== "bottom" && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum}with-pic {/if}" {if $settings.abt__device === "desktop"}style="min-height: var(--ut2-horizontal-menu-block-height)"{/if}>
            <div {if $settings.abt__device === "desktop"}style="min-height: var(--ut2-horizontal-menu-block-height)"{/if}>
                {include file="blocks/menu/components/horizontal/two_level_columns.tpl"}
                {if $item1.show_more && $item1_url && $settings.abt__device !== "mobile"}
                    <div class="ty-menu__submenu-alt-link"><a class="ty-btn-text" href="{$item1_url}" title="">{__("text_topmenu_more", ["[item]" => $item1.$name])}</a></div>
                {/if}
            </div>
            {if $item1.abt__ut2_mwi__status === "YesNo::YES"|enum && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum && $item1.abt__ut2_mwi__text|trim && $settings.abt__device !== "mobile"}
                <div class="ut2-mwi-html {$item1.abt__ut2_mwi__text_position} hidden-phone">{$item1.abt__ut2_mwi__text nofilter}</div>
            {/if}
        </div>
    {/hook}
{else}
    {hook name="blocks:topmenu_dropdown_3levels_cols"}
        <div class="ty-menu__submenu-items cm-responsive-menu-submenu {if $item1.abt__ut2_mwi__dropdown === "YesNo::YES"|enum}tree-level {else}{$dropdown_class} {/if}{if $item1.abt__ut2_mwi__text && $item1.abt__ut2_mwi__text_position !== "bottom" && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum}with-pic {/if}" {if $settings.abt__device === "desktop"}style="min-height: var(--ut2-horizontal-menu-block-height)"{/if}>
            <div {if $settings.abt__device === "desktop"}style="min-height: var(--ut2-horizontal-menu-block-height)"{/if}>
                {include file="blocks/menu/components/horizontal/three_level_columns.tpl"}
                {if $item1.show_more && $item1_url && $settings.abt__device !== "mobile"}
                    <div class="ty-menu__submenu-alt-link"><a class="ty-btn-text" href="{$item1_url}" title="">{__("text_topmenu_more", ["[item]" => $item1.$name])}</a></div>
                {/if}
            </div>
            {if $item1.abt__ut2_mwi__status === "YesNo::YES"|enum && $item1.abt__ut2_mwi__dropdown === "YesNo::NO"|enum && $item1.abt__ut2_mwi__text|trim && $settings.abt__device !== "mobile"}
                <div class="ut2-mwi-html {$item1.abt__ut2_mwi__text_position} hidden-phone">{$item1.abt__ut2_mwi__text nofilter}</div>
            {/if}
        </div>
    {/hook}
{/if}
