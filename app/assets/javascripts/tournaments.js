$(function() {
  $('.result-input').change(function() {
    var $form = $($(this)[0].form),
        matchID = $form.data('id'),
        inputs = $form.find('.result-input');
        
    // console.log(inputs.length);
    // console.log($(inputs[1]).val());
    if($(inputs[0]).val() != "-"){
      if($(inputs[1]).val() != "-"){
        if($(inputs[2]).val() != "-"){
          var valuesToSubmit = $($form).serialize();
          $.post($($form).attr('action'), valuesToSubmit, function(){
            console.log("Probably a success, guys");
          });
          return false;
        };
      };
    };
  });
});