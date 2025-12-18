{foreach $product_features as $feature}
    {if $feature.feature_type != "ProductFeatures::GROUP"|enum}
        {include_ext file="common/icon.tpl" class="ty-icon-help-circle" assign=link_text_icon}
        <div class="ty-product-feature">
        <div class="ty-product-feature__label"><span>{$feature.description nofilter}</span>{if $feature.full_description|trim}{include file="common/popupbox.tpl" link_meta="ty-icon ty-icon-help-circle cm-dialog-auto-size ut2-append-body" id="ut2_features_dialog_`$feature.feature_id`" text=$feature.description content=$feature.full_description show_brackets=false}{/if}</div>

        {$hide_affix = $feature.feature_type == "ProductFeatures::MULTIPLE_CHECKBOX"|enum}

        {strip}
        <div class="ty-product-feature__value">
            {if $feature.prefix && !$hide_affix}<span class="ty-product-feature__prefix">{$feature.prefix}</span>{/if}
            {if $feature.feature_type == "ProductFeatures::SINGLE_CHECKBOX"|enum}
            {if $feature.value === "YesNo::YES"|enum}
                {include file="views/products/components/ab__similar_filter.tpl" feature=$feature variant_id="Y"}{hook name="abt__ut2_features:variant"}{__("yes")}{/hook}{else}{__("no")}{/if}
            {elseif $feature.feature_type == "ProductFeatures::DATE"|enum}
                {$feature.value_int|date_format:"`$settings.Appearance.date_format`"}
            {elseif $feature.feature_type == "ProductFeatures::MULTIPLE_CHECKBOX"|enum && $feature.variants}
                <ul class="ty-product-feature__multiple {if $ab__search_similar_in_category && $feature.filter_id}abt__ut2_checkboxes{/if}">
                {foreach $feature.variants as $var}
                    {$hide_variant_affix = !$hide_affix}
                    {if $var.selected}<li class="ty-product-feature__multiple-item">
                    {include file="views/products/components/ab__similar_filter.tpl" feature=$feature variant_id=$var.variant_id}
                    {if !$hide_variant_affix}<span class="ty-product-feature__prefix">{$feature.prefix}</span>{/if}
                        {hook name="abt__ut2_features:variant"}{$var.variant}{/hook}
                    {if !$hide_variant_affix}{if !$var@last}{if !$ab__enable_similar_filter_show}<em>,</em>{/if}{/if}
                    <span class="ty-product-feature__suffix">{$feature.suffix}</span>{/if}</li>{/if}
                {/foreach}
                </ul>
            {elseif in_array($feature.feature_type, ["ProductFeatures::TEXT_SELECTBOX"|enum, "ProductFeatures::EXTENDED"|enum, "ProductFeatures::NUMBER_SELECTBOX"|enum])}
               
                {foreach $feature.variants as $var}
                    {if $var.selected}
                        {$filter_value=$var.variant_id}
                        {if $feature.filter_style=="slider"}
                            {$filter_value="`$var.value_int|intval`-`$var.value_int|intval`"}
                        {/if}
                        {include file="views/products/components/ab__similar_filter.tpl" feature=$feature variant_id=$filter_value}
                        {if $feature.filter_style == "ProductFilterStyles::COLOR"|enum && $var.color}<div class="abt__ut2_color_mark" style="background-color: {$var.color};width:15px;height:15px;display:inline-block;margin-top:2px;border-radius: 50%;{if $var.color == "#ffffff"}border: 1px solid{/if}"></div>&nbsp;{/if}
                        {hook name="abt__ut2_features:variant"}{$var.variant}{/hook}
                    {break}
                    {/if}
                {/foreach}
            {elseif $feature.feature_type == "ProductFeatures::NUMBER_FIELD"|enum}
                {$feature.value_int|floatval|default:"-"}
            {else}
                {$feature.value|default:"-"}
            {/if}
            {if $feature.suffix && !$hide_affix}<span class="ty-product-feature__suffix">{$feature.suffix}</span>{/if}
        </div>
        {/strip}
        </div>
    {/if}
{/foreach}

{foreach $product_features as $feature}
    {if $feature.feature_type == "ProductFeatures::GROUP"|enum && $feature.subfeatures}
        <div class="ty-product-feature-group">
        {include file="common/subheader.tpl" title=$feature.description tooltip=$feature.full_description text=$feature.description}
        {include file="views/products/components/product_features.tpl" product_features=$feature.subfeatures}
        </div>
    {/if}
{/foreach}
