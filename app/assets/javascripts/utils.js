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
 if(hash === undefined){
  return;
 }
 var els = [];
 var idx = 0;
 alert('' + hash.keys);
 for(var i in hash.keys){
  els[idx] = $('<div class="flash ' + i + '">' + hash[i] +'</div>').appendTo("#flash_place");
  idx += 1;
 }
 var obj = {
  elem: els,
  func: function(){
   $.each(this.elem, function(it, cur){ cur.remove();});
  }
 }
 setTimeout(function(){obj.func.call(obj)}, 10000);
}

function renderErrors(arr){
 if(arr === undefined){
  return;
 }
 $.each(arr, function(i, item){
  processErrors(item);
 });
}
