<div id="breadcrumbs_{$block.block_id}">

    {if $breadcrumbs && $breadcrumbs|@sizeof > 1}
        {$is_mobile = $settings.abt__device == 'mobile'}
        <div class="ty-breadcrumbs clearfix">
            {strip}
                {foreach from=$breadcrumbs item="bc" name="bcn" key="key"}
                    {if $key != "0"}
                        <span class="ty-breadcrumbs__slash">/</span>
                    {/if}
                    {if $bc.link}
                        <a href="{$bc.link|fn_url}" class="ty-breadcrumbs__a{if $additional_class} {$additional_class}{/if}"{if $bc.nofollow} rel="nofollow"{/if}>
                            <bdi>{$bc.title|strip_tags nofilter}</bdi>
                        </a>
                    {else}
                        <span class="ty-breadcrumbs__current">
							<bdi>{$bc.title|strip_tags nofilter}</bdi>
                        </span>
                    {/if}
                {/foreach}
                {include file="common/view_tools.tpl"}
            {/strip}
        </div>

        {if !defined("AJAX_REQUEST")}
        <script type="application/ld+json">
            {fn_abt__ut2_print_bc_markup($breadcrumbs) nofilter}
        </script>
        {/if}
    {/if}
<!--breadcrumbs_{$block.block_id}--></div>