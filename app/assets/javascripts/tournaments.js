$(function() {
  $('.result-input').change(function() {
    var $form = $($(this)[0].form),
        matchID = $form.data('id'),
        inputs = $form.find('.result-input');
        
    console.log(inputs.length);
  });
});