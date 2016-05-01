# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.customer-picture')
  .mouseenter ->
    id = $(this).data('customer')
    created = $(this).data('created')
    locality = $(this).data('locality')
    $.ajax
      url: "/customers/#{id}",
      type: "GET",
      dataType: "json"
      success: (data) ->
        console.log(data)
    $(this).popover({
      content: "Located in #{locality}. Member since #{created}",
      placement: "top"})
    $(this).popover('show')

  .mouseleave ->
    $(this).popover('hide')