# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('.customer-picture')
  .mouseenter ->
    $(this).popover({
      content: "Located in ... Member since ... ? for customer "+$(this).data('customer'),
      placement: "top"})
    $(this).popover('show')
# alert($(this).data('customer'))
  .mouseleave ->
    $(this).popover('hide')