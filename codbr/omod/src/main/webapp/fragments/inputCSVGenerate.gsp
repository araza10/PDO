<script type="text/javascript">
jQuery(document).ready(function() {
alert("PICASO");
jQuery.ajax({

                    dataType: "json",
                    url: '/${contextPath}/module/interva/iocsvhandler/generateIntervaInput.json',
                    success: function(data) {
                        alert(JSON.stringify(data));
                        }
                    });

});

</script>