{if $page.page_type == $smarty.const.PAGE_TYPE_BLOG}

    {if $subpages}
        <div class="ut2-blog">
            {include file="common/pagination.tpl"}

            {$ut2_load_more=$settings.abt__ut2.load_more.blog == 'Y'}
            {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="{"`$runtime.controller`_`$runtime.mode`"}" position="top" object="pages"}{/if}
            {foreach from=$subpages item="subpage" name="subpages"}
                <div class="ut2-blog__item"{if $ut2_load_more && $smarty.foreach.subpages.first} data-ut2-load-more="first-item"{/if}>
                    {if $subpage.main_pair}
                        <div class="ut2-blog__img-block">
                            {include file="common/image.tpl" obj_id=$subpage.page_id images=$subpage.main_pair image_width=350}
                        </div>
                    {/if}
                    <div class="ut2-blog__description">
                        <div class="ut2-blog__title-block">
                            <a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}" title="">
                                <h2 class="ut2-blog__post-title">
                                {$subpage.page}
                                </h2>
                            </a>
                            <div class="ut2-blog__date"><i class="ty-icon-calendar"></i> {$subpage.timestamp|date_format:"%B %e, %Y"}</div>
                        </div>
                        <div class="ty-wysiwyg-content">
                            <p>{$subpage.spoiler|strip_tags|truncate:360:"..." nofilter}</p>
                        </div>
                        <div class="ut2-blog__read-more">
                            <a href="{"pages.view?page_id=`$subpage.page_id`"|fn_url}" title="">{__("blog.read_more")}</a>
                        </div>
                    </div>
                </div>
            {/foreach}
            {if $ut2_load_more}{include file="common/abt__ut2_pagination.tpl" type="{"`$runtime.controller`_`$runtime.mode`"}" position="bottom" object="pages"}{/if}

            {include file="common/pagination.tpl"}
        </div>

    {/if}

    {if $page.description}
        {capture name="mainbox_title"}<span class="ut2-blog__post-title" {live_edit name="page:page:{$page.page_id}"}>{$page.page}</span>{/capture}
    {/if}

{/if}