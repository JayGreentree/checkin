

# TODO: js tabs w/ current way as fallback
# Filter results client side; hiding rows will resize cols
# this prevents that.
#$ ->
#  $('#checkin-users-nav a').click (e) ->
#    $('table#checkin-users-table th').each ->
#      $(this).css('width', $(this).css('width'))
#    $('#checkin-users-table .warning').css( "display","none" )

# TODO: rows lose color after clicked to reveal details

# N.B.: inner-detail-wrapper exists so inner divs don't slide down
# individually.

detailFormatter = ( row, td_len ) ->
  html = []
  html.push('<td class="labels"><div>' + row[0] + '</div></td>')
  html.push('<td colspan="' + td_len + '">' +
                '<div class="inner-detail-wrapper">'
                    'Contact: ' + row[3] + '@andrew.cmu.edu<br/>'
                    'Roommate: ' + row[9] + '<br/>'
                    'Counsellors:<br/>'
                    row[8] + ''
                '<div>' +
            '</td>')
  html.join('')

$ ->
  $("#rapid-checkin-form .result-explanation").slideDown( "slow" )

  $("table").on("click-row.bs.table", (e,row,element) ->
    element.toggleClass("detail-view-parent")
    element.find('td').toggleClass("bg-primary")
    element.removeClass("danger")

    if (element.next().is('tr.detail-view'))
      element.next('tr.detail-view').find('div').slideUp("fast", ->
        $(this).parent().parent().remove()
      )
    else
      element.after('<tr class="detail-view"><div><button type="button" class="close" data-dismiss="detail-view" aria-label="Close"><span aria-hidden="true">&times;</span></button>' + detailFormatter(row,element.find('td').length) + '</div></tr>')
      element.next('tr.detail-view').find('div').slideDown()
      element.next('tr.detail-view').find('button.close').on("click", ->
        $("table").trigger("click-row.bs.table",[row,element])
      )
)
