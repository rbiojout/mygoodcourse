# example of usage
#
#<div id="catalog-products" class="row">
# ...
#</div>
#     <div id="infinite-scrolling-products" class="row">
#        <%# will_paginate(@products, :renderer => 'BootstrapPaginationHelper::LinkRenderer') %>
#      </div>
#</div>
##### and add corresponding js
#
#$('#catalog-products').append('...);
# ...
#
#<# if @products.next_page %>
#$('#infinite-scrolling-products .pagination').replaceWith('...');
#<# else %>
#$(window).off('scroll');
#$('#infinite-scrolling-products .pagination').remove();
#<# end %>

# display more reviews when displaying the reviews of a customer
# $ ->
document.addEventListener 'turbolinks:load', ->
  if $('#infinite-scrolling-reviews').length > 0
    $(window).on 'scroll', ->
      more_reviews_url = jQuery('#infinite-scrolling-reviews .pagination a.next').attr('href')
      if more_reviews_url && $(window).scrollTop() > $('#infinite-scrolling-reviews').offset().top  $(window).height()  60
#$('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $('#infinite-scrolling-reviews .pagination').text("Please Wait...");
        $.getScript more_reviews_url
        # update the dom for mouse over of the new elements
        # display_info($.document)
      return
    return

# display more products when displaying the catalog of products
# $ ->
document.addEventListener 'turbolinks:load', ->
  if $('#infinite-scrolling-products').size() > 0
    $(window).on 'scroll', ->
      more_products_url = $('#infinite-scrolling-products .pagination a.next').attr('href')
      #if more_products_url && $(window).scrollTop() > $(document).height()  $(window).height()  60
      #if more_products_url && $(window).scrollTop() > $('#infinite-scrolling-products').offset().top  60 -100
      if more_products_url && $(window).scrollTop() > $('#infinite-scrolling-products').offset().top  $(window).height()  60
#$('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $('#infinite-scrolling-products .pagination').text("Please Wait...");
        $.getScript more_products_url
      return
    return

# display more posts when displaying the index of posts
# $ ->
document.addEventListener 'turbolinks:load', ->
  if $('#infinite-scrolling-posts').size() > 0
    $(window).on 'scroll', ->
      more_posts_url = $('#infinite-scrolling-posts .pagination a.next').attr('href')
      if more_posts_url && $(window).scrollTop() > $('#infinite-scrolling-posts').offset().top  $(window).height()  60
#$('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />')
        $('#infinite-scrolling-posts .pagination').text("Please Wait...");
        $.getScript more_posts_url
      return
    return 