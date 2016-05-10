@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor


jQuery ->
  if $('#infinite-scrolling-products').size() > 0
    $(window).on 'scroll', ->
      more_products_url = $('#infinite-scrolling-products .pagination a.next').attr('href')
      #if more_products_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60
      #if more_products_url && $(window).scrollTop() > $('#infinite-scrolling-products').offset().top - 60 -100
      if more_products_url && $(window).scrollTop() > $('#infinite-scrolling-products').offset().top - $(window).height() - 60
        #$('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $('#infinite-scrolling-products .pagination').text("Please Wait...");
        #alert('eee');
        $.getScript more_products_url
      return
    return

  if $('#infinite-scrolling-comments').size() > 0
    $(window).on 'scroll', ->
      more_comments_url = $('#infinite-scrolling-comments .pagination a.next').attr('href')
      if more_comments_url && $(window).scrollTop() > $('#infinite-scrolling-comments').offset().top - $(window).height() - 60
#$('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $('#infinite-scrolling-comments .pagination').text("Please Wait...");
        $.getScript more_comments_url
      return
    return

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





