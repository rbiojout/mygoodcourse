// Turbolinks has changed from version Classics to version 5
// API need to be adapted
// previously we added the jquery-turbolinks that is no more working with version 5
// add this script in this order
// . jquery-turbolinks
// . turbolinks
// . compatibility
// the original file is in the source repository of Turbolinks

var Turbolinks = require("turbolinks");
Turbolinks.start();


var defer, dispatch, handleEvent, loaded, translateEvent;

defer = Turbolinks.defer, dispatch = Turbolinks.dispatch;

handleEvent = function(eventName, handler) {
    return document.addEventListener(eventName, handler, false);
};

translateEvent = function(arg) {
    var from, handler, to;
    from = arg.from, to = arg.to;
    handler = function(event) {
        event = dispatch(to, {
            target: event.target,
            cancelable: event.cancelable,
            data: event.data
        });
        if (event.defaultPrevented) {
            return event.preventDefault();
        }
    };
    return handleEvent(from, handler);
};

translateEvent({
    from: "turbolinks:click",
    to: "page:before-change"
});

translateEvent({
    from: "turbolinks:request-start",
    to: "page:fetch"
});

translateEvent({
    from: "turbolinks:request-end",
    to: "page:receive"
});

translateEvent({
    from: "turbolinks:before-cache",
    to: "page:before-unload"
});

translateEvent({
    from: "turbolinks:render",
    to: "page:update"
});

translateEvent({
    from: "turbolinks:load",
    to: "page:change"
});

translateEvent({
    from: "turbolinks:load",
    to: "page:update"
});

loaded = false;

handleEvent("DOMContentLoaded", function() {
    return defer(function() {
        return loaded = true;
    });
});

handleEvent("turbolinks:load", function() {
    if (loaded) {
        return dispatch("page:load");
    }
});

if (typeof jQuery === "function") {
    jQuery(document).on("ajaxSuccess", function(event, xhr, settings) {
        if (jQuery.trim(xhr.responseText).length > 0) {
            return dispatch("page:update");
        }
    });
}