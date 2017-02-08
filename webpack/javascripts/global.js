// jQuery is imported as a Global
require('expose?$!expose?jQuery!expose?jquery!jquery');

// unobstructive javascript
require('jquery-ujs');
// jquery user interactions
// adjust import of css in the global css file accordingly to imports of jQueryUI
require('jquery-ui/ui/core');
require('jquery-ui/ui/widget');
require('jquery-ui/ui/widgets/sortable');

require('jquery-ui/ui/widgets/mouse');

// to solve the problems of touch in jQuery UI
// need to be imported AFTER jQueryUI
// and before the first usage
require('jquery-ui-touch-punch');

// uploader file
// require('jquery-file-upload');

// ellipsis for the text to long
// use the src as the file name is not correct
// and there is a potential issue with 'jQuery' name against 'jquery'
require('jquery-dotdotdot/src/jquery.dotdotdot');

// parallax effect
require('stellar');

// position of the mouse on the screen
require('jquery-waypoints/waypoints');

// bootstrap
require('bootstrap-sass/assets/javascripts/bootstrap.js');

// usage of moment in i18n context
require('moment');
require('moment/locale/fr');

// calendars for bootstrap
require('bootstrap-datetime-picker');

// WYSIWYG Summernote
// some links to bootstrap js needed
require('summernote/dist/summernote');
// locale for summernote
require('./summernote-fr.js');

// star rating system
require('bootstrap-star-rating/js/star-rating.js');
require('bootstrap-star-rating/js/locales/fr.js');
// added, not in Bower
//= require star-rating_locale_fr.js
//= require star-rating_locale_es.js

// geocomplete with jquery for GoogleMap
require('geocomplete/jquery.geocomplete.js');

// cocoon to add/remove via javascript associated childs
require('./lib/cocoon.js');

// turbolinks
require('jquery-turbolinks');
var Turbolinks = require("turbolinks");
Turbolinks.start();
require('./compatibility.js');

require('./button.js');
require('./customers.js');
require('./geocoding.js');
require('./google_analytics.js');
require('./form_error.js');
// import './home.js';
require('./jquery-payment.js');
require('./jquery-waypoints.js');
require('./scrolling.js');
require('./sortable.js');
require('./stripe-payment.js');

// require('material-kit-free/assets/js/material-kit');

// import './global.scss';

console.log("Hello the world!");

$(document).on('turbolinks:load', function() {
    window.setTimeout((function() {
        $('.alert-flash').fadeTo(500, 0).slideUp(500, function() {
            $(this).remove();
        });
    }), 4000);
});

document.addEventListener('turbolinks:load', function() {
    // attach event for ellipsis
    $('.ellipsis').dotdotdot({
        watch: "window"
    });

    // attach event for WYSIWYG
    $('.summernote').summernote({
        lang: I18n_locale,
        // adjust initial height for the Summernote Editor
        height: '200px'
    });
});

