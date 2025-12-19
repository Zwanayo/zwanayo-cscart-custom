{** block-description:blog.recent_posts_scroller **}

{if $items}

{assign var="obj_prefix" value="`$block.block_id`000"}
{$block.block_id = {"`$block.block_id`_{uniqid()}"}}

{if $block.properties.outside_navigation == "Y"}
    <div class="owl-theme ty-owl-controls">
        <div class="owl-controls clickable owl-controls-outside" id="owl_outside_nav_{$block.block_id}">
            <div class="owl-buttons">
                <div id="owl_prev_{$obj_prefix}" class="owl-prev">{include_ext file="common/icon.tpl" class="ty-icon-left-open-thin"}</div>
                <div id="owl_next_{$obj_prefix}" class="owl-next">{include_ext file="common/icon.tpl" class="ty-icon-right-open-thin"}</div>
            </div>
        </div>
    </div>
{/if}

<div class="ut2-blog__recent-posts-scroller">
    <div id="scroll_list_{$block.block_id}" class="owl-carousel ty-scroller-list ty-scroller owl-theme">

    {foreach from=$items item="page"}
        <div class="ut2-blog__recent-posts-scroller--item">

            <div class="ut2-blog__recent-posts-scroller--img">
                <div class="ut2-blog__date">{$page.timestamp|date_format:"%d.%m.%Y"}</div>
                <a href="{"pages.view?page_id=`$page.page_id`"|fn_url}">
                    {if $page.main_pair}
                        {include file="common/image.tpl" obj_id=$page.page_id images=$page.main_pair}
                    {else}
                        <div class="ut2-blog__recent-posts--img cover no-image"></div>
                    {/if}
                </a>
            </div>

            <a href="{"pages.view?page_id=`$page.page_id`"|fn_url}">{$page.page}</a>

        </div>
    {/foreach}

    </div>
</div>

{include file="common/scroller_init_with_quantity.tpl" prev_selector="#owl_prev_`$obj_prefix`" next_selector="#owl_next_`$obj_prefix`"}

{/if}