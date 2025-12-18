{** block-description:block_vendor_information **}

<div class="ty-vendor-information">

	{ab__hide_content bot_type="ALL"}
	<div class="ut2-vendor-name"><a href="{"companies.view?company_id=`$vendor_info.company_id`"|fn_url}">{$vendor_info.company}</a></div>
	{/ab__hide_content}

	{if $settings.abt__ut2.vendor.truncate_short_description[$settings.abt__device] != "0"}
		<p>{$vendor_info.company_description|strip_tags|truncate:$settings.abt__ut2.vendor.truncate_short_description[$settings.abt__device]:"...":true nofilter}</p>
	{/if}

	{ab__hide_content bot_type="ALL"}
	<p><a href="{"companies.view?company_id=`$vendor_info.company_id`"|fn_url}" class="ty-btn" rel="nofollow">{__("extra")}</a></p>
	{/ab__hide_content}

	{if "MULTIVENDOR"|fn_allowed_for && $settings.abt__ut2.vendor.show_ask_question_link[$settings.abt__device] == "YesNo::YES"|enum && $addons.vendor_communication.show_on_vendor == "YesNo::YES"|enum}
		{$uniq = uniqid()}
		{$object_id = "`$company_id`_`$uniq`"}
		<div class="vendor_communication-btn">
			{include file="addons/vendor_communication/views/vendor_communication/components/new_thread_button.tpl" title=__("vendor_communication.ask_a_question") object_id=$object_id show_form=true}
		</div>

		{include
		file="addons/vendor_communication/views/vendor_communication/components/new_thread_form.tpl"
		object_type=$smarty.const.VC_OBJECT_TYPE_COMPANY
		object_id=$object_id
		company_id=$company_id
		vendor_name=$vendor_info.company
		}
	{/if}
</div>
