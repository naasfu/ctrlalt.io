$(function() {
  $('.ghost.animated').velocity({
    translateY: [0, -15]}, 
    { 
      loop: true, 
      duration: 900 
    });
  $('.ghost-shadow.animated').velocity({
      scaleX: [1, 0.95], 
      scaleY: [1, 0.95], 
      transformOriginX: [ "50%", "50%" ], 
      transformOriginY: [ "50%", "50%" ]
    },
    { 
      loop: true, 
      duration: 900 
    });
});