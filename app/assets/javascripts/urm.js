/* helper for URM2 */

Array.prototype.getUnique = function () {
 var o = new Object();
 var i, e;
 for (i = 0; e = this[i]; i++) {o[e] = 1};
 var a = new Array();
 for (e in o) {a.push (e)};
 return a;
} 

function makeAjaxCall(ajaxUrl, functionSuccess, functionFailure){
 $.ajax({
  type: "GET",
  url: ajaxUrl,
  contentType: "application/json; charset=utf-8",
  data: {},
  dataType: "json",
  success: functionSuccess,
  error: functionFailure
 });
}

function makeAjaxDestroy(ajaxUrl, functionSuccess, functionFailure){
 $.ajax({
  type: "DELETE",
  url: ajaxUrl,
  contentType: "application/json; charset=utf-8",
  data: {},
  dataType: "json",
  success: functionSuccess,
  error: functionFailure
 });
}

function search_icons_handle(){
 var uniq = new Array();
 var ins = $(".icons input.item-code");
 $.each(ins, function(idx, val){
  uniq.push($(val).val());
 });
 $.each(uniq.getUnique(), function(idx, val){
  $(".icons input[value='" + val + "']:first").parents(".icons").find("div.dms-req:first").addClass("dms").addClass("js");
 });
 $(".dms-req").removeClass("dms-req");
 $('.js').bind('ajax:success', function(evt, xhr, status){
  eval(xhr.responseText);
 });
 $('.js.replacement').add(".js.delivery").bind('ajax:complete', function(evt, xhr, status){
  $(this).parents('.icon').find('.slider').hide();
  $(this).parents('.icon').find('a').show();
 });
 $('.icon .js.replacement').add(".icon .js.delivery").bind('ajax:beforeSend', function(evt, xhr, status){
  $(this).parents('.icon').find('a').hide();
  $(this).parents('.icon').find('.slider').show();
 });
 $(".icon .dms.js").click(showDms);
}

function apply_hover_in_table_on_mmove(){
 var table = $('.table-style');
 $('>tbody>tr:has(>td):not(.sub-row-line)',table).hover(function(){
   $(this).addClass('hover');
  },function(){
   $(this).removeClass('hover');
 });
}

function load_dms_each(need_load){
 if(need_load){
  $(".icon .dms.js").click();
 }
}

function fix_visibility(){
 var hsh = new Array();
 $("tr:has(.dms.js)").each(function(idx, el){
  hsh[$(el).attr("class").match(/\bitem_\w+\b/)] = 1;
 });
 for(var i in hsh){
  $("tr:visible." + i).not(":first").children(".dms.js").hide();
 }
}
function load_dms_bundle(from_where, need_load){
 if(need_load){
  $.getJSON(from_where, "", function(data){
   $("div.dms_loader").hide();
   for(var kk in data){
    $(data[kk]).insertAfter($("tr.item_" + kk).last());
    $("tr.dms_item_" + kk + " th .plus").click(function(){
     var obj = $(this).parents("tr").find("th .icon input.after").first().val();
     //alert("click "+obj+" " + $(this).parents("tr").first().prop("class"));
     $("tr.dms_item_" + obj).hide();
     $("tr.dms_item_" + obj).addClass("hidden");
     if($("tr.analog_item_" + obj).add("tr.info_item_" + obj).not(".hidden").length == 0){
      $("tr.gap_" + obj).hide();
      $("tr.gap_" + obj).addClass("hidden");
     }
    });
   }

  });
 }
}

