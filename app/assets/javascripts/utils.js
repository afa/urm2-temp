function initCalendar(){
 if($(".calendar-input").length > 0){
  $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
 }
}

function takeValToHash(hash, seek, scope){
  var key = $(seek, scope).attr("name"); //TODO: refactor
  hash[key] = $(seek, scope).val();
}

function processErrors(hash){
 var obj = {
  elem: $('<div class="flash ' + hash.name + '">' + hash.value + '</div>').appendTo("#flash_place"),
  func: function(){
   $(this.elem).remove();
  }
 }
 setTimeout(function(){obj.func.call(obj)}, 10000);
}

