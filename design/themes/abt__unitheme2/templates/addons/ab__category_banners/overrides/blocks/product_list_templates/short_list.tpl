{** template-description:compact_list **}

{capture name="short_list_html"}
{$tmpl='short_list'}

{include file="blocks/product_list_templates/default_params/`$tmpl`.tpl"}
{include file="blocks/list_templates/compact_list.tpl"}
{/capture}

{if $ab__cb_banner_exists}
    {capture name="short_list_html"}
        {$smarty.capture.short_list_html|fn_ab__cb_insert_category_banner:'short_list' nofilter}
    {/capture}
{/if}

{$smarty.capture.short_list_html nofilter}