function toggleGap(after){
 if($("tr.dms_item_" + after).add("tr.info_item_" + after).add("tr.analog_item_" + after).find(":visible").length > 0){
  $("tr.gap_" + after).show();
 } else {
  $("tr.gap_" + after).hide();
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
// on-click for dms button
function showDms(evt){
 var row_id = $(this).parents("tr").prop("class").match(/\bitem_(\w+)\b/)[1];
 var code = $(this).parents("tr").find(".icons input.item-code").val();
 $(this).parents(".icon").find(".dms").hide();
 $(this).parents(".icon").find(".slider").show();
 if($("tr.dms_item_" + row_id).length == 0){
  makeAjaxCall("/main/dms?code=" + code + "&after=" + row_id, function(data){
  //$.getJSON("/main/dms?code=" + code + "&after=" + row_id, "", function(data){
   $("tr.item_" + row_id + " .icon .slider").hide();
   $("tr.item_" + row_id + " .icon .dms").show().addClass("active");
   if(/^\s*$/.test(data["dms"])){
    $(data["empty"]).insertAfter($("tr.info_item_" + row_id).add("tr.item_" + row_id).last());
    $("tr.item_" + row_id + " .icon .dms").removeClass("active");
   } else {
    $(data["dms"]).insertAfter($("tr.info_item_" + row_id).add("tr.item_" + row_id).last());
    insertGap(row_id, data["gap"]);
   }
   //$(data["gap"]).insertAfter($("tr.info_item_" + row_id).add("tr.analog_item_" + row_id).add("tr.dms_item_" + row_id).last());
  }, function(data){
   $("tr.item_" + row_id + " .icon .slider").hide();
   $("tr.item_" + row_id + " .icon .dms").show().removeClass("active");
  });
  return; 
 } else {
  $("tr.dms_item_" + row_id).toggle();
  $("tr.dms_item_" + row_id).toggleClass("hidden");
  toggleGap(row_id);
  /*if($("tr.dms_item_" + row_id).add("tr.analog_item_" + row_id).add("tr.info_item_" + row_id).not(".hidden").length == 0){
   $("tr.gap_" + row_id).hide();
   $("tr.gap_" + row_id).addClass("hidden");
  } else {
   $("tr.gap_" + row_id).show();
   $("tr.gap_" + row_id).removeClass("hidden");
  }*/
   $("tr.item_" + row_id + " .icon .slider").hide();
   $("tr.item_" + row_id + " .icon .dms").show();
 }
 evt.preventDefault();
}

function handleCartDelete(){
 $(".icons .icon .delete-from-cart").click(function(){
  makeAjaxDestroy("/carts/" + $(this).parents("tr").prop("id").match(/\bcart_str_(\w+)\b/)[1], 
   function(data){
    $("#cart_store").replaceWith(data["carts_table"]);
    $("table.search-products tr:has(td input.item-cart[value=\"" + data["old"] + "\"])").find("td.input-in-cart").removeClass("exist speed");
    $("table.search-products tr:has(td input.item-cart[value=\"" + data["old"] + "\"])").find("td.input-in-cart input").val("0");
    $("table.search-products tr td input.item-cart[value=\"" + data["old"] + "\"]").val(data["new"]);

    if(data["carts_empty"]){

    /*- if @carts.empty?*/
     $(".cart-table").add(".allow-order").hide();
    } else {
     $(".cart-table").add(".allow-order").show();
    }
    if($("#cart_store table tr").length > 1){
     $("#cart_store").show();
    } else {
     $("#cart_store").hide();
    }
    $("div#order").hide();

   }, 
   function(data){
   }
  );
 });
}

function insertBlock(blkType, val, after){
 if($("tr." + blkType + "_" + after).length == 0){
  var clctn = $("tr.dms_" + after).add("tr.info_" + after).add("tr.analog_" + after);
  if(clctn.length > 0){
   $(val).insertAfter(clctn.last());
  } else {
   $(val).insertAfter($("tr." + after).last());
  }
 }
 $("tr." + blkType + "_" + after).show();
}

function activateSearchCancelButton(){
 /*$("#order_cancel .button-style").click(function(){*/
 $("#order_cancel").click(function(){
  $("#order").hide();
  $("div.allow-order").show();
  $("#order_cancel").hide();
  $("div.cart input#cart_item_submit").show();
  $("div#cart_store input").add("div#cart_store textarea").each(function(i, item){ item.disabled = ''; });
  $("table.search-products").parents("form").show();
  $("#save_cart_button").show();
  handleCartDelete();
  /*$(".delete-from-cart").unbind("click");*/
  return false;
 });


}

function activateSearchAllowOrderButton(){
 $("a#allow_order").click(function(){
  $("#order").show();
  $("div.allow-order").hide();
  $("#order_cancel").show();
  $("div.cart input#cart_item_submit").hide();
  $("div#cart_store input").add("div#cart_store textarea").each(function(i, item){ item.disabled = 'disabled'; });
  $("table.search-products").parents("form").hide();
  $("#save_cart_button").hide();
  $(".delete-from-cart").unbind("click");
  return false;
 });
}

function onSelectSendForm(obj){
 $(obj).parents("form").submit();
}

function ordersTabOnClick(){
 var lst = $(this).parents(".tabbed_box").find(".dialogs .page");
 var idx = $(this).parents(".tabbed_box").find(".tabs .tab a").index($(this));
 if(idx == -1){
  return false;
 }
 var page = lst.eq(idx);
 if(page.hasClass("active")){
  page.removeClass("active");
  //page.hide();
 } else {
  lst.removeClass("active");
  page.addClass("active");
 }
 return false;
}
function ordersTabsProcess(){
 $(".tabbed_box .tabs .tab a#enable_reserve_lines").click(ordersTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_pick_lines").click(ordersTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_reserve_transfer").click(ordersTabOnClick);
}
