{*
    LEGEND
    ut2-fly-menu                    -- ut2-fm
    ut2-light-first-level             -- ut2-lfl
    ut2-second-level-fly-menu-wrap  -- ut2-slw
    ut2-light-second-level            -- ut2-lsl
    ut2-third-level-fly-menu-wrap   -- ut2-tlw
    ut2-fly-menu-back-to-main       -- ut2-fmbtm
    ut2-fly-menu-wrap               -- ut2-fmw
    ut2-menu-toggler                  -- ut2-mt
*}

{$props = $block.properties}
{strip}
    <nav class="ut2-fm{if $m_item.content.user_class} {$m_item.content.user_class}{/if}">
        {*<div class="ut2-fmbtm{if $state == "YesNo::NO"|enum} hidden{/if}">{__('abt__ut2.fly_menu.back_to_main')}</div>*}
        {*{foreach $menu as $menus}*}
            <div class="ut2-fmw{if $user_class} {$user_class}{/if}{if $state == "YesNo::YES"|enum && $show_title == "YesNo::YES"|enum} toggle-it{/if}">
                {if $menu_name && $show_title == "YesNo::YES"|enum}
                    <div class="ut2-mt{if $state == "YesNo::NO"|enum} active{/if}">{$menu_name}<i></i></div>
                {/if}
                {foreach $items as $item}
                    <div class="ut2-lfl {$item.class}{if $item.active} ut2-fm-active-item{/if}">
                        {if $item.abt__ut2_mwi__status == 'Y' && $item.abt__ut2_mwi__icon}
                            {include file="common/image.tpl" images=$item.abt__ut2_mwi__icon class="ut2-lfl-icon" width=$image_data.width height=$image_data.height no_ids=true lazy_load=false}
                        {/if}
                        {if !$item.subitems && $item.href}
                            <a href="{$item.href|fn_url}">
                        {/if}
                            <p>
                                <strong>
                                {$item.item}
                                {if $item.abt__ut2_mwi__label}
                                    <span class="m-label" style="color:{$item.abt__ut2_mwi__label_color};background-color:{$item.abt__ut2_mwi__label_background};{if $item.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$item.abt__ut2_mwi__label_color}{else}border: 1px solid {$item.abt__ut2_mwi__label_background};{/if}">{$item.abt__ut2_mwi__label}</span>
                                {/if}
                                </strong>
                                {if $item.subitems && $item.href}<a href="{$item.href|fn_url}" class="hidden ty-float-right">{__("view_details")}</a>{/if}
                                

                                {if $item.abt__ut2_mwi__desc}<span>{$item.abt__ut2_mwi__desc}</span>{/if}
                            </p>
                        {if !$item.subitems && $item.href}
                            </a>
                        {/if}

                        {if $item.subitems}
                            <i id="fm_{$block.snapping_id}_{$item.param_id}" class="ut2-fm__link-back"><span>{__("abt__ut2.fly_menu.back_to_main")}</span></i>
                            <div class="ut2-slw">
                                {foreach $item.subitems as $subitem}
                                    <div class="ut2-lsl{if $subitem.class} {$subitem.class}{/if}">
                                        
                                        {if $subitem.href && !$subitem.subitems}
                                            <a href="{$subitem.href|fn_url}">
                                        {/if}
                                            <p class="{if $subitem.active}ut2-fm-active-item{/if}">
                                                <strong>
                                                {$subitem.item}
                                                {if $subitem.abt__ut2_mwi__label}
                                                    <span class="m-label" style="color:{$subitem.abt__ut2_mwi__label_color};background:{$subitem.abt__ut2_mwi__label_background};{if $sub_subitem.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$sub_subitem.abt__ut2_mwi__label_color}{else}border: 1px solid {$sub_subitem.abt__ut2_mwi__label_background};{/if}">{$subitem.abt__ut2_mwi__label}</span>
                                                {/if}
                                                </strong>
                                                {if $subitem.href && $subitem.subitems}<a href="{$subitem.href|fn_url}" class="hidden ty-float-right">{__("view_details")}</a>{/if}
                                                
    
                                                {if $subitem.abt__ut2_mwi__desc}<span>{$subitem.abt__ut2_mwi__desc}</span>{/if}
                                            </p>
                                        {if $subitem.href && !$subitem.subitems}
                                            </a>
                                        {/if}

                                        {if $subitem.subitems}
                                            <i id="fm_{$block.snapping_id}_{$item.param_id}_{$subitem@key}" class="ut2-fm__link-back"><span>{__("abt__ut2.fly_menu.back_to")} {$item.item}</span></i>
                                            <div class="ut2-tlw">
                                                {foreach $subitem.subitems as $sub_subitem}
                                                    <p><a href="{$sub_subitem.href|fn_url}" class="{if $sub_subitem.class}{$sub_subitem.class}{/if}{if $sub_subitem.active} ut2-fm-active-item{/if}">
                                                        {$sub_subitem.item}
                                                        {if $sub_subitem.abt__ut2_mwi__label}
                                                            <span class="m-label" style="color:{$sub_subitem.abt__ut2_mwi__label_color};background-color:{$sub_subitem.abt__ut2_mwi__label_background};{if $sub_subitem.abt__ut2_mwi__label_background == '#ffffff'}border: 1px solid {$sub_subitem.abt__ut2_mwi__label_color}{else}border: 1px solid {$sub_subitem.abt__ut2_mwi__label_background};{/if}">{$sub_subitem.abt__ut2_mwi__label}</span>
                                                        {/if}
                                                    </a></p>
                                                {/foreach}
                                            </div>
                                        {/if}
                                    </div>
                                {/foreach}
                            </div>
                        {/if}
                    </div>
                {/foreach}
                
                {if $item.abt__ut2_mwi__status == "YesNo::YES"|enum && $item.abt__ut2_mwi__text|trim && $item.abt__ut2_mwi__dropdown !="YesNo::YES"|enum}
                    <div class="ut2-slw__html-item{if $item.abt__ut2_mwi__dropdown == "YesNo::YES"|enum} bottom{else} {$item.abt__ut2_mwi__text_position}{/if} hidden-phone">{$item.abt__ut2_mwi__text nofilter}</div>
                {/if}
            </div>
        {*{/foreach}*}
    </nav>
{/strip}