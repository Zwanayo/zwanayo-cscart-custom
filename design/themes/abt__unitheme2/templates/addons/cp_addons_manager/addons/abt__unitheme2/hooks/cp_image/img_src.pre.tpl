{$lazy_load = ($settings.abt__ut2.product_list.lazy_load === "Y" || $settings.abt__ut2.general.lazy_load === "Y") && $lazy_load|default:true scope=parent}
{if $lazy_load && $smarty.const.ABT__UT2_LAZY_IMAGE}src="{$smarty.const.ABT__UT2_LAZY_IMAGE}" {/if}
