{** block-description:wrapper_abt__ut2_checkout_block_with_heading_dropdown **}

{if $content|trim}
    {assign var="dropdown_id" value=$block.snapping_id}
    <div class="ty-dropdown-box {if $block.user_class} {$block.user_class}{/if}{if $content_alignment == "RIGHT"} ty-float-right{elseif $content_alignment == "LEFT"} ty-float-left{/if}">    
        <div class="ty-dropdown-box__title">
            <p>{$title nofilter}</p>
            <a href="javascript:void(0);" id="sw_dropdown_{$dropdown_id}" class="cm-combination" rel="nofollow">{__("add")}</a>
        </div>
        <div id="dropdown_{$dropdown_id}" class="cm-popup-box ty-dropdown-box__content hidden">
            {$content|default:"&nbsp;" nofilter}
        </div>
    </div>
{/if}
