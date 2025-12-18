<script>
(function(_, $) {
    $.ceEvent('on', 'ce.commoninit', function(context) {
        var elm = context.find('#scroll_list_{$block.block_id}');

        var item = {$block.properties.item_quantity|default:4},
            itemsDesktop = {$itemsDesktop|default:4},
            itemsDesktopSmall = {$itemsDesktopSmall|default:4},
            itemsTablet = {$itemsTablet|default:3},
            itemsTabletSmall = {$itemsTabletSmall|default:2},
            itemsMobile = {$item_quantity_responsive["mobile"]|default:1};

        if (item === 1) {
            itemsDesktop = itemsDesktopSmall = itemsTablet = 1;
        }

        var desktop = [1366, itemsDesktop],
            desktopSmall = [1200, itemsDesktopSmall],
            tablet = [900, itemsTablet],
            tabletSmall = [768, itemsTabletSmall],
            mobile = [660, itemsMobile];

        {if $block.properties.outside_navigation == "Y"}
        function outsideNav () {
            if(this.options.items >= this.itemsAmount){
                $("#owl_outside_nav_{$block.block_id}").hide();
            } else {
                $("#owl_outside_nav_{$block.block_id}").show();
            }
        }
        {/if}

        if (elm.length) {
            elm.owlCarousel({
                direction: '{$language_direction}',
                items: item,
                itemsDesktop: desktop,
                itemsDesktopSmall: desktopSmall,
                itemsTablet: tablet,
                itemsTabletSmall: tabletSmall,
                itemsMobile: mobile,
                {if $block.properties.scroll_per_page == "Y"}
                scrollPerPage: true,
                {/if}
                {if $block.properties.not_scroll_automatically == "Y"}
                autoPlay: false,
                {else}
                autoPlay: '{$block.properties.pause_delay * 1000|default:0}',
                {/if}
                slideSpeed: {$block.properties.speed|default:400},
                stopOnHover: true,
                {if $block.properties.outside_navigation == "N"}
                navigation: true,
                navigationText: ['<i class="ty-icon-left-open-thin"></i>', '<i class="ty-icon-right-open-thin"></i>'],
                {/if}
                pagination: false,
                beforeInit: function () {
                    $.ceEvent('trigger', 'ce.scroller_init_with_quantity.beforeInit', [this]);
                },
            {if $block.properties.outside_navigation == "Y"}
                afterInit: outsideNav,
                afterUpdate : outsideNav
            });

              $('{$prev_selector}').click(function(){
                elm.trigger('owl.prev');
              });
              $('{$next_selector}').click(function(){
                elm.trigger('owl.next');
              });

            {else}
            });
            {/if}
        }
    });
}(Tygh, Tygh.$));
</script>
