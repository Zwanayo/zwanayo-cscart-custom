{assign var="_title" value=$category_data.category|default:__("vendor_products")}

{assign var="products_search" value="Y"}

{hook name="companies:products"}

<div class="ut2-cat-container{if $settings.abt__ut2.category.description_position == 'bottom'} reverse{/if}">
    {if $settings.abt__ut2.category.description_position != 'none'}
    {hook name="categories:view_description"}
    {if ($category_data.description || $runtime.customization_mode.live_editor)}
        <div class="ty-wysiwyg-content ty-mb-s" {live_edit name="category:description:{$category_data.category_id}"}>{$category_data.description nofilter}</div>
    {/if}
    {/hook}
    {/if}

    <div class="cat-view-grid" id="category_products_{$block.block_id}">

    {math equation="ceil(n/c)" assign="rows" n=$subcategories|count c=$columns|default:"2"}
    {split data=$subcategories size=$rows assign="splitted_subcategories"}
    
    {if $subcategories && $settings.abt__ut2.category.show_subcategories == "YesNo::YES"|enum}
        <ul class="subcategories clearfix">
        {foreach from=$splitted_subcategories item="ssubcateg"}
            {foreach from=$ssubcateg item=category name="ssubcateg"}
                {if $category}
                    <li class="ty-subcategories__item {if $category.main_pair}cat-img{/if}">
                        <a href="{"companies.products?category_id=`$category.category_id`&company_id=$company_id"|fn_url}">
                            {if $category.main_pair}
                                {include file="common/image.tpl"
                                    show_detailed_link=false
                                    images=$category.main_pair
                                    no_ids=true
                                    lazy_load=$settings.abt__ut2.general.lazy_load == "YesNo::YES"|enum
                                    image_id="category_image"
                                    image_width=$settings.Thumbnails.category_lists_thumbnail_width
                                    image_height=$settings.Thumbnails.category_lists_thumbnail_height
                                    class="ty-subcategories-img"
                                }
                            {/if}
                            <span {live_edit name="category:category:{$category.category_id}"}>{$category.category}</span>
                        </a>
                    </li>
                {/if}
            {/foreach}
        {/foreach}
        </ul>
    {/if}

    {if $products}
        {assign var="title_extra" value="{__("products_found")}: `$search.total_items`"}
        {assign var="layouts" value=""|fn_get_products_views:false:0}
        {if $category_data.product_columns}
            {assign var="product_columns" value=$category_data.product_columns}
        {else}
            {assign var="product_columns" value=$settings.Appearance.columns_in_products_list}
        {/if}

        {if $layouts.$selected_layout.template}
            {include file="`$layouts.$selected_layout.template`" columns=$product_columns show_qty=true}
        {/if}
    {elseif !$subcategories}
        {hook name="products:search_results_no_matching_found"}
            <p class="ty-no-items">{__("text_no_matching_products_found")}</p>
        {/hook}
    {/if}
    <!--category_products_{$block.block_id}--></div>
</div>

{/hook}

{hook name="products:search_results_mainbox_title"}
{capture name="mainbox_title"}<span class="ty-mainbox-title__left">{$_title}</span><span class="ty-mainbox-title__right" id="products_search_total_found_{$block.block_id}">{$title_extra nofilter}<!--products_search_total_found_{$block.block_id}--></span>{/capture}
{/hook}