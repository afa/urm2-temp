function initCalendar(){
 if($(".calendar-input").length > 0){
  $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
 }
}

function takeValToHash(hash, seek, scope){
  var key = $(seek, scope).attr("name"); //TODO: refactor
  hash[key] = $(seek, scope).val();
}
