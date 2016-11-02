inspector =
  selectors: []
  process: (node) ->
    return unless node.querySelectorAll
    for [selector, callback] in @selectors
      for foundNode in node.querySelectorAll(selector)
        callback(foundNode)
  watch: (selector, callback) ->
    @selectors.push([selector, callback])


display_tooltip = (node) ->
  $('.btn-tool[data-toggle="tooltip"]').tooltip()

inspector.watch('.btn-tool[data-toggle="tooltip"]', display_tooltip)

observer = new MutationObserver (mutations) ->
  for mutation in mutations
    inspector.process(mutation.target)
    #for node in mutation.addedNodes
    #  inspector.process(node)

observer.observe document, childList: true, subtree: true, characterData: true


