$(document).ready(function() {
    $(document).bind('ajaxError', 'form.ajax_form', function(event, jqxhr, settings, exception) {
        if (jqxhr.status === 401) {
            window.location = '/customers/sign_in?locale=' + I18n_locale;
        }
        console.log(jqxhr.responseText);
        $(event.data).render_form_errors($.parseJSON(jqxhr.responseText));
    });
});

(function($) {
    $.fn.modal_success = function() {
        this.modal('hide');
        this.find('form input[type="text"]').val('');
        this.clear_previous_errors();
    };
    $.fn.render_form_errors = function(errors) {
        var $form, model;
        $form = this;
        console.log(errors);
        this.clear_previous_errors();
        model = this.data('model');
        $.each(errors, function(field, messages) {
            var $input;
            $input = $form.find('input, select, textarea').filter(function() {
                var name;
                name = $(this).attr('name');
                if (name) {
                    return name.match(new RegExp(model + '\\[' + field + '\\(?'));
                }
            });
            $input.closest('.form-group').addClass('has-error').find('.help-block').html(messages.join(' & '));
        });
    };
    $.fn.clear_previous_errors = function() {
        $('.form-group.has-error', this).each(function() {
            $('.help-block', $(this)).html('');
            $(this).removeClass('has-error');
        });
    };
    $.fn.clear_form_fields = function() {
        return this.find(':input', '#myform').not(':button, :submit, :reset, :hidden').val('').removeAttr('checked').removeAttr('selected');
    };
})(jQuery);