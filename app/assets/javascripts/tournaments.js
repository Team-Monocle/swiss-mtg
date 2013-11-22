$(function() {
  $('.result-input').change(function() {
    var $form = $($(this)[0].form),
        matchID = $form.data('id'),
        inputs = $form.find('.result-input');
        
    // console.log(inputs.length);
    // console.log($(inputs[1]).val());
    if(($(inputs[0]).val() != "-") && ($(inputs[0]).val() != -1)){
      if($(inputs[1]).val() != "-"){
        if($(inputs[2]).val() != "-"){
          var valuesToSubmit = $($form).serialize();
          $.post($($form).attr('action'), valuesToSubmit, function(){
            // console.log("Probably a success, guys");
            $form.parent().parent().css("background-color", "grey");
            var pathName = window.location.pathname;
            $("#buttonHouse").load(pathName + " #buttonHouse");
            // $("#buttonHouse").hide();
          });
          return false;
        };
      };
    };

    if($(inputs[0]).val() == "-" || $(inputs[0]).val() == -1){
      $form.parent().parent().css("background-color", "white");
    };
  });
});