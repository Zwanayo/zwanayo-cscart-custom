{hook name="abt__youpitheme:og_image"}
{if $runtime.controller == "promotions" && $promotion.image}
    <meta property="og:image" content="{$promotion.image.icon.image_path}" />
{/if}
{/hook}