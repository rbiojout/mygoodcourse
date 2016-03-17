# use of jquery-ui/sortable to order the elements
# we need to have a position in the database for the corresponding model

$ ->
  $('.sortable').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
