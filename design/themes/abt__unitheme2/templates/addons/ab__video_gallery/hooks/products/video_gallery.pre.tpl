{$icon_play = icon}

{if $product.ab__vg_videos}
	{if $icon_play != "icon"}
    	{include file="addons/ab__video_gallery/components/video_icon.tpl" icon_width=30 icon_height=30 icon_class="ab__vg-icon-video"}
    {else}
    	<i class="ab__vg-icon-video {$addons.ab__video_gallery.video_icon}-icon">{if $addons.ab__video_gallery.video_icon == "video"}<span>{__("ab__vg.label_product_videos")}</span>{/if}</i>
    {/if}
{/if}