{if $class}<span 
        class="ut2-icon {$class}"
        {if $id}
            id={$id}
        {/if}
        {if $title}
            title="{$title}"
        {/if}

        {if $data}
            {foreach $data as $data_name => $data_value}
                {if $data_value}
                    {$data_name}="{$data_value}"
                {/if}
            {/foreach}
        {/if}
    >{if $icon_text}{$icon_text nofilter}{/if}</span>{/if}