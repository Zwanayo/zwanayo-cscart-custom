{** block-description:tmpl_abt__ut2__contacts_manually **}

{$dropdown_id=$block.snapping_id}
<div class="ut2-pn {if $block.properties.abt__ut2__block_contacts_open_right_panel === 'Y'}ut2-right-panel{/if}">
    <div class="ut2-pn__wrap ut2-pn__row cm-combination {if $block.properties.abt__ut2__block_contacts_open_right_panel === 'Y'}cm-abt--ut2-toggle-scroll  cm-external-triggered{/if}" id="sw_dropdown_{$dropdown_id}">
        <div class="ut2-pn__icon">&nbsp;</div>
        <div class="ut2-pn__title">
            <a href="javascript:void(0);"><bdi>{$phone_1}</bdi></a>
        </div>
        <div class="ut2-pn__expand_icon"><i class="ut2-icon-outline-expand_more"></i></div>
    </div>
    <div class="ut2-pn__contacts">
        <div id="dropdown_{$dropdown_id}" class="cm-popup-box ut2-pn__items-full ty-dropdown-box__content hidden" style="display:none;">
            <a href="javascript:void(0);" data-ca-external-click-id="sw_dropdown_{$dropdown_id}" rel="nofollow" class="cm-external-click ut2-btn-close hidden"><i class="ut2-icon-baseline-close"></i></a>
            <div class="ut2-pn__items">
                {hook name="abt__ut2_contacts_block:phones"}
                    {capture name="contact_phones"}
                        {for $phone_nr = 1 to 5}
                            {if $phone_{$phone_nr}}
                                <a href="tel:{$phone_{$phone_nr}}"><bdi>{$phone_{$phone_nr}}</bdi></a>
                            {/if}
                        {/for}
                    {/capture}
                    {if $smarty.capture.contact_phones|trim}
                        <p>
                            {$smarty.capture.contact_phones nofilter}
                        </p>
                    {/if}
                {/hook}

                <hr>

                {if $block.properties.abt__ut2__block_contacts_show_social_buttons === 'Y'}
                    <!-- Edit Social links -->
                    <div class="ut2-social-links">
                        {__('abt__ut2__block_contacts.social_links')}
                    </div>
                {/if}

                {if $email}
                    <p>
                        <small>{__("email")}</small>
                        <a href="mailto:{$email}" style="font-weight:normal;font-size: inherit;">{$email}</a>
                    </p>
                {/if}
                {if $working_hours}
                    <p>
                        <small>{__("abt__ut2.contacts.working_hours")}</small>
                        <span>{$working_hours}</span>
                    </p>
                {/if}
                {if $address}
                    <p>
                        <small>{__("address")}</small>
                        <span>{$address}</span>
                    </p>
                {/if}

            </div>
        </div>
        {if $block.properties.abt__ut2__block_contacts_open_right_panel === 'Y'}
            <div class="cm-external-click ui-widget-overlay hidden" data-ca-external-click-id="sw_dropdown_{$dropdown_id}"></div>
        {/if}
    </div>
</div>
