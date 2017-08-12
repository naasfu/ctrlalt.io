Dropzone.autoDiscover = false;

$(function() {
  if ($(".dropzone-images").length > 0) {
    var myDropzone = new Dropzone(".dropzone-images", {
      previewTemplate: $('#preview-template').html(),
      acceptedFiles: 'image/*'
    });
    myDropzone.on("success", function(file, response) {
      $('#images').append(response.image)
    });
  }
});