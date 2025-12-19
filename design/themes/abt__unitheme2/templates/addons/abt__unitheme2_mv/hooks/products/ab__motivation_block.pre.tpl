{if "MULTIVENDOR"|fn_allowed_for && ($company_name || $company_id) && $settings.Vendors.display_vendor == "Y"}
    <div class="ut2-vendor-block">
        {if $settings.abt__ut2.products.vendor.show_logo[$settings.abt__device] == "Y"}
        	<div class="ut2-vendor-block__logo">{include file="common/image.tpl" images=$company_data.logos.theme.image image_width="80" image_height="80"}</div>
        {/if}
        <div class="ut2-vendor-block__content">
			<div class="ut2-vendor-block__name">
				<label>{__("vendor")}:</label>
				{if $settings.abt__ut2.products.vendor.show_name_as_link[$settings.abt__device] == "Y"}<a href="{"companies.products?company_id=`$company_id`"|fn_url}">{/if}{if $company_name}{$company_name}{else}{$company_id|fn_get_company_name}{/if}{if $settings.abt__ut2.products.vendor.show_name_as_link[$settings.abt__device] == "Y"}</a>{/if}
			</div>
			
			{if $settings.abt__ut2.products.vendor.truncate_short_description[$settings.abt__device] != "0"}
	        	<div class="ut2-vendor-block__info">{$company_data.company_description|strip_tags|truncate:$settings.abt__ut2.products.vendor.truncate_short_description[$settings.abt__device]:"...":true}</div>
	        {/if}

	        <div class="ut2-vendor-block__contacts">
				{if $settings.abt__ut2.products.vendor.show_phone[$settings.abt__device] == "Y" && $company_data.phone}<div class="ut2-vendor-block__phone"><i class="ut2-icon-outline-headset_mic"></i> {if $settings.abt__device == "mobile"}<a href="tel:{$company_data.phone nofilter}">{/if}{$company_data.phone nofilter}{if $settings.abt__device == "mobile"}</a>{/if}</div>{/if}
				{if $settings.abt__ut2.products.vendor.show_ask_question_link[$settings.abt__device] == "Y"}{hook name="companies:product_company_data"}{/hook}{/if}
			</div>
        </div>
    </div>
{/if}
