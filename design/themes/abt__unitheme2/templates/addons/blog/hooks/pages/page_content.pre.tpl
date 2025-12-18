{if $page.description && $page.page_type == $smarty.const.PAGE_TYPE_BLOG}
    <div class="ut2-blog__date"><i class="ty-icon-calendar"></i> {$page.timestamp|date_format:"%B %e, %Y"}</div>

    {if $page.main_pair}
        <div class="ut2-blog__img-block">
            {include file="common/image.tpl" obj_id=$page.page_id images=$page.main_pair}
        </div>
    {/if}
{/if}
