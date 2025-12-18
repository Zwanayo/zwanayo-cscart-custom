{*
    Import
    ---
    $bundle
    $obj_id
    $promotion_image_width
    $promotion_image_height
    $company_name
*}

{script src="js/tygh/exceptions.js"}
{assign var="days_left" value=(1-($smarty.now-$bundle.date_to)/86400)|floor}

{if $bundle}
    <div class="ab__pb--item {if $days_left >= 1 || !$bundle.date_to}active{/if}">
        <div class="ab__pb--image">
            {if $bundle.main_pair|is_array}
            <a id="opener_product_bundle_promotions_{$bundle.bundle_id}"
                    class="cm-dialog-opener"
                    href="{"product_bundles.get_product_bundles?bundle_id=`$bundle.bundle_id`&in_popup=1&return_url=`$config.current_url|escape:url`"|fn_url}"
                    data-ca-target-id="content_product_bundle_promotions_{$bundle.bundle_id}"
                    data-ca-dialog-title="{$bundle.storefront_name}"
                    rel="nofollow"
                >
                {include file="common/image.tpl"
                    images=$bundle.main_pair
                    image_id="`$bundle.bundle_id`"
                    class="ty-grid-promotions__image"
                    image_width=$promotion_image_width|default:'330'
                    image_height=$promotion_image_height|default:'200'
                }
            </a>
            {else}
                <span class="ty-no-image"><span class="ty-icon ty-icon-image ty-no-image__icon" title="{__("no_image")}"></span></span>
            {/if}
        </div>

        {if $bundle.date_to && $days_left >= 1}
            <div class="ab__pb--available">
                {if $days_left >= 1}
                    {__('ab__pb.days_left', [$days_left])}
                {/if}
            </div>
        {/if}

        <div class="ab__pb--content">
            <a id="opener_product_bundle_promotions_{$bundle.bundle_id}"
                    class="cm-dialog-opener"
                    href="{"product_bundles.get_product_bundles?bundle_id=`$bundle.bundle_id`&in_popup=1&return_url=`$config.current_url|escape:url`"|fn_url}"
                    data-ca-target-id="content_product_bundle_promotions_{$bundle.bundle_id}"
                    data-ca-dialog-title="{$bundle.storefront_name}"
                    rel="nofollow"
                >
                <span class="ab__pb--header">{$bundle.storefront_name}</span>
            </a>

            {if "MULTIVENDOR"|fn_allowed_for && ($company_name || $bundle.company_id)}
                <div class="ab__pb--company">
                    <a href="{"companies.products?company_id=`$bundle.company_id`"|fn_url}" class="ty-grid-promotions__company-link">
                        {if $company_name}{$company_name}{else}{$bundle.company_id|fn_get_company_name}{/if}
                    </a>
                </div>
            {/if}

            {if $bundle.description}
                <div class="ab__pb--description">
                    {$bundle.description nofilter}
                </div>
            {/if}
        </div>
    </div>
{/if}
