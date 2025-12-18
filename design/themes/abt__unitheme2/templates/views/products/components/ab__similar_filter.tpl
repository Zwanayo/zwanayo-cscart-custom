{$ab__enable_similar_filter_show = false scope=global}

{if $ab__search_similar_in_category && $feature.filter_id}
    {$ab__enable_similar_filter = true scope=global}
    {$ab__enable_similar_filter_show = true scope=global}
    <input type="checkbox" class="cm-ab-similar-filter" name="features_hash[{$feature.filter_id}]" data-ca-filter-id="{$feature.filter_id}" data-ab-show-search-button="{if $ab__features_count > 2}true{else}false{/if}" value="{$variant_id}">
{/if}