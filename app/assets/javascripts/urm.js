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
 alert("deprecated use cartsRemoveElementFromCart");
 return false;
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
  apply_hover_in_table_on_mmove();
  //handleCartDelete();
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
  activateSearchCancelButton();
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
 } else {
  lst.removeClass("active");
  page.addClass("active");
 }
 return false;
}

function ordersHideInactiveControls(){
 $('tr th.main_options_header').hide();
 $("tr td.main_options_data").hide();
 $('tr th.reserve_header').hide();
 $("tr td.reserve_data").hide();
 $('tr th.select_header').hide();
 $('tr td.select_data').hide();
 $('input[type="checkbox"][name^="order["][name*="][line]["][name$="][selected]"]').remove();
 $('input[type="text"][name^="order["][name*="][line]["][name$="][note]"]').remove();
 $('input[type="text"][name^="order["][name*="][line]["][name$="][requirement]"]').remove();
 $('input[type="text"][name^="order["][name*="][line]["][name$="][process_qty]"]').remove();
}

function ordersOnClickEnableMainOptions(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(0).hasClass("active")){
  return;
 }

 $("tr th.main_options_header").show();
 $("tr td.main_options_data").show();
 $("tr td.main_options_data").each(function(i, item){
  if($(item).hasClass("note-option")){
   var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][note]"]').eq(0);
   $(item).append('<input type="text" name="' + cp.attr("name") + '" value="' + cp.val()+ '">');
  }
  if($(item).hasClass("requirement-option")){
   var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][requirement]"]').eq(0);
   $(item).append('<input type="text" name="' + cp.attr("name") + '" value="' + cp.val()+ '">');
  }
 });

}

function ordersOnClickEnableReserveLines(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(1).hasClass("active")){
  return;
 }
 $('tr th.reserve_header').show();
 $("tr td.reserve_data").show();
 $("tr td.reserve_data").each(function(i, item){
  var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][process_qty]"]').eq(0);
  $(item).append('<input type="text" name="' + cp.attr("name") + '" value="' + cp.val()+ '">');
 });
}

function ordersOnClickEnablePickLines(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(2).hasClass("active")){
  return;
 }
 $('tr th.reserve_header').show();
 $("tr td.reserve_data").show();
 $("tr td.reserve_data").each(function(i, item){
  var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][process_qty]"]').eq(0);
  $(item).append('<input type="text" name="' + cp.attr("name") + '" value="' + cp.val()+ '">');
 });
}

function ordersOnClickEnableReserveTransfer(){
}

function ordersOnClickEnableRemoveLines(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(2).hasClass("active")){
  return;
 }
 $('tr th.select_header').show();
 $("tr td.select_data").show();
 $("tr td.select_data").each(function(i, item){
  var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][item_id]"]').eq(0);
  $(item).append('<input type="checkbox" name="' + cp.attr("name") + '" value="1">');
 });
}

function ordersTabsProcess(){
 $(".tabbed_box .tabs .tab a#enable_main_options").click(ordersHideInactiveControls).click(ordersOnClickEnableMainOptions).click(ordersTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_reserve_lines").click(ordersHideInactiveControls).click(ordersOnClickEnableReserveLines).click(ordersTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_pick_lines").click(ordersHideInactiveControls).click(ordersOnClickEnablePickLines).click(ordersTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_reserve_transfer").click(ordersHideInactiveControls).click(ordersOnClickEnableReserveTransfer).click(ordersTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_remove_lines").click(ordersHideInactiveControls).click(ordersOnClickEnableRemoveLines).click(ordersTabOnClick);
}

function ordersCollectLines(){

}

function ordersCopyToHidden(item, after){
 $('<input type="hidden" name="' + item.name + '" value="' + $(item).val() + '">').insertAfter($(after));
}

