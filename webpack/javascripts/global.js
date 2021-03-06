require('es6-promise').polyfill();
// jQuery is imported as a Global
require('expose-loader?$!expose-loader?jQuery!expose-loader?jquery!jquery');

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
// require('jquery-dotdotdot/src/jquery.dotdotdot');
require('./lib/jquery-dotdotdot.js')

// parallax effect
import Stellar from './lib/jquery-stellar.js';



// position of the mouse on the screen
require('jquery-waypoints/waypoints');

// bootstrap
require('bootstrap-sass/assets/javascripts/bootstrap.js');

// usage of moment in i18n context
require('moment');
require('moment/locale/fr');

// calendars for bootstrap
// see options at http://eonasdan.github.io/bootstrap-datetimepicker/Options/
require('eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min.js');
$(function () {
    $('.datetimepicker').datetimepicker();
});


// require('./datetimepicker.js');
// require('bootstrap-datetime-picker');

// WYSIWYG Summernote
// some links to bootstrap js needed
window.CodeMirror = require('codemirror/lib/codemirror.js');
require('codemirror/lib/codemirror.js');
// require('codemirror/lib/codemirror.css');
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

// social buttons
require('./lib/social-share-button.js');

// require('./observer.js');
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
// require('./material-kit/material.js');
// require('./material-kit/material-kit.js');
//import {materialKit, materialKitDemo} from './material-kit/material-kit.js';
//window.materialKit = require('./material-kit/material-kit.js').materialKit;
//window.materialKitDemo = require('./material-kit/material-kit.js').materialKitDemo;

//require('./material-kit/material-kit.js');
//require('./material-kit/material-kit.js');
// require('./material-kit/material-kit.js');
// var materialKit = require('./material-kit/material-kit.js').materialKit;
// var materialKitDemo = require('./material-kit/material-kit.js').materialKitDemo;
//var materialKitDemo = require('./material-kit/material-kit.js');


// console.log(window.materialKit);

// turbolinks
// require('jquery-turbolinks');
// var Turbolinks = require("turbolinks");
// Turbolinks.start();
// require('./compatibility.js');

// import './global.scss';




$(function(){
    $.stellar({
        horizontalScrolling: false,
        verticalOffset: 40
    });
});


// we have all actions in this function regarding
// the initial state : $(document).ready
// the refresh after an Ajax call : $( document ).ajaxComplete
const prepare_pop = function(){
    // prepare tooltips and popovers
    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();
    $('img.customer-picture').mouseenter(function() {
        var created, id, locality;
        id = $(this).data('customer');
        created = $(this).data('created');
        locality = $(this).data('locality');
        $(this).popover({
            content: "<span class='fa fa-map-marker'></span> " + locality + "<br/><span class='fa fa-calendar'></span> " + created,
            html: true,
            placement: "bottom"
        });
        return $(this).popover('show');
    }).mouseleave(function() {
        return $(this).popover('hide');
    });
};

$(document).ready(function() {
    window.setTimeout((function() {
        $('.alert-flash').fadeTo(500, 0).slideUp(500, function() {
            $(this).remove();
        });
    }), 4000);
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

    // attach small WYSIWYG
    $('.wysiwyg-small').summernote({
        lang: I18n_locale,
        toolbar: [
            // [groupName, [list of button]]
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['font', ['strikethrough', 'superscript', 'subscript']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
        ],
        height: '200px'
    });

    // prepare tooltips and popovers
    prepare_pop();
    // prepare tooltips and popovers

});

$( document ).ajaxComplete(function() {
    //$( ".log" ).text( "Triggered ajaxComplete handler." );
    // prepare tooltips and popovers
    prepare_pop();
});


