
$(function(){
  //get height for 2
  var barHeight = $('#pairing_sidebar').height();
  var bar2Height = $('.tab-pane').height();
  var col2Height = barHeight + bar2Height;
  //set height for 1
  $('#player_sidebar').height(col2Height);
});