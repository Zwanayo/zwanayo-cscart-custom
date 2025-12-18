{** block-description:tmpl_abt__ut2__contacts **}

{$dropdown_id=$block.snapping_id}
<div class="ut2-pn">
    <div class="ut2-pn__wrap ut2-pn__row cm-combination" id="sw_dropdown_{$dropdown_id}">
        <div class="ut2-pn__icon">&nbsp;</div>
        <div class="ut2-pn__title">
            <a href="javascript:void(0);"><bdi>{$settings.Company.company_phone}</bdi></a>
        </div>
        <div class="ut2-pn__expand_icon"><i class="ut2-icon-outline-expand_more"></i></div>
    </div>
    <div class="ut2-pn__contacts">
        <div id="dropdown_{$dropdown_id}" class="cm-popup-box ut2-pn__items-full ty-dropdown-box__content hidden" style="display:none;">
            <a href="javascript:void(0);" data-ca-external-click-id="sw_dropdown_{$dropdown_id}" rel="nofollow" class="cm-external-click ut2-btn-close hidden"><i class="ut2-icon-baseline-close"></i></a>
            <div class="ut2-pn__items">
                {hook name="abt__ut2_contacts_block:phones"}
                <p>
                    {if $settings.Company.company_phone|trim}
                        <a href="tel:{$settings.Company.company_phone}"><bdi>{$settings.Company.company_phone}</bdi></a>
                    {/if}
                    {if $settings.Company.company_phone_2|trim}
                        <a href="tel:{$settings.Company.company_phone_2}"><bdi>{$settings.Company.company_phone_2}</bdi></a>
                    {/if}
                    <!-- Edit work time -->
                    <small>{__('call_request.work_time')}</small>
                </p>
                {/hook}

                <hr>

                {if $block.properties.abt__ut2__block_contacts_show_social_buttons === 'Y'}
                    <!-- Edit Social links -->
                    <div class="ut2-social-links">
                        {__('abt__ut2__block_contacts.social_links')}
                    </div>
                {/if}

                {if $block.properties.abt__ut2__block_contacts_show_email === 'Y' && $settings.Company.company_orders_department|trim}
                    <p>
                        <small>Email</small>
                        <a href="mailto:{$settings.Company.company_orders_department|trim}" style="font-weight:normal;font-size: inherit;">{$settings.Company.company_orders_department}</a>
                    </p>
                {/if}

                {if $block.properties.abt__ut2__block_contacts_show_addres === 'Y'}
                    {if $settings.Company.company_country|fn_get_country_name || $settings.Company.company_city || $settings.Company.company_address}
                        <p>
                            <small>{__("address")}</small>
                        <div>{$settings.Company.company_country|fn_get_country_name}, {$settings.Company.company_city}, {$settings.Company.company_address}</div>
                        </p>
                    {/if}
                {/if}
            </div>
        </div>
    </div>
</div>
