$('#add_group').submit(function (event) {
  event.preventDefault();
  var str = $(this).serialize();
  $.ajax({
    type: "POST",
    url: "samoilov_disp.pl",
    data: str,
    success: function(){
      $.ajax({
        type: "POST",
        url: "samoilov_disp.pl",
        data: { class: "SamoilovGroup", event: "show_group_content"},
        success: function(html){
          $('.content').html(html);

          $('.counts_span_input').text((i, val) => +val + 1);
          $('.counts_span_button').text((i, val) => +val + 1);
          $('.counts_span_input').css('display', 'inline');
          $('.counts_span_button').css('display', 'inline');

          $('.counts_span_dropdown').text($('.counts_span_input').text());
          $('.counts_span_button').css('display', 'inline');
  
        }
      });
    }
  });
  return false;
});