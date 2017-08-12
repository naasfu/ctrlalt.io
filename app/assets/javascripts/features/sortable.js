$(function() {
  // Tables
  $(".sortable").sortable({
    opacity: 0.8,
    tolerance: "pointer",
    handle: ".move",
    axis: "y",
    update: function(e) {
      $("[data-toggle=tooltip]").tooltip('enable');
      return $.post($(this).data("update-url"), $(this).sortable("serialize"));
    }
  }).disableSelection();

  // Tables
  $(".sortable-table").sortable({
    opacity: 0.8,
    tolerance: "pointer",
    handle: ".move",
    axis: "y",
    helper: function(e, ui) {
      ui.children().each(function() {
        return $(this).width($(this).width());
      });
      return ui;
    },
    update: function(e) {
      $("[data-toggle=tooltip]").tooltip('enable');
      return $.post($(this).data("update-url"), $(this).sortable("serialize"));
    }
  }).disableSelection();

  // Block grids (images)
  $('.sortable-block-grid').sortable({
    opacity: 0.8,
    tolerance: "pointer",
    handle: ".move",
    update: function() {
      return $.post($(this).data("update-url"), $(this).sortable("serialize"));
    }
  }).disableSelection();
});

