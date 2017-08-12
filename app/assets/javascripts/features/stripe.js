$(function() {
  $('#new_payment_card').submit(function(event) {
    var form = $(this);

    form.find('button').value = 'Processing...';
    form.find('button').prop('disabled', true);

    if ( !Stripe.card.validateCardNumber(number) ) {
      Stripe.createToken(form, stripeResponseHandler);
      return false;
    } else {
      form.find('button').value = 'Pay now';
      form.find('button').prop('disabled', false);
      return false
    }
  });

  function stripeResponseHandler(status, response) {
    var form = $('#new_payment_card');
    if (response.error) {
      $('#notifications').html(
        '<div class="alert alert-error fade in"><button class="close" data-dismiss="alert"><i class="fa fa-times"></i></button>'
        + response.error.message 
        + '</div>'
      );

      form.find('button').value = 'Pay now';
      form.find('button').prop('disabled', false);
    } else {
      var token = response.id;
      form.append($('<input type="hidden" name="stripeToken">').val(token));
      form.get(0).submit();
    }
  }
});
