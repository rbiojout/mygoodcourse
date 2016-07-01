var localeErrorMessages = {
    en:
    {
        incorrect_number: "The card number is incorrect.",
        invalid_number: "The card number is not a valid credit card number.",
        invalid_expiry_month: "The card's expiration month is invalid.",
        invalid_expiry_year: "The card's expiration year is invalid.",
        invalid_cvc: "The card's security code is invalid.",
        expired_card: "The card has expired.",
        incorrect_cvc: "The card's security code is incorrect.",
        incorrect_zip: "The card's zip code failed validation.",
        card_declined: "The card was declined.",
        missing: "There is no card on a customer that is being charged.",
        processing_error: "An error occurred while processing the card.",
        rate_limit:  "An error occurred due to requests hitting the API too quickly. Please let us know if you're consistently running into this error."
    },
    fr:
    {
        incorrect_number: "Numéro de carte incorrect.",
        invalid_number: "Numéro de carte invalide.",
        invalid_expiry_month: "Date d'expiration invalide.",
        invalid_expiry_year: "Année d'expiration invalide.",
        invalid_cvc: "Code de sécurité invalide.",
        expired_card: "Carte expirée.",
        incorrect_cvc: "Code de sécurité incorrect.",
        incorrect_zip: "Validation du code postal invalide..",
        card_declined: "Carte refusée.",
        missing: "Cette carte pour ce client.",
        processing_error: "Une erreur est survenue lors du traitement.",
        rate_limit:  "Une erreur est survenue en raison du grand nombre de requêtes. Merci de réessayer."
    }

};


var errorMessages;

$(function() {
    $('[data-numeric]').payment('restrictNumeric');
    $('.cc-number').payment('formatCardNumber');
    $('.cc-exp').payment('formatCardExpiry');
    $('.cc-cvc').payment('formatCardCVC');

    $.fn.toggleInputError = function(erred) {
        this.parent('.form-group').toggleClass('has-error', erred);
        return this;
    };


    var $form = $('#stripe-form');
    var locale_stripe =  $form.data('locale');
    errorMessages = localeErrorMessages[locale_stripe];
    if (typeof (errorMessages) === 'undefined') {
        errorMessages = localeErrorMessages.en
    }

    $form.submit(function(event) {
        event.preventDefault();

        var cardType = $.payment.cardType($('.cc-number').val());
        $('.cc-number').toggleInputError(!$.payment.validateCardNumber($('.cc-number').val()));
        // Disable the submit button to prevent repeated clicks:
        $form.find('.submit').prop('disabled', true);

        // Request a token from Stripe:
        Stripe.card.createToken($form, stripeResponseHandler);

        // Prevent the form from being submitted:
        return false;
    });
});



function stripeResponseHandler(status, response) {
    // Grab the form:
    var $form = $('#stripe-form');

    if (response.error) { // Problem!

        // Show the errors on the form:
        //$form.find('.payment-errors').text(response.error.message);
        $form.find('.payment-errors').text(errorMessages[ response.error.code ]);
        $form.find('.submit').prop('disabled', false); // Re-enable submission

    } else { // Token was created!

        // Get the token ID:
        var token = response.id;

        // Insert the token ID into the form so it gets submitted to the server:
        $form.append($('<input type="hidden" name="stripeToken">').val(token));

        // Submit the form:
        $form.get(0).submit();
    }
};

