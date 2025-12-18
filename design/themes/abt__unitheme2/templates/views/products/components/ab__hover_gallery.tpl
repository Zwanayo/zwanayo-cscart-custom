{capture name="image_previews"}
    {if $image_pairs}
        {$image_pairs = array_slice($image_pairs,0, 5)}
    {/if}
    {foreach $image_pairs as $image_pair}
        {if $image_pair}
            {include file="common/image.tpl" no_ids=true
                images=$image_pair
                capture_image=true
                image_width=$image_width
                image_height=$image_height
            }
            <div class="item" data-ca-product-additional-image-src="{$smarty.capture.icon_image_path|trim}"
                    {if $smarty.capture.icon_image_path_hidpi|trim} data-ca-product-additional-image-srcset="{$smarty.capture.icon_image_path_hidpi}"{/if}
            >
            </div>
        {/if}
    {/foreach}
{/capture}
{if $smarty.capture.image_previews|trim}
    <div class="cm-ab-hover-gallery abt__ut2_hover_gallery {$additional_class}" >
        <div class="item"></div>
        {$smarty.capture.image_previews nofilter}
        <div class="abt__ut2_hover_gallery_indicators">
            <div class="active"></div>
            {for $count = 1 to count($image_pairs)}
                <div></div>
            {/for}
        </div>
    </div>
{/if}