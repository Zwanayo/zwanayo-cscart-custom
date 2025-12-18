{** Detecting grid item height **}

{* Grid padding *}
{assign var="pd" value=35}

{if $settings.abt__device == "mobile"}{assign var="mc" value=1.09}{else}{assign var="mc" value=1}{/if}

{* Thumb *}
{if !empty($block.properties.abt__ut2_thumbnail_height)}
    {assign var="t1" value=$block.properties.abt__ut2_thumbnail_height}
{else}
    {assign var="t1" value=$settings.abt__ut2.product_list.$tmpl.image_height[$settings.abt__device]|default:$settings.Thumbnails.product_lists_thumbnail_height|intval}
{/if}

{* Show rating *}
{if $show_rating && $settings.abt__ut2.product_list.show_rating_num == "YesNo::YES"|enum}
	{assign var="t2" value=($mc * 23)}
{elseif $show_rating && $settings.abt__ut2.product_list.show_rating_num == "YesNo::NO"|enum}
    {assign var="t2" value=($mc * 20)}
{/if}

{* Show sku *}
{if $settings.abt__ut2.product_list.$tmpl.show_sku[$settings.abt__device] == "YesNo::YES"|enum}
	{assign var="t3" value=($mc * 18)}
{/if}

{* Show name *}
{assign var="nl" value=($settings.abt__ut2.product_list.$tmpl.lines_number_in_name_product[$settings.abt__device] * 19.5)}
{assign var="t4" value=($mc * $nl)}

{* Show amount *}
{if $settings.abt__ut2.product_list.$tmpl.show_amount[$settings.abt__device] == "YesNo::YES"|enum}
	{assign var="t5" value=($mc * 25)}
{/if}

{* Show price *}
{if $settings.abt__ut2.product_list.price_display_format == 'col' || $settings.abt__ut2.product_list.price_display_format == 'mix' || $settings.abt__ut2.product_list.price_position_top == "YesNo::YES"|enum}
    {assign var="t6" value=($mc * 51)}
{else}
    {assign var="t6" value=($mc * 36)}
{/if}

{* Show buttons *}
{if $show_add_to_cart && $settings.abt__ut2.product_list.$tmpl.show_buttons_on_hover[$settings.abt__device] == "YesNo::NO"|enum}
    {if $button_type_add_to_cart == 'icon_and_text' || $button_type_add_to_cart == 'text'}
        {assign var="t7" value=46}
    {else}
        {assign var="t7" value=0}
    {/if}
{elseif !empty($block.properties.hide_add_to_cart_button) && $block.properties.hide_add_to_cart_button == "YesNo::NO"|enum}
    {assign var="t7" value=46}
{/if}

{* Show your save *}
{if $settings.abt__ut2.product_list.$tmpl.show_you_save[$settings.abt__device] == "YesNo::YES"|enum}
	{assign var="t8" value=($mc * 11)}
{/if}

{* Show tax *}
{if $settings.Appearance.show_prices_taxed_clean == "YesNo::YES"|enum}
	{assign var="t9" value=($mc * 11)}
{/if}

{hook name="products:ut2__grid_list_settings"}{/hook}

{if empty($block.properties) || $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::YES"|enum}
    {* Show features *}
    {if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::NO"|enum}
        {if $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'features'
         || $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'features_and_description'
         || $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'features_and_variations'}
    	    {assign var="t10" value=$settings.abt__ut2.product_list.max_features[$settings.abt__device]*($mc * 19) + 5}
    	{/if}
    {/if}

    {* Show s.description *}
    {if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::NO"|enum}
        {if $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'description'
         || $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'features_and_description'}
        	{assign var="t11" value=($mc * 66)}
        {/if}
    {/if}

    {* Show variations *}
    {if $settings.abt__ut2.product_list.$tmpl.show_content_on_hover[$settings.abt__device] == "YesNo::NO"|enum}
        {if $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'variations'
         || $settings.abt__ut2.product_list.$tmpl.grid_item_bottom_content[$settings.abt__device] == 'features_and_variations'}
        	{assign var="t12" value=($mc * 46)}
        {/if}
    {/if}
{/if}

{* ut2-gl__price height size*}
{$pth = $t6|default:0 + $t8|default:0 + $t9|default:0}
{capture name="abt__ut2_pr_block_height"}{$t6|default:0 + $t8|default:0 + $t9|default:0}{/capture}

{* ut2-gl__content height size *}
{if empty($block.properties)}
    {if $settings.abt__ut2.product_list.price_position_top == "YesNo::YES"|enum}
        {$thc = $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0 + $t7|default:0 + $t10|default:0 + $t11|default:0 + $t12|default:0}
    {elseif $button_type_add_to_cart == 'icon' || $button_type_add_to_cart == 'icon_button'}
        {$thc = $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0 + $pth + $t10|default:0 + $t11|default:0 + $t12|default:0}
    {else}
        {$thc = $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0 + $pth + $t7|default:0 + $t10|default:0 + $t11|default:0 + $t12|default:0}
    {/if}
{else}
    {if $settings.abt__ut2.product_list.price_position_top == "YesNo::YES"|enum && $button_type_add_to_cart == 'icon_and_text' || $settings.abt__ut2.product_list.price_position_top == "YesNo::YES"|enum && $button_type_add_to_cart == 'text'}
        {$thc = $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0 + $t7|default:0}
    {elseif $settings.abt__ut2.product_list.price_position_top == "YesNo::YES"|enum && $button_type_add_to_cart == 'icon' || $settings.abt__ut2.product_list.price_position_top == "YesNo::YES"|enum && $button_type_add_to_cart == 'icon_button'}
        {$thc = $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0}
    {else}
        {$thc = $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0 + $t7|default:0 + $pth}
    {/if}
{/if}
{capture name="abt__ut2_gl_content_height"}{$thc + 1}{/capture}

{* ut2-gl__item height size *}
{$th = $t1|default:0 + $t2|default:0 + $t3|default:0 + $t4|default:0 + $t5|default:0 + $t6|default:0 + $t7|default:0 + $t8|default:0 + $t9|default:0 + $t10|default:0 + $t11|default:0 + $t12|default:0}
{capture name="abt__ut2_gl_item_height"}{$th}{/capture}

{** end **}
