{style src="addons/abt__unitheme2/styles.less"}
{if $addons.vendor_locations.status == "ObjectStatuses::ACTIVE"|enum}
    {style src="addons/vendor_locations/theme.less"}
{/if}
{if $runtime.controller == "checkout" && $runtime.mode == "checkout"}
    {style src="addons/abt__unitheme2/components/checkout/abt__ut2_simple_shipping_methods.less"}
    {style src="addons/abt__unitheme2/components/checkout/abt__ut2_checkout.less"}
{/if}
{*{if $settings.ab__device == "mobile"}*}
    {*{style src="addons/abt__unitheme2/mobile_styles.less"}*}
{*{/if}*}