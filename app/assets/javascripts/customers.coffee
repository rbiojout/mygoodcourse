# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


inspector =
  selectors: []
  process: (node) ->
    return unless node.querySelectorAll
    for [selector, callback] in @selectors
      for foundNode in node.querySelectorAll(selector)
        callback(foundNode)
  watch: (selector, callback) ->
    @selectors.push([selector, callback])


display_info = (node) ->
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

inspector.watch('.customer-picture', display_info)

observer = new MutationObserver (mutations) ->
  for mutation in mutations
    for node in mutation.addedNodes
      inspector.process(node)

observer.observe document, childList: true, subtree: true






