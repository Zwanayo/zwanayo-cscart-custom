{* block-description:abt__ut2__banner_carousel_combined *}

{strip}
    {if $items}
        <div id="banner_slider_{$block.snapping_id}" class="banners owl-carousel {if $block.properties.navigation == "D"}owl-pagination-true{/if}" {if $block.properties.margin|trim}style="margin: {$block.properties.margin}"{/if}>
            {foreach $items as $b}
                {$b_iteration = $b@iteration}
                {hook name="abt__ut2_banner:banners"}
                {if $b.type == 'abt__ut2'}
                    {include file="addons/abt__unitheme2/blocks/components/abt__ut2_banner.tpl"}
                {elseif $b.type == "G"}
                    <div class="ut2-banner">
                        {if $b.url}<a href="{$b.url|fn_url}"{if $b.target == "B"} target="_blank"{/if}>{/if}
                            {include file="common/image.tpl" images=$b.main_pair image_auto_size=true}
                            {if $b.url}</a>{/if}
                    </div>
                {else}
                    <div class="ut2-banner ty-wysiwyg-content">
                        {$b.description nofilter}
                    </div>
                {/if}
                {/hook}
            {/foreach}
        </div>
    {/if}

    <script>
        (function(_, $) {
            $.ceEvent('on', 'ce.commoninit', function(context) {
                var slider = context.find('#banner_slider_{$block.snapping_id}');
                if (slider.length) {
                    slider.owlCarousel({
                        direction: '{$language_direction}',
                        items: 1,
                        singleItem: true,
                        slideSpeed: {$block.properties.speed|default:400},
                        autoPlay: {($block.properties.delay > 0) ? $block.properties.delay * 1000 : "false"},
                        afterInit: function() {
                            run_video_autoplay(this);
                        },
                        afterMove: function() {
                            slider.find('.ut2-a__video iframe').each(function(){
                                this.contentWindow.postMessage('{ "event":"command","func":"' + 'pauseVideo' + '","args":"" }', '*');
                            });

                            run_video_autoplay(this);
                        },
                        stopOnHover: true,
                        beforeInit: function () {
                            $.ceEvent('trigger', 'ce.banner.carousel.beforeInit', [this]);
                        },
                        {if $block.properties.navigation == "N"}
                        pagination: false
                        {/if}
                        {if $block.properties.navigation == "D"}
                        pagination: true
                        {/if}
                        {if $block.properties.navigation == "P"}
                        pagination: true,
                        paginationNumbers: true
                        {/if}
                        {if $block.properties.navigation == "A"}
                        pagination: false,
                        navigation: true,
                        navigationText: ['<i class="ty-icon-left-open-thin"></i>', '<i class="ty-icon-right-open-thin"></i>']
                        {/if}
                    });
                }
            });

            function run_video_autoplay (active_banner) {
                var user_item = active_banner['$userItems'][active_banner.currentItem];
                var video_elem = user_item.querySelector('.ut2-a__video');

                if (video_elem !== null) {
                    var iframe = video_elem.querySelector('iframe');

                    if (iframe === null || iframe === undefined) {
                        setTimeout(function () {
                            $(video_elem).click();
                        }, 200);
                    } else {
                        iframe.contentWindow.postMessage('{ "event":"command","func":"' + 'playVideo' + '","args":"" }', '*');
                    }
                }
            }
        }(Tygh, Tygh.$));
    </script>
{/strip}