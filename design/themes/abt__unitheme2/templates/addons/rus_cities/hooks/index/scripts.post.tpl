{if $runtime.controller == "checkout" && $runtime.mode == "checkout"}
    {script src="js/addons/abt__unitheme2/rus_cities_checout_cities.js"}
    <script>
        (function (_, $) {
            $.extend(_.abt__ut2, {
                checkout_cities: {$abt_ut2__checkout_cities|json_encode nofilter}
            });
        }(Tygh, Tygh.$));
    </script>
{/if}