function ordersSaveOnClick(){
 var curr = this;
 $('input[name^="order["][name$="][item_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('td.main_options_data input[type="text"][name^="order["][name$="][note]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('td.main_options_data input[type="text"][name^="order["][name$="][requirement]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('textarea[id^="order_"][id$="_comment"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $(this).parents("form").submit();
}

function ordersSaveProcess(){
 $("#save_order a.button-style").click(ordersSaveOnClick);
}

function ordersRemoveOnClick(){
 var curr = this;
 $('input:checked[name^="order["][name$="][item_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $(this).parents("form").submit();
}

function ordersRemoveProcess(){
 $("#remove_order a.button-style").click(ordersRemoveOnClick);
}

function ordersReserveOnClick(){
 var curr = this;
 $('input[name^="order["][name$="][item_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('td.reserve_data input[type="text"][name^="order["][name$="][process_qty]"]').each(function(i, item){ if($(item).val().match(/^\d+$/)){ ordersCopyToHidden(item, curr);} });
 $(this).parents("form").submit();
}

function ordersReserveProcess(){
 $("#reserve_order a.button-style").click(ordersReserveOnClick);
}

function ordersPickOnClick(){
 var curr = this;
 $('input[name^="order["][name$="][item_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('td.reserve_data input[type="text"][name^="order["][name$="][process_qty]"]').each(function(i, item){ if($(item).val().match(/^\d+$/)){ ordersCopyToHidden(item, curr);} });
 $(curr).parents("form").submit();
}

function ordersPickProcess(){
 $("#pick_lines a.button-style").click(ordersPickOnClick);
}

//carts
function cartsAddElementToCart(){
 if(gon.carts.length == 0){
  $('.cart-table').add('.allow-order').hide();
 }
 $("#cart_store table tr:has(td)").remove();
 $.each(gon.changes, function(idx, item){
  $('table.search-products tr input.item-cart[value="' + item[0] + '"]').val(item[1]);
 });
 if (gon.carts.length > 0){ //empty?
  $.each(gon.carts, function(idx, item){
   $("#cart_store table").append(item.line);
   //$('table.search-products tr.item_' + item.offer_code + ' td.input-in-cart input[type="text"][name="items[' + item.line_code + '][amount]"]').val(item.amount);
   $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
  });
//  $("#cart_store table").append("#{ escape_javascript(render :partial => "carts/cart_line", :collection => @carts) }");
  $(".cart-table").add(".allow-order").show();
 }
 if($("#cart_store table tr").length >= 1){
  $("#cart_store").show();
 } else {
  $("#cart_store").hide();
 }
 $("div#order").hide();
 $("div#order").children().remove();
 $("div#order").append(gon.order);
 alert("process");
 $('.select').selectList();
 $('.button-style').button();
 $('.switch').switchControl();
 if($(".calendar-input").length > 0){
  $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
 }
 $("#order").hide();
 activateSearchAllowOrderButton();
 $("#cancel_order").hide();
 activateSearchCancelButton();
 //handleCartDelete();
 apply_hover_in_table_on_mmove();
 $('.form-hide .item').dropDown();
}

//destroy
function cartsRemoveElementFromCarts(){
 //-# $("#cart_store").replaceWith("#{escape_javascript(render :partial => "carts/cart_table", :locals => {:cart => @carts})}");
 $('table.search-products tr:has(td input.item-cart[value="' + gon.deleted + '"])').find("td.input-in-cart").removeClass("exist speed");
 $('table.search-products tr:has(td input.item-cart[value="' + gon.deleted + '"])').find("td.input-in-cart input").val("");
 // need? $("table.search-products tr td input.item-cart[value=\"#{@old}\"]").val("#{@new}");

 $("#cart_store table tr:has(td)").remove();
 if (gon.carts.length > 0){ //empty?
  $.each(gon.carts, function(idx, item){
   $("#cart_store table").append(item.line);
   $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
  });
  //$(".cart-table").add(".allow-order").show();
 }
 if($("#cart_store table tr").length > 1){
  $("#cart_store").add(".allow-order").show();
 } else {
  $("#cart_store").add(".allow-order").hide();
 }
 activateSearchCancelButton();
 $("div#order").children().remove();
 $("div#order").append(gon.order);
 $("div#order").hide();
 $('.form-hide .item').dropDown();
}

function cartsSaveCart(){
 $("#cart_store table tr:has(td)").remove();
 if(gon.carts.length == 0){
  $('.cart-table').add('.allow-order').hide();
 }
 if (gon.carts.length > 0){ //empty?
  $.each(gon.carts, function(idx, item){
   $("#cart_store table").append(item.line);
   $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
  });
 }

 if($("#cart_store table tr").length > 1){
  $("#cart_store").show();
  $(".cart-table").add(".allow-order").show();
 } else {
  $("#cart_store").hide();
 }
 $("div#order").children().remove();
 $("div#order").append(gon.order);
 $("div#order").hide();
 if($(".calendar-input").length > 0){
  $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
 }
 activateSearchCancelButton();
 $('.commit a.button-style').click(function(){
  $(this).parents('form').submit();
  return false;
 });
 $('.select').selectList();
 $('.form-hide .item').dropDown();
 $('.button-style').button();
 $('.switch').switchControl();
 $('.js').bind('ajax:success', function(evt, xhr, status){
  eval(xhr.responseText);
 });
}
