{strip}{if !empty($ab__lc_landing_categories)}

    
    {capture name="title"}
        <span {live_edit name="category:category:{$category_data.category_id}"}>
            {if $category_data.ab__custom_category_h1|trim}
                {$category_data.ab__custom_category_h1|trim}
            {else}
                {$category_data.category|trim}
            {/if}
        </span>
    {/capture}

    {$show_max_item=$category_data.ab__lc_subsubcategories|default:0}
    {$thumb_width = (empty($settings.abt__ut2.addons.ab__landing_categories.thumbnail_width)) ? $settings.Thumbnails.category_lists_thumbnail_width : $settings.abt__ut2.addons.ab__landing_categories.thumbnail_width }
    {$thumb_height = (empty($settings.abt__ut2.addons.ab__landing_categories.thumbnail_height)) ? $settings.Thumbnails.category_lists_thumbnail_height : $settings.abt__ut2.addons.ab__landing_categories.thumbnail_height }
    {$item_columns = $settings.abt__ut2.addons.ab__landing_categories.columns_count}
    {counter start=0 print=false}

    <div class="row-fluid ab-lc-wrap ab-lc-cols-{$item_columns}">
        {foreach from=$ab__lc_landing_categories item="item1" name="item1"}
            {hook name="ab__landing_categories:category"}{/hook}
            {if $item1.param_id}
                {counter print=false}
                <div class="ab-lc-landing">
                    <div class="head">
                        <a href="{$item1.href|fn_url}">
                            <div class="image">
                                {if $item1.main_pair || $item1.abt__ut2_mwi__icon}

                                    {include file="common/image.tpl"
                                    show_detailed_link=false
                                    images=$item1.main_pair|default:$item1.abt__ut2_mwi__icon
                                    image_width= $thumb_width
                                    image_height=$thumb_height
                                    ab__is_object_name=$item1.item
                                    }
                                {/if}
                            </div>
                            <div class="cat-title">
                                {$item1.item}
                            </div>
                        </a>
                    </div>

                    
                    {if intval($category_data.ab__lc_subsubcategories) > 0 and !empty($item1.subitems)}
                        <ul class="items-level-2">
                            {foreach from=$item1.subitems item="item2" name="item2"}
                                {if $item2.param_id}
                                    
                                    {if $smarty.foreach.item2.iteration > $show_max_item}{break}{/if}
                                    <li><a href="{$item2.href|fn_url}">{$item2.item}</a></li>
                                {/if}
                            {/foreach}
                        </ul>
                        {if count($item1.subitems) > $show_max_item}
                            <ul class="hidden-items-level-2">
                                {foreach from=$item1.subitems item="item2" name="item2"}
                                    {if $item2.param_id}
                                        
                                        {if $smarty.foreach.item2.iteration <= $show_max_item}{continue}{/if}
                                        <li><a href="{$item2.href|fn_url}">{$item2.item}</a></li>
                                    {/if}
                                {/foreach}
                            </ul>
                            <span class="show-hidden-items-level-2">{__("ab__lc.landing_category.show_more")}</span>
                        {/if}
                    {/if}
                </div>
            {/if}
        {/foreach}

        {for $blank=0 to {counter} % $item_columns }
            <div class="ab-lc-landing"></div>
        {/for}
    </div>
    {hook name="categories:view_description"}
    {if $category_data.description || $runtime.customization_mode.live_editor}
        <div class="ab-category-description ty-wysiwyg-content ty-mt-l" {live_edit name="category:description:{$category_data.category_id}"}>{$category_data.description nofilter}</div>
    {/if}
    {/hook}
{/if}{/strip}