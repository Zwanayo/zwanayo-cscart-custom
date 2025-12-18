{strip}
    {if $settings.General.alternative_currency == "use_selected_and_alternative"}
        {$temp = $value|format_price:$currencies.$primary_currency:$span_id:$class:false:$live_editor_name:$live_editor_phrase}
        {$temp|fn_abt__ut2_format_price:$currencies.$secondary_currency:$span_id:$class nofilter}
        {if $secondary_currency != $primary_currency}
            &nbsp;
            {if $class}<span class="{$class}">{/if}
            (
            {if $class}</span>{/if}
            {$value = $value|format_price:$currencies.$secondary_currency:$span_id:$class:true:$is_integer:$live_editor_name:$live_editor_phrase}
            <bdi>{$value|fn_abt__ut2_format_price:$currencies.$secondary_currency:$span_id:$class nofilter}</bdi>
            {if $class}<span class="{$class}">{/if}
            )
            {if $class}</span>{/if}
        {/if}
    {else}
        {$value = $value|format_price:$currencies.$secondary_currency:$span_id:$class:true:$live_editor_name:$live_editor_phrase}
        <bdi>{$value|fn_abt__ut2_format_price:$currencies.$secondary_currency:$span_id:$class nofilter}</bdi>
    {/if}
{/strip}