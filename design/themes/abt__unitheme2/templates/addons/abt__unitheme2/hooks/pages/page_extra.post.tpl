{if $page.abt__ut2_microdata_schema_type && !defined("AJAX_REQUEST")}
    <script type="application/ld+json">
        {fn_abt__print_page_murkup($page) nofilter}
    </script>
{/if}