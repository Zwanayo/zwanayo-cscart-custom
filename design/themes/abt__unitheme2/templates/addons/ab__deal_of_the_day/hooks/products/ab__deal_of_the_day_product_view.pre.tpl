{if $product.promotions}
    {$image_height = 50}
    {$promotions_ids = fn_ab__dotd_filter_applied_promotions(array_keys($product.promotions), ["exclude_hidden" => true])}
    {$promotion = $promotions_ids[0]|fn_ab__dotd_get_cached_promotion_data}

    {if $promotion}
        <div class="ab__deal_of_the_day pd-dp">
            <div{if $promotion.to_date && $promotion.to_date > $smarty.now} class="col1"{/if}>
                <div class="pd-promotion__img">
                    <i class="ut2-icon-local_activity"></i>
                </div>

                <div class="pd-promotion__content">
                    <a href="{"promotions.view?promotion_id=`$promotion.promotion_id`"|fn_url}" class="pd-promotion__title" title="" target="_blank">{$promotion.name}</a>

                    {if $promotion.show_counter_on_product_page === "N"}
                        {if $promotion.to_date || $promotion.from_date}
                            <div class="ab__dotd_promotion_date">
                                <small>{__("period")}:
                                    {if $promotion.from_date}
                                        {__('ab__dotd.from')} {$promotion.from_date|date_format:"%d.%m.%Y"}
                                    {/if}
                                    {if $promotion.to_date}
                                        {__('ab__dotd.to')} {$promotion.to_date|date_format:"%d.%m.%Y"}
                                    {/if}
                                </small>
                            </div>
                        {/if}
                    {/if}

                    {if !$quick_view}
                        <div class="pd-details-promo-link">
                            {capture name="promotion_info_popup_opener"}
                                <div class="ab__dotd_promotion {if $promotion.ab__dotd_expired}action-is-over{/if}">
                                    <div class="row-fluid ab__dotd_promotion-main_info">
                                        {if $promotion.image}
                                            <div class="span8 ab__dotd_promotion-image" style="aspect-ratio: 2/1.2;background-size: 100%;background-repeat: no-repeat;background-image: url('{$promotion.image.icon.image_path}');">
                                            </div>
                                        {/if}
                                        <div class="span8">
                                            {hook name="ab__deal_of_the_day:promotion_page_header"}
                                                <h1>{$promotion.h1|default:$promotion.name nofilter}
                                                    {if $promotion.ab__dotd_expired}
                                                        <span>({__('ab__dotd.promotion_expired')})</span>
                                                    {elseif $promotion.ab__dotd_awaited}
                                                        <span>({__('ab__dotd.promotion_awaited')})</span>
                                                    {/if}
                                                </h1>
                                            {/hook}
                                            <div class="ab__dotd_promotion-description ty-wysiwyg-content">{$promotion.detailed_description nofilter}</div>

                                            {if $promotion.to_date || $promotion.from_date}
                                                <div class="ab__dotd_promotion_date">
                                                    <p>{__("ab__dotd.page_action_period")}
                                                        {if $promotion.from_date}
                                                            {__('ab__dotd.from')} {$promotion.from_date|date_format:"`$settings.Appearance.date_format`"}
                                                        {/if}
                                                        {if $promotion.to_date}
                                                            {__('ab__dotd.to')} {$promotion.to_date|date_format:"`$settings.Appearance.date_format`"}
                                                        {/if}
                                                    </p>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                </div>

                                {if $promotion.show_in_products_lists === "YesNo::YES"|enum}
                                <div class="buttons-container">
                                    <a href="{"promotions.view?promotion_id=`$promotion.promotion_id`"|fn_url}" class="ty-btn ty-btn__outline" title="" target="_blank">{__('view_products')}</a>
                                </div>
                                {/if}
                            {/capture}

                            {include file="common/popupbox.tpl"
                            text=__("ab__dotd.detailed")
                            link_text=__("ab__dotd.detailed")
                            link_text_meta="pd-promotion-info-popup"
                            link_icon="ut2-icon-outline-info"
                            link_icon_first=false
                            link_meta="details-promo-link ut2-append-body"
                            content=$smarty.capture.promotion_info_popup_opener
                            }
                            {if $promotions_ids|count > 1}
                                <a href="javascript:void(0)" class="also-in-promos-link cm-external-click"
                                   data-ca-scroll="content_ab__deal_of_the_day" data-ca-external-click-id="ab__deal_of_the_day" title="">{__('ab__dotd.all_promotions')}</a>
                            {/if}
                        </div>
                    {/if}
                </div>
            </div>
            {if $promotion.show_counter_on_product_page === "YesNo::YES"|enum && $promotion.to_date && $promotion.to_date > $smarty.now}
                <div class="col2">
                    <span class="time-left">{__('ab__dotd_time_left')}:</span>
                    {include file="addons/ab__deal_of_the_day/components/init_countdown.tpl"}
                </div>
            {/if}
        </div>
    {/if}
{/if}