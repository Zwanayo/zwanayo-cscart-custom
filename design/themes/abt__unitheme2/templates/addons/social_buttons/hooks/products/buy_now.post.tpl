{if $settings.abt__device != "mobile"}
    {if $provider_settings && $settings.abt__ut2.products.addon_social_buttons.view[$settings.abt__device] == 'Y'}
    	{include file="addons/social_buttons/blocks/components/share_buttons.tpl"}
    {/if}
{/if}