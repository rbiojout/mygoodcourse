@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor


$ ->
  # start with product_attachments_attributes_0_active'
  #$("[id^='product_attachments_attributes_']").on "click", (event) ->
  $("form :checkbox[id^='product_attachments_attributes_'][id$='active']").on "click", (event) ->
    boxes = $( "form :checkbox[id^='product_attachments_attributes_'][id$='active']" )
    #alert(this)
    #alert (boxes)
    boxes.not(this).prop('checked', false);
    backgroundColor = $(this).data("background-color")
    textColor = $(this).data("text-color")
    paintIt(this, backgroundColor, textColor)


