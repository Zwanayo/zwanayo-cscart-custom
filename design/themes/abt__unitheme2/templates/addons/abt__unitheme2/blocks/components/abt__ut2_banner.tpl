{** ab:single-banner **}
{hook name="abt__ut2_banner:banners"}
<div class="ut2-banner ut2-settings-{$b.abt__ut2_device_settings} {$b.abt__ut2_class}" {if $block.properties.margin|trim}style="margin: {$block.properties.margin}"{/if}>
    {if $b.abt__ut2_background_type === "image"}
        {* set Background-vars *}
        {if $settings.abt__ut2.general.lazy_load === "YesNo::YES"|enum}
            {$data_backgroud_url = $b.abt__ut2_background_image.icon.image_path}
        {else}
            {$background_url = $b.abt__ut2_background_image.icon.image_path}
        {/if}
    {/if}
    {hook name="abt__ut2_banner:banner"}{/hook}

    {if $b.abt__ut2_button_use === "YesNo::NO"|enum && $b.abt__ut2_url|trim}<a {if $b.abt__ut2_object === 'video' && $b.abt__ut2_youtube_id}data-content="video"{/if}href="{$b.abt__ut2_url|fn_url}"{if $b.abt__ut2_how_to_open === 'in_new_window'} target="_blank"{/if} title="">{/if}

        <div data-id="{$b.banner_id}"
             class="ut2-a__bg-banner {$b.abt__ut2_color_scheme}{if $b.abt__ut2_background_color === '#ffffff' && $b.abt__ut2_background_color_use === "YesNo::YES"|enum} white-bg{/if}{if $data_backgroud_url} lazyload{/if}"

             style="{strip}
                {if $b.abt__ut2_background_color_use === "YesNo::YES"|enum}
                    background-color:{$b.abt__ut2_background_color};{/if}
                {if $b.abt__ut2_background_image_size}
                    background-size:{$b.abt__ut2_background_image_size};{/if}
                {if $background_url}
                    background-image:url('{$background_url}');{/if}
                {if $settings.abt__device === "mobile" && $block.properties.height_mobile}
                    max-height:{$block.properties.height_mobile};
                {else}
                    max-height:{$block.properties.height};
                {/if}{/strip}"

                {if $data_backgroud_url} data-background-url="{$data_backgroud_url}"{/if}>

            {if $b.abt__ut2_background_type === "mp4_video" && $b.abt__ut2_background_mp4_video}
                <video class="ut2-banner__video" src="{$config.origin_https_location}/images/{$b.abt__ut2_background_mp4_video}" muted loop playsinline></video>
            {/if}

            <div class="ut2-a__content valign-{$b.abt__ut2_content_valign} align-{$b.abt__ut2_content_align}
                {if $b.abt__ut2_content_full_width === "YesNo::YES"|enum} width-full{else} width-half{/if}
                {if $b.abt__ut2_main_image.icon.image_path} internal-image{/if}
                {if $b.abt__ut2_content_bg_position === "whole_banner"} mask-whole-banner{/if}"

                style="{strip}
                    {if $b.abt__ut2_content_bg_position === "whole_banner"}
                        {if $b.abt__ut2_content_bg === "colored"}
                            background-color:{$b.abt__ut2_content_bg_color};
                        {/if}
                        {if $b.abt__ut2_content_bg === "transparent" || $b.abt__ut2_content_bg === "transparent_blur"}
                            background-color:rgba({if $b.abt__ut2_color_scheme === "dark"}0,0,0{else}255,255,255{/if}, {$b.abt__ut2_content_bg_opacity}%);
                            {if $b.abt__ut2_content_bg === "transparent_blur"}
                                backdrop-filter:blur(6px);
                                -webkit-backdrop-filter:blur(6px);
                            {/if}
                        {/if}
                        {if $settings.abt__device === "mobile" && $block.properties.height_mobile}
                            height:{$block.properties.height_mobile};
                            {else}
                            height:{$block.properties.height};
                        {/if}
                    {/if}
                    {if $settings.abt__device === "mobile" && $block.properties.height_mobile && $b.abt__ut2_content_bg_position !== "whole_banner"}
                            height:{$block.properties.height_mobile};
                    {elseif $b.abt__ut2_content_bg_position !== "whole_banner"}
                            height:{$block.properties.height};
                    {/if}
                {/strip}">
                {if $b.abt__ut2_object === 'image' && $b.abt__ut2_main_image.icon.image_path}
                    <div class="ut2-a__img {if $b.abt__ut2_content_full_width === "YesNo::YES"|enum}width-full{else}width-half{/if}">
                        {include file="common/image.tpl" images=$b.abt__ut2_main_image.icon}
                    </div>
                    {elseif $b.abt__ut2_object === 'video' && $b.abt__ut2_youtube_id}
                    <div class="ut2-a__img ut2-a__video {if $b.abt__ut2_content_full_width === "YesNo::YES"|enum}width-full{else}width-half{/if}"
                         {if $block.properties.height || $block.properties.height_mobile}
                         style="height: {if $settings.abt__device === "mobile"}{if $b.abt__ut2_content_full_width === "YesNo::YES"|enum}{$block.properties.height_mobile / 2}{else}{$block.properties.height_mobile}{/if}{else}{$block.properties.height}{/if}"{/if}
                         data-banner-youtube-id="{$b.abt__ut2_youtube_id}"
                         data-is-autoplay="{$b.abt__ut2_youtube_autoplay}"
                         data-banner-youtube-params="{$b|fn_abt__ut2_build_youtube_link:true}">
                             <img data-type="youtube-img"
                             {if $settings.abt__ut2.general.lazy_load === "YesNo::YES"|enum}src="{$smarty.const.ABT__UT2_LAZY_IMAGE}"
                             data-{/if}src="https://img.youtube.com/vi/{$b.abt__ut2_youtube_id}/hqdefault.jpg"
                             alt="{$b.abt__ut2_title|strip_tags}">
                    </div>
                {/if}

                <div class="ut2-a__description {if $b.abt__ut2_content_full_width =="YesNo::YES"|enum}width-full{else}width-half{/if}"
                     {if $b.abt__ut2_content_bg !== "none" && $b.abt__ut2_content_bg_position === "full_height"}style="{strip}background-color:{if $b.abt__ut2_content_bg === "colored"}{$b.abt__ut2_content_bg_color}{else}rgba({if $b.abt__ut2_color_scheme === "dark"}0,0,0{else}255,255,255{/if}, {$b.abt__ut2_content_bg_opacity}%){if $b.abt__ut2_content_bg === "transparent_blur"};backdrop-filter: blur(6px);-webkit-backdrop-filter: blur(6px);{/if}{/if}{/strip}"{/if}>

                    <div class="box{if $b.abt__ut2_content_bg !== "none" && $b.abt__ut2_content_bg_position === "only_under_content" && $b.abt__ut2_content_full_width !== "YesNo::YES"|enum} mask-under-content{/if}"
                         style="{strip}
                         {if !empty($b.abt__ut2_padding)}
                             padding:{$b.abt__ut2_padding};
                         {/if}
                         {if $b.abt__ut2_content_bg !== "none" && $b.abt__ut2_content_bg_position === "only_under_content" || $b.abt__ut2_content_bg !== "none" && $b.abt__ut2_content_bg === "colored"}
                             {if $b.abt__ut2_content_bg === "colored" && $b.abt__ut2_content_bg_color_use === "YesNo::YES"|enum}
                                 background-color:{$b.abt__ut2_content_bg_color};
                             {/if}
                             {if $b.abt__ut2_content_bg === "transparent" || $b.abt__ut2_content_bg === "transparent_blur"}
                                 background-color:rgba({if $b.abt__ut2_color_scheme === "dark"}0,0,0{else}255,255,255{/if}, {$b.abt__ut2_content_bg_opacity}%);
                             {/if}
                             {if $b.abt__ut2_content_bg === "transparent_blur"}
                                 backdrop-filter:blur(6px);
                                 -webkit-backdrop-filter:blur(6px);
                             {/if}
                         {/if}{/strip}">

                        <{$b.abt__ut2_title_tag|default:"div"} class="ut2-a__title{if $b.abt__ut2_title_shadow === "YesNo::YES"|enum} shadow{/if} weight-{$b.abt__ut2_title_font_weight}" style="font-size:{$b.abt__ut2_title_font_size};{if $b.abt__ut2_title_color_use === "YesNo::YES"|enum}color:{$b.abt__ut2_title_color};{/if}">
                            {$b.abt__ut2_title nofilter}
                        </{$b.abt__ut2_title_tag|default:"div"}>

                        {if $b.abt__ut2_description}
                            <div class="ut2-a__descr"
                                 style="{if $b.abt__ut2_description_color_use === "YesNo::YES"|enum}color: {$b.abt__ut2_description_color};{/if}{if $b.abt__ut2_description_bg_color_use === "YesNo::YES"|enum}background-color:{$b.abt__ut2_description_bg_color};{if $b.abt__ut2_description_bg_color}position: relative;left: 5px;display: inline;padding: 3px 0 3px;box-shadow: {$b.abt__ut2_description_bg_color} -5px 0 0 0, {$b.abt__ut2_description_bg_color} 5px 0 0 0;{/if}{/if}{if $b.abt__ut2_description_font_size}font-size: {$b.abt__ut2_description_font_size};{/if}">
                                {$b.abt__ut2_description nofilter}
                            </div>
                        {/if}

                        {if $b.abt__ut2_button_use === "YesNo::YES"|enum && $b.abt__ut2_url|trim}
                            <div class="ut2-a__button">
                                <a class="ty-btn ty-btn__primary"
                                   style="{if $b.abt__ut2_button_text_color_use === "YesNo::YES"|enum}color: {$b.abt__ut2_button_text_color};{/if}{if $b.abt__ut2_button_color_use === "YesNo::YES"|enum}background: {$b.abt__ut2_button_color};{/if}"
                                   href="{$b.abt__ut2_url|fn_url}"{if $b.abt__ut2_how_to_open === 'in_new_window'} target="_blank"{/if}>{$b.abt__ut2_button_text|default:"button"}</a>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    {if $b.abt__ut2_button_use == 'N' && $b.abt__ut2_url|trim}</a>{/if}
</div>
{/hook}
