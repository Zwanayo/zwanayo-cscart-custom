{strip}
    {$menu_type = "Tygh\Addons\Abt_unitheme2\FMRepository::ITEM_TYPE_MENU"|constant}
    {$block_type = "Tygh\Addons\Abt_unitheme2\FMRepository::ITEM_TYPE_BLOCK"|constant}
    {$delimiter_type = "Tygh\Addons\Abt_unitheme2\FMRepository::ITEM_TYPE_DELIMITER"|constant}

    {**
        ut2-sw-w -- ut2-swipe-wrapper
        ut2-sw   -- ut2-swipe-parent
        ut2-sp-n -- ut2-swiper-on
        ut2-sp-f -- ut2-swiper-off
        ut2-st   -- ut2-swipe-title
        ac       -- active
        ut2-sw-b -- ut2-swipe-bolster
    **}
    {if $items}
        <div id="sw_dropdown_{$block.block_id}" class="ut2-sp-n cm-combination cm-abt--ut2-toggle-scroll {if $block.properties.open_on_sticky_panel_button === "Y"} cm-external-triggered{/if}{if $block.properties.abt__ut2_show_title == 'Y'} ut2-sw-title{/if}"><i class="ut2-icon-outline-menu"></i>
            {if $block.properties.abt__ut2_show_title == 'Y' && $settings.abt__device != 'mobile'}<span>{$title nofilter}</span>{/if}
        </div>
        <div id="dropdown_{$block.block_id}" class="ut2-sw-b hidden cm-external-click" data-ca-external-click-id="sw_dropdown_{$block.block_id}"></div>
        <div class="ut2-sw-w{if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} swipe-right{elseif $content_alignment == "LEFT"} swipe-left{/if}" style="display: none;">

            {if $block.properties.abt__ut2_show_title == 'Y'}
                <div class="ut2-st">
                    {if $smarty.capture.title|trim}
                        {$smarty.capture.title nofilter}
                    {/if}
                    <div class="ut2-sp-f cm-combination cm-abt--ut2-toggle-scroll" id="off_dropdown_{$block.block_id}" style="display:none;"><i class="ut2-icon-baseline-close"></i></div>
                </div>
            {/if}

            <div class="ut2-scroll">
                <div class="ut2-sw">
                    {if $block.properties.abt__ut2_show_title == 'N'}
                        <div class="ut2-sp-f cm-combination cm-abt--ut2-toggle-scroll" id="off_dropdown_{$block.block_id}" style="display:none;"><i class="ut2-icon-baseline-close"></i></div>
                    {/if}
                    {foreach $items as $m_item}
                        {if $m_item.type == $menu_type}
                            {if $settings.abt__device == "desktop"}
                                {$device = $settings.abt__device}
                            {else}
                                {$device = "mobile"}
                            {/if}

                        {include file="addons/abt__unitheme2/blocks/abt__ut2_fly_menu/{$device}.tpl"
                            user_class=$m_item.user_class
                            menu_name=$m_item.menu_name
                            items=$m_item.menu_items
                            state=$m_item.state
                            show_title=$m_item.show_title
                        }
                        {elseif $m_item.type == $block_type}
                            <div class="ut2-rb{if $m_item.content.user_class} {$m_item.content.user_class}{/if}">{render_block block_id=$m_item.block_id}</div>   
                        {elseif $m_item.type == $delimiter_type}
                            <div class="ut2-fm-delimiter{if $m_item.content.user_class} {$m_item.content.user_class}{/if}"></div>
                        {/if}
                    {/foreach}
                </div>
            </div>
        </div>
    {/if}
{/strip}