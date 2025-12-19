{hook name="ab__stikcers:sticker_name"}
    {$device = "desktop"}
    {if $setting.abt__device}
        {$device = "mobile"}
    {/if}

    <span style="color:{$sticker.appearance.text_color}">{fn_ab__stickers_get_sticker_string_value($sticker.{"name_for_`$device`"}|default:$sticker.name_for_admin, $placeholders) nofilter}</span>
{/hook}