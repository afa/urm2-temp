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
    alert(kk);
    $(data[kk]).insertAfter($("tr.item_" + kk).last());
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


