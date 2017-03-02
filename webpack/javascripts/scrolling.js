// used by animate.css
function onScrollInit(items, trigger) {
    items.each(function () {
        var osElement = $(this),
            osAnimationClass = osElement.attr('data-os-animation'),
            osAnimationDelay = osElement.attr('data-os-animation-delay');

        osElement.css({
            '-webkit-animation-delay': osAnimationDelay,
            '-moz-animation-delay': osAnimationDelay,
            'animation-delay': osAnimationDelay
        });


        var trigger = $(this).parents('.os-animation-container');

        var osTrigger = ( trigger.length > 0 ) ? trigger : osElement;


        osTrigger.waypoint(function () {
            osElement.addClass('animated').addClass(osAnimationClass);
        }, {
            triggerOnce: true,
            offset: '50%'
        });
    });
};

// class for animation: .os-animation
// class for parent if stagged animations: .os-animation-container

$(document).ready(function() {

    if ($('.os-animation').length > 0) {
        onScrollInit($('.os-animation', null));
    }

});
// example of usage
//
//<div id="catalog-products" class="row">
// ...
//</div>
//<div id="infinite-scrolling-products" class="row">
//        <%# will_paginate(@products, :renderer => 'BootstrapPaginationHelper::LinkRenderer') %>
//      </div>
//</div>
// and add corresponding js
//
//$('#catalog-products').append('...);
// ...
//
//<# if @products.next_page %>
//$('#infinite-scrolling-products .pagination').replaceWith('...');
//<# else %>
//$(window).off('scroll');
//$('#infinite-scrolling-products .pagination').remove();
//<# end %>
// display more reviews when displaying the reviews of a customer

$(document).ready(function() {
    if ($('#infinite-scrolling-reviews').length > 0) {
        $(window).on('scroll', function() {
            var more_reviews_url;
            more_reviews_url = jQuery('#infinite-scrolling-reviews .pagination a.next').attr('href');
            if (more_reviews_url && $(window).scrollTop() > ( $("#infinite-scrolling-reviews").offset().top - $(window).height() - 60 )) {
                $('#infinite-scrolling-reviews .pagination').text("Please Wait...");
                $.getScript(more_reviews_url);
            }
        });
    }
});

$(document).ready(function() {
    if ($('#infinite-scrolling-products').size() > 0) {
        $(window).on('scroll', function() {
            var more_products_url;
            more_products_url = $('#infinite-scrolling-products .pagination a.next').attr('href');
            if (more_products_url && $(window).scrollTop() > ( $('#infinite-scrolling-products').offset().top - $(window).height()- 60)) {
                $('#infinite-scrolling-products .pagination').text("Please Wait...");
                $.getScript(more_products_url);
            }
        });
    }
});

$(document).ready(function() {
    if ($('#infinite-scrolling-posts').size() > 0) {
        $(window).on('scroll', function() {
            var more_posts_url;
            more_posts_url = $('#infinite-scrolling-posts .pagination a.next').attr('href');
            if (more_posts_url && $(window).scrollTop() > ( $('#infinite-scrolling-posts').offset().top - $(window).height() - 60)) {
                $('#infinite-scrolling-posts .pagination').text("Please Wait...");
                $.getScript(more_posts_url);
            }
        });
    }
});