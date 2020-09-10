$('#add_group').submit(function (event) {
  event.preventDefault();
  
  var $form = $(this),
  group_number = $form.find("input[name='group_number']").val();
  
  $.ajax({
    url: 'samoilov_disp.pl',
    method: 'POST',
    data: {
      class : 'SamoilovGroup',
      event: 'add_group',
      group_number: group_number
    },
    async: false,
    statusCode: {
      404: function () {
        alert('Page not found');
      },
      500: function () {
        alert('Server error');
      }
    },
    success: function (data) {
      $('#result').html(data);
    },
    error: function (data) {
      $('#result').html(data);
    }});
});