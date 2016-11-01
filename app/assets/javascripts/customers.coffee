# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


display_info = (thisdoc)->
  $('.customer-picture')
  .mouseenter ->
    id = $(this).data('customer')
    created = $(this).data('created')
    locality = $(this).data('locality')
    # no need to get the object
    # all relevant data is already in the call
    #$.ajax
    #  url: "/fr/customers/#{id}",
    #  type: "GET",
    #  dataType: "json"
    #  success: (data) ->
    #    console.log(data)
    $(this).popover({
      content: "#{locality}. #{created}",
      placement: "bottom"})
    $(this).popover('show')

  .mouseleave ->
    $(this).popover('hide')

# initiate the mouse over with the first elements
$(document).ready ->
  display_info($.document)





