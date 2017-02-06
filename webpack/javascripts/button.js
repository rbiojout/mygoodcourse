var display_tooltip, inspector, observer;

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

display_tooltip = function(node) {
    return $('.btn-tool[data-toggle="tooltip"]').tooltip();
};

inspector.watch('.btn-tool[data-toggle="tooltip"]', display_tooltip);

observer = new MutationObserver(function(mutations) {
    var i, len, mutation, results;
    results = [];
    for (i = 0, len = mutations.length; i < len; i++) {
        mutation = mutations[i];
        results.push(inspector.process(mutation.target));
    }
    return results;
});

observer.observe(document, {
    childList: true,
    subtree: true,
    characterData: true
});