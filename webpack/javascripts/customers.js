var display_info, inspector, observer;

inspector = {
    selectors: [],
    process: function(node) {
        var callback, foundNode, i, len, ref, ref1, results, selector;
        if (!node.querySelectorAll) {
            return;
        }
        ref = this.selectors;
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
            ref1 = ref[i], selector = ref1[0], callback = ref1[1];
            results.push((function() {
                var j, len1, ref2, results1;
                ref2 = node.querySelectorAll(selector);
                results1 = [];
                for (j = 0, len1 = ref2.length; j < len1; j++) {
                    foundNode = ref2[j];
                    results1.push(callback(foundNode));
                }
                return results1;
            })());
        }
        return results;
    },
    watch: function(selector, callback) {
        return this.selectors.push([selector, callback]);
    }
};

display_info = function(node) {
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

inspector.watch('.customer-picture', display_info);

observer = new MutationObserver(function(mutations) {
    var i, len, mutation, node, results;
    results = [];
    for (i = 0, len = mutations.length; i < len; i++) {
        mutation = mutations[i];
        results.push((function() {
            var j, len1, ref, results1;
            ref = mutation.addedNodes;
            results1 = [];
            for (j = 0, len1 = ref.length; j < len1; j++) {
                node = ref[j];
                results1.push(inspector.process(node));
            }
            return results1;
        })());
    }
    return results;
});

observer.observe(document, {
    childList: true,
    subtree: true
});