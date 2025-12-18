{if !$grid.parent_id}
    {if $grid.alpha}<div class="container-fluid-row{if $grid.abt__ut2_extended == "E"} container-fluid-row-full-width {$grid.user_class}{elseif $grid.abt__ut2_extended == "F"} container-fluid-row-no-limit {$grid.user_class}{/if}">{/if}
{/if}

{if $grid.alpha}<div class="{if $layout_data.layout_width != "fixed"}row-fluid {else}row{/if}">{/if}
    {$width = $fluid_width|default:$grid.width}
    <div class="span{$width}{if $grid.offset} offset{$grid.offset}{/if}{if !in_array($grid.abt__ut2_extended, ['E','F'])} {$grid.user_class}{/if} {$grid.abt__ut2_padding}" >
        {if in_array($grid.abt__ut2_show_blocks_in_tabs, ["Addons\\Abt_unitheme2\\BlockInTabsTypes::TABS_WITHOUT_LAZY_LOAD"|enum, "Addons\\Abt_unitheme2\\BlockInTabsTypes::TABS_WITH_LAZY_LOAD"|enum])}
            {include file="common/tabsbox.tpl" content=$content}
        {elseif $grid.wrapper}
            {include file="views/block_manager/extract_nested_forms.tpl"
            wrapper=$grid.wrapper
            content=$content
            }

            {include file=$grid.wrapper content=$content}
        {else}
            {$content nofilter}
        {/if}
    </div>
{if $grid.omega}</div>{/if}

{if !$grid.parent_id}
    {if $grid.omega}</div>{/if}
{/if}
