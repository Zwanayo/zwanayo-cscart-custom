{if $provider_settings && $settings.abt__ut2.products.addon_social_buttons.view[$settings.abt__device] == 'Y'}
<div class="ut2-pb__share">
    <a href="javascript:void(0)" rel="nofollow" role="button" id="sw_dropdown_sb" class="ut2-share-buttons-link cm-combination label"><i class="ut2-icon-share"></i>
        <bdi>{__("abt__ut2.addon_social_buttons.share")}</bdi>
    </a>
    <span id="dropdown_sb" class="cm-popup-box ty-dropdown-box__content caret hidden">
        {foreach from=$provider_settings item="provider_data"}
            {if $provider_data && $provider_data.template && $provider_data.data}
                {include file="addons/social_buttons/providers/`$provider_data.template`"}
            {/if}
        {/foreach}
    </span>
</div>
{/if}
