{strip}
{*  DEPRECATED  *}
<script>
    (function(_, $) {
        $.ceEvent('on', 'ce.commoninit', function (context) {
            var abtam = context.find('div.abt__ut2_am:not(.loaded)').addClass('loaded');

            if (abtam.length) {
                var ids = [];
                abtam.each(function () {
                    ids.push($(this).attr('id'));
                });

                $.ceAjax('request', fn_url('abt__ut2.ajax_block_upload.load_menu'), {
                    result_ids: ids.join(','),
                    method: 'post',
                    hidden: true,
                    callback: function (data) {
                    }
                });
            }
        });
    }(Tygh, Tygh.$));
</script>
{/strip}