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
   for(var kk in data.dms){
    $(data.dms[kk]).insertAfter($("tr.item_" + kk).last());
    $("tr.item_" + kk + " .icon .dms").addClass("active");
    hide_dms_on_plus_click(kk);
   }
   $("#cart_store").remove();
   $(".cart-table .cart").html(data.cart);
   if($("#cart_store table tr").length > 1){
    $(".cart-table").show();
    $("#allow-order").show();
   } else {
    $(".cart-table").hide();
    $("#allow-order").hide();
   }
   apply_hover_in_table_on_mmove();
   cartsHandleRadioPicks();
   cartsHandleSaveOnFocusLost();
   cartsProcessRadioPicks();
   $('#cart_store .icon a.delete').click(cartsRemoveElementFromCarts);
   
  },
  function(){
   $("div.dms_loader").hide();
  });
 }
}

function insertGap(after, gap){
 var clctn = $("tr.dms_item_" + after).add("tr.info_item_" + after).add("tr.analog_item_" + after);
 if($("tr.gap_" + after).length == 0){
  if(clctn.length > 0){
   $(gap).insertAfter(clctn.last());
  }
 }
 toggleGap(after);
}

function placeDmsData(data){
 var row_id = data["row_id"];
 var code = data["code"];
 $("tr.item_" + row_id + " .icon .slider").hide();
 $("tr.item_" + row_id + " .icon .dms").show().addClass("active");
 if(/^\s*$/.test(data["dms"])){
  $(data["empty"]).insertAfter($("tr.info_item_" + row_id).add("tr.item_" + row_id).last());
  $("tr.item_" + row_id + " .icon .dms").removeClass("active");
 } else {
  $(data["dms"]).insertAfter($("tr.info_item_" + row_id).add("tr.item_" + row_id).last());
  insertGap(row_id, data["gap"]);
 }
 $("#cart_store").remove();
 if(!/^\s*$/.test(data["cart"])){
  $(".cart-table .cart").html(data.cart);
 }
 hide_dms_on_plus_click(row_id);
}

function placeAnalogData(data){
 var row_id = data["row_id"];
 var code = data["code"];
 if(/^\s*$/.test(data["analogs"])){
  $(data["empty"]).insertAfter($("tr.item_" + row_id).last());
 } else {
  $(data["hdr"]).add(data["analogs"]).insertAfter($("tr.item_" + row_id).last());
  if(!/^\s*$/.test(data["cart"])){
   $(".cart").empty();
   $(data["cart"]).appendTo($(".cart"));
  }
  insertGap(row_id, data["gap"]);
 }
 $("#cart_store").remove();
 if(!/^\s*$/.test(data["cart"])){
  $(".cart-table .cart").html(data.cart);
 }
 //return false;
}

function showAnalog(evt){
 var row_id = $(this).parents("tr").prop("class").match(/\bitem_(\w+)\b/)[1];
 if($("tr.analog_item_" + row_id).length == 0){
  makeAjaxCall(this.href,    //"/main/info?code=" + code + "&after=" + row_id,
   placeAnalogData,
   function(data){
    //$("tr.item_" + row_id + " .icon .slider").hide();
    //$("tr.item_" + row_id + " .icon .dms").show().removeClass("active");
  });
 } else {
  $("tr.analog_item_" + row_id).toggle();
  $("tr.analog_item_" + row_id).toggleClass("hidden");
  toggleGap(row_id);
  //$("tr.item_" + row_id + " .icon .slider").hide();
  //$("tr.item_" + row_id + " .icon .dms").show();
 }
 evt.preventDefault();
}


