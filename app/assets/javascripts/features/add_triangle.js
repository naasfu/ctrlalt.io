function addTriangle(className, colors) {
  targets = document.getElementsByClassName(className);
  for (i = 0; i < targets.length; i++) {
    target = targets[i];
    if (target != null) {
      var dimensions = target.getClientRects()[0];
      var pattern = Trianglify({
        width: dimensions.width+100,
        height: dimensions.height+50,
        x_colors: colors,
        y_colors: 'match_x',
        cell_size: 100 + Math.random() * 25
      });
      target.style['background-image'] = 'url(' + pattern.png() + ')';
    }
  }
}