$(function() {
  $('[data-toggle=loading]').click(function(){
    $(this).button('loading');
  });

  $("[data-toggle=tooltip]").tooltip();
  
});