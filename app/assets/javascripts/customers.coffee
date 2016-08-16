# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


display_info = (thisdoc)->
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
      content: "#{locality}. #{created}",
      placement: "bottom"})
    $(this).popover('show')

  .mouseleave ->
    $(this).popover('hide')

# initiate the mouse over with the first elements
$(document).ready ->
  display_info($.document)


# display more comments
$ ->
  if $('#infinite-scrolling-comments').size() > 0
    $(window).on 'scroll', ->
      more_comments_url = $('#infinite-scrolling-comments .pagination a.next').attr('href')
      if more_comments_url && $(window).scrollTop() > $('#infinite-scrolling-comments').offset().top - $(window).height() - 60
  #$('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $('#infinite-scrolling-comments .pagination').text("Please Wait...");
        $.getScript more_comments_url
        # update the dom for mouse over of the new elements
        display_info($.document)
      return
    return