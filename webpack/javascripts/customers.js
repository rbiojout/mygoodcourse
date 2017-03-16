
// info for customer
var display_info = function(node) {
    return $('.customer-picture').mouseenter(function() {
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

// The node to be monitored
var target = document;

// Create an observer instance
var contentobserver = new MutationObserver(function( mutations ) {
    mutations.forEach(function( mutation ) {
        var newNodes = mutation.addedNodes; // DOM NodeList
        if( newNodes !== null ) { // If there are new nodes added
            var $nodes = $( newNodes ); // jQuery set
            $nodes.each(function() {
                var $node = $( this );
                console.log(" - -- - -"+$node)
                if( $node.hasClass( "customer-picture" ) ) {
                    $node.display_info
                }
            });
        }
    });
});

// Configuration of the observer:
var config = {
    attributes: true,
    childList: true,
    characterData: true
};

// Pass in the target node, as well as the observer options
contentobserver.observe(target, config);


$('body').tooltip({
    selector: '[rel=tooltip]'
});

$('body').popover({
    selector: '[rel=popover]',
    trigger: 'hover',
    html: true,
    content: function () {
        return "<span class='fa fa-map-marker'></span> " + "locality" + "<br/><span class='fa fa-calendar'></span> " + "created";
    }
});

$(document).ready(function(){
    // $('[data-toggle="popover"]').popover({trigger: 'hover', html: true,});
    $('[data-toggle="popover"]').display_info();
});