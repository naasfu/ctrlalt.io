$(function() {
  // ADD SLIDEDOWN ANIMATION TO DROPDOWN //
  $('.dropdown-toggle').parent().on('show.bs.dropdown', function(e){
    $(this).find('.dropdown-menu').first().stop(true, true).velocity({ opacity: [ 1, 0 ], translateY: [ 0, 20 ], translateZ: 0 }, {display: ["block"], duration: 300})
  });

  // ADD SLIDEUP ANIMATION TO DROPDOWN //
  $('.dropdown-toggle').parent().on('hide.bs.dropdown', function(e){
    $(this).find('.dropdown-menu').first().stop(true, true).velocity({ opacity: [ 0, 1 ]}, {display: ["none"], duration: 200})
  });
});