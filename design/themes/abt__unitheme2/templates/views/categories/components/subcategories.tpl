{if $subcategories && $settings.abt__ut2.category.show_subcategories == "YesNo::YES"|enum}
    {$rows = ceil(count($subcategories)/$columns|default:2)}
    {split data=$subcategories size=$rows assign="splitted_subcategories"}
    <ul class="subcategories clearfix">
        {hook name="categories:view_subcategories"}
        {foreach $splitted_subcategories as $ssubcateg}
            {foreach $ssubcateg as $category}
                {if $category}
                    <li class="ty-subcategories__item {if $category.main_pair}cat-img{/if}">
                        <a href="{"categories.view?category_id=`$category.category_id`"|fn_url}">
                            {if $category.main_pair}
                                {include file="common/image.tpl"
                                    show_detailed_link=false
                                    images=$category.main_pair
                                    no_ids=true
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
        {/hook}
    </ul>
{/if}