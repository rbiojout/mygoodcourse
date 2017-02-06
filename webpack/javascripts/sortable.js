$(function() {
    $('.sortable').sortable({
        axis: 'y',
        handle: '.handle',
        update: function() {
            return $.post($(this).data('update-url'), $(this).sortable('serialize'));
        }
    });
    return $(".sortgrid").sortable({
        handle: ".thumbnail",
        appendTo: $(''),
        update: function() {
            return $.post($(this).data('update-url'), $(this).sortable('serialize'));
        }
    });
});