$ ->
  #$('ul.nav-left-ml').toggle()
  $('label.nav-toggle span').click ->
    $(this).parent().parent().children('ul.nav-left-ml').toggle 300
    cs = $(this).attr('class')
    if cs == 'nav-toggle-icon glyphicon glyphicon-chevron-right'
        $(this).removeClass('glyphicon-chevron-right').addClass 'glyphicon-chevron-down'
    if cs == 'nav-toggle-icon glyphicon glyphicon-chevron-down'
        $(this).removeClass('glyphicon-chevron-down').addClass 'glyphicon-chevron-right'
    return

# ---
# generated by js2coffee 2.1.0