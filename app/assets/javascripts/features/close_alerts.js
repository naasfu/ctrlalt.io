function closeAlerts(delay) {
  window.setTimeout(function () {
    $('#notifications .alert').alert('close');
  }, delay)
}