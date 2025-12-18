{ab__hide_content bot_type="ALL"}
{if !$config.tweaks.disable_dhtml}
    {$ajax_class = "cm-ajax cm-ajax-full-render"}
{/if}

{if !$hide_compare_list_button}
    {$config.current_url = $config.current_url|fn_query_remove:"layout"}
    {$compare_button_type  = $compare_button_type|default:  "icon"}
    {$but_meta             = $compare_but_meta|default:     "ut2-add-to-compare $ajax_class"}
    {$but_title            = $compare_but_title|default:    __("add_to_comparison_list")}
    {$but_target_id        = $compare_but_target_id|default:"comparison_list,account_info*"}
	{$but_rel              = $compare_but_rel|default:      "nofollow"}
    {$c_url                = $redirect_url|default:$config.current_url}
    {$but_label            = $compare_but_label|default:    $but_label}
    
    {if $selected_layout}
        {$c_url = "`$c_url`&layout=`$selected_layout`"}
    {/if}

    {$but_href             = $compare_but_href|default:     "product_features.add_product?product_id=$product_id&redirect_url={$c_url|escape:url}"}

    <a class="
	{if $but_meta}{$but_meta}{/if}
    {if $details_page} label{/if}
    {if !$runtime.customization_mode.live_editor && $settings.abt__device == "desktop"} cm-tooltip{/if}"
    {if $but_title} title="{$but_title}"{/if}
    {if $but_target_id} data-ca-target-id="{$but_target_id},abt__ut2_compared_products"{/if}
    {if $but_rel} rel="{$but_rel}"{/if}
    {if $but_href} href="{$but_href|fn_url}"{/if}>

    {if $compare_button_type == "icon"}<i class="ut2-icon-addchart"></i>{/if}
    {if $details_page || $but_label}{__("compare")}{/if}
    </a>
{/if}
{/ab__hide_content}