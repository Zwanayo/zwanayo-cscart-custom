{if defined("AJAX_REQUEST") && $settings.abt__ut2.products.view.show_sticky_add_to_cart[$settings.abt__device] == "YesNo::YES"|enum && $smarty.request.result_ids != "tygh_main_container"}
    {include file="buttons/sticky_add_to_cart.tpl"}
{/if}

{$ab__search_similar_in_category = $settings.abt__ut2.products.search_similar_in_category.{$settings.abt__device} == "YesNo::YES"|enum}
{if $ab__search_similar_in_category}
    {$tpl_search_similar_button = {include file="buttons/button.tpl" but_text=__("ab__ut2.search_similar") but_meta="abt__ut2_search_similar_in_category_btn hidden"}}
    {strip}
    <script>
        (function(_, $) {
            $.extend(_.abt__ut2.templates, {
                search_similar_button: `{$tpl_search_similar_button|trim|escape:"javascript" nofilter}`
            });
        }(Tygh, Tygh.$));
    </script>
    {/strip}
{/if}