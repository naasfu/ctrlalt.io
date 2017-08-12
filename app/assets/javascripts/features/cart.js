$(function() {
  $('li.dropdown.dropdown-cart a').on('click', function (e) {
    $(this).parent().toggleClass('open');
  });

  $('body').on('click', function (e) {
    if (!$('li.dropdown.dropdown-cart').is(e.target)
      && $('li.dropdown.dropdown-cart').has(e.target).length === 0
      && $('.open').has(e.target).length === 0
    ) {
      $('li.dropdown.dropdown-cart').removeClass('open');
    }
  });
});
