$('#delete_group').submit(function (event) {
  event.preventDefault();
  var str = $(this).serialize();
  $.ajax({
    type: "POST",
    url: "samoilov_disp.pl",
    data: str
  });
  return false;
});