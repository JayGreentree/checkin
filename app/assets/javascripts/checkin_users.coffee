$ ->
  $("#rapid-checkin-form .result-explanation").slideDown( "slow" )

# TODO: js tabs w/ current way as fallback
# Filter results client side; hiding rows will resize cols
# this prevents that.
#$ ->
#  $('#checkin-users-nav a').click (e) ->
#    $('table#checkin-users-table th').each ->
#      $(this).css('width', $(this).css('width'))
#    $('#checkin-users-table .warning').css( "display","none" )
