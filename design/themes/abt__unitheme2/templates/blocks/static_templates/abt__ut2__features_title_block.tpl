{** block-description:tmpl_abt__ut2__features_title_block **}

<div class="ut2-extra-block-title">
    {hook name="wrapper:features_title_wrapper"}
        {if $variant_data.variant}
        <h1 class="ty-mainbox-title">
            {hook name="wrapper:features_title"}
				<span>{$variant_data.variant nofilter}</span>
            {/hook}
        </h1>
        {/if}
    {/hook}
	{include file="common/breadcrumbs.tpl"}
</div>

