$(function() {
  setTimeout(function () {
    var $quickKwkCart = $('#quick_kwk_cart');
    var $sideBar = $('#totals_panel');
    var $broCart = $('#current_cart_panel');

    $quickKwkCart.affix({
      offset: {
        top: 287,
        bottom: 314
      }
    });

    $sideBar.affix({
      offset: {
        top: 235,
        bottom: 314
      }
    });

    $broCart.affix({
      offset: {
        top: 92,
        bottom: 314
      }
    });
  }, 200)
});