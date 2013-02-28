function dms_item_hide(obj){
 //$("tr.item_" + obj + " td.icons div.icon div.dms").removeClass('active');
 $("tr.dms_item_" + obj).hide();
 $("tr.dms_item_" + obj).addClass("hidden");
 if($("tr.analog_item_" + obj).add("tr.info_item_" + obj).not(".hidden").length == 0){
  $("tr.gap_" + obj).hide();
  $("tr.gap_" + obj).addClass("hidden");
 }
}

function hide_dms_on_plus_click(obj_id){
 $("tr.dms_item_" + obj_id + " th .plus").click(function(){
  var obj = $(this).parents("tr").find("th .icon input.after").first().val();
  dms_item_hide(obj);
  //e.preventDefaults();
  return false;
 });
}

function load_dms_bundle(from_where, need_load){
 if(need_load){
  $.getJSON(from_where, "", function(data){
   $("div.dms_loader").hide();
   for(var kk in data){
    $(data[kk]).insertAfter($("tr.item_" + kk).last());
    $("tr.item_" + kk + " .icon .dms").addClass("active");
    hide_dms_on_plus_click(kk);
   }

  },
  function(){
   $("div.dms_loader").hide();
  });
 }
}


