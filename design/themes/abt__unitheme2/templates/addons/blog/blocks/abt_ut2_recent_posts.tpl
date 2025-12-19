{** block-description:tmpl_abt__ut2__recent_posts_advanced **}

{assign var="parent_id" value=$block.content.items.parent_page_id}

{if $items}
    {assign var="obj_prefix" value="`$block.block_id`000"}

    <div class="ut2-blog__recent-posts">
        {foreach from=$items item="page" name="fp"}
            <div class="ut2-blog__recent-posts--item {if $smarty.foreach.fp.first}first{/if}">
                <a href="{"pages.view?page_id=`$page.page_id`"|fn_url}" >

                        {* set Background-vars *}
                        {if $page.main_pair}

                            {* First image bigger *}
                            {if $smarty.foreach.fp.first}
                                {$image_data=$page.main_pair|fn_image_to_display:825:549}
                            {else}
                                {$image_data=$page.main_pair|fn_image_to_display:402:268}
                            {/if}

                            {if $settings.abt__ut2.general.lazy_load === "YesNo::YES"|enum}
                                {$data_backgroud_url = $image_data.image_path}
                            {else}
                                {$background_url = $image_data.image_path}
                            {/if}
                        {/if}

                    <div class="ut2-blog__recent-posts--img cover {if !$page.main_pair}no-image{/if}{if $data_backgroud_url} lazyload{/if}"{if $data_backgroud_url} data-background-url="{$image_data.image_path}"{/if}{if $background_url} style="background-image: url('{$background_url}')"{/if}>
                        <div class="ut2-blog__date">{$page.timestamp|date_format:"%d.%m.%Y"}</div>
                    </div>
                    <div class="ut2-blog__recent-posts--title">{$page.page}</div>
                </a>
            </div>
        {/foreach}
    </div>

    {if $settings.abt__ut2.general.blog_page_id|intval > 0}
        <div class="ty-left">
            {include file="buttons/button.tpl" but_href="pages.view?page_id={$settings.abt__ut2.general.blog_page_id|intval}"|fn_url but_text=__("abt__ut2.settings.general.blog_page_id.button") but_meta="ty-btn__primary ut2-blog__button"}
        </div>
    {/if}
{/if}