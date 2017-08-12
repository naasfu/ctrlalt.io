$(function() {

  // Trigger overlay via data-toggle attribute
  $(document).on('click', '[data-toggle="overlay-loader"]', function() {
    var cog = '<svg class="loader-icon" version="1.1"  xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="96px" height="96px" viewBox="0 0 96 96" enable-background="new 0 0 96 96" xml:space="preserve"><path d="M96,52.354v-8.707c-2.684-1.239-8.48-2.291-15.873-3.083c-0.83-3.604-2.253-6.973-4.156-10.017 c4.67-5.79,8.026-10.636,9.049-13.41l-6.156-6.158c-2.774,1.022-7.62,4.379-13.41,9.049c-3.044-1.904-6.413-3.326-10.016-4.157 c-0.793-7.394-1.845-13.189-3.084-15.874h-8.707c-1.239,2.685-2.292,8.48-3.084,15.874c-3.834,0.885-7.414,2.425-10.607,4.516 c-3.861-2.894-7.967-5.852-12.818-9.41l-6.156,6.158c3.557,4.851,6.515,8.957,9.408,12.818c-2.215,3.383-3.837,7.188-4.689,11.281 C10.928,41.921,5.938,42.732,0,43.646v8.708c5.938,0.914,10.928,1.726,15.699,2.408c0.853,4.094,2.475,7.898,4.689,11.281 c-2.894,3.861-5.852,7.969-9.408,12.819l6.156,6.156c4.852-3.557,8.958-6.515,12.818-9.408c3.384,2.216,7.189,3.838,11.282,4.689 c0.684,4.771,1.495,9.762,2.409,15.699h8.707c0.914-5.938,1.726-10.928,2.408-15.699c3.859-0.804,7.453-2.307,10.689-4.33 c5.791,4.67,10.636,8.026,13.41,9.049l6.158-6.156c-1.022-2.774-4.381-7.621-9.05-13.411c1.903-3.044,3.326-6.413,4.156-10.016 C87.52,54.645,93.316,53.592,96,52.354z M48,72c-13.255,0-24-10.745-24-24c0-13.255,10.745-24,24-24s24,10.745,24,24 C72,61.255,61.255,72,48,72z"/></svg>'

    var overlay = '<div style="display: none;" id="loader" class="overlay-loader">'
                  + '<div class="loader-background"></div>' 
                    + cog 
                + '</div>'
    
    $('.overlay-loader').remove();
    $('#totals_panel').append(overlay);
    // $('.overlay-loader').velocity('transition.expandIn', 250);
    $('.overlay-loader')
      .velocity({ 
        opacity: [ 1, 0 ], 
        transformOriginX: [ "50%", "50%" ], 
        transformOriginY: [ "50%", "50%" ], 
        scaleX: [ 1, 0.40 ], 
        scaleY: [ 1, 0.40 ], 
        translateZ: 0 
      }, {
        duration: 500,
        display: "block"
      });

    // $('.loader-icon').velocity('transition.slideDownBigIn', 500);
    $('.loader-icon').velocity({
      opacity: [ 1, 0 ], 
      translateY: [ 0, -250 ], 
      translateZ: 0 
    }).velocity({ rotateZ: 300 }, { loop: true, duration: 1000 }).velocity("reverse");
  });

  // Remove the overlay on click (just incase)
  $(document).on('click', '.overlay-loader', function() {
    $(this).remove();
  });

  // Remove the overlay anytime a modal is opened
  $(window).on('shown.bs.modal', function (e) {
    $('.overlay-loader').remove(); 
  })
});