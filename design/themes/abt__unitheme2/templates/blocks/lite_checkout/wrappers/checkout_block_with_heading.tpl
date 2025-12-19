{** block-description:wrapper_abt__ut2_checkout_block_with_heading **}

{if $content|trim}
    {if $block.user_class || $content_alignment == 'RIGHT' || $content_alignment == 'LEFT'}
        <div class="{if $block.user_class}{$block.user_class}{/if} {if $content_alignment == 'RIGHT'}ty-float-right{elseif $content_alignment == 'LEFT'}ty-float-left{/if}">
    {/if}
        <div class="litecheckout__container ab_step-container">
            <div class="litecheckout__group">
                <div class="litecheckout__item">
                    <h2 class="litecheckout__ab_step-title">{$block.name}</h2>
                </div>
            </div>
            {$content nofilter}
        </div>
    {if $block.user_class || $content_alignment == 'RIGHT' || $content_alignment == 'LEFT'}
        </div>
    {/if}
{/if}