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
function placeDmsData(data){
 //var row_id = $(this).parents("tr").prop("class").match(/\bitem_(\w+)\b/)[1];
 //var code = $(this).parents("tr").find(".icons input.item-code").val();
 var row_id = data["row_id"];
 var code = data["code"];
 //$.getJSON("/main/dms?code=" + code + "&after=" + row_id, "", function(data){
 $("tr.item_" + row_id + " .icon .slider").hide();
 $("tr.item_" + row_id + " .icon .dms").show().addClass("active");
 if(/^\s*$/.test(data["dms"])){
  $(data["empty"]).insertAfter($("tr.info_item_" + row_id).add("tr.item_" + row_id).last());
  $("tr.item_" + row_id + " .icon .dms").removeClass("active");
 } else {
  $(data["dms"]).insertAfter($("tr.info_item_" + row_id).add("tr.item_" + row_id).last());
  if(!/^\s*$/.test(data["cart"])){
   $(".cart").empty();
   $(data["cart"]).appendTo($(".cart"));
  }
  insertGap(row_id, data["gap"]);
 }
 hide_dms_on_plus_click(row_id);
}
// on-click for dms button
function showDms(evt){
 var row_id = $(this).parents("tr").prop("class").match(/\bitem_(\w+)\b/)[1];
 var code = $(this).parents("tr").find(".icons input.item-code").val();
 $(this).parents(".icon").find(".dms").hide();
 $(this).parents(".icon").find(".slider").show();
 if($("tr.dms_item_" + row_id).length == 0){
  makeAjaxCall("/main/dms?code=" + code + "&after=" + row_id,
   placeDmsData,
   function(data){
    $("tr.item_" + row_id + " .icon .slider").hide();
    $("tr.item_" + row_id + " .icon .dms").show().removeClass("active");
  });
 } else {
  $("tr.dms_item_" + row_id).toggle();
  $("tr.dms_item_" + row_id).toggleClass("hidden");
  toggleGap(row_id);
  $("tr.item_" + row_id + " .icon .slider").hide();
  $("tr.item_" + row_id + " .icon .dms").show();
 }
 evt.preventDefault();
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
  //! $("#order").hide();
  //! $("div.allow-order").show();
  //! $("#order_cancel").hide();
  //! $("div.cart input#cart_item_submit").show();
  //! $("div#cart_store input").add("div#cart_store textarea").add("div#cart_store select").each(function(i, item){ item.disabled = ''; });
  //! $("table.search-products").parents("form").show();
  //! $("#save_cart_button").show();
  //! $(".delete-from-cart").show();
  apply_hover_in_table_on_mmove();
  //handleCartDelete();
  /*$(".delete-from-cart").unbind("click");*/
  return false;
 });


}

function activateSearchAllowOrderButton(){
 $("a#allow_order").click(function(){
  //! $("#order").show();
  //! $("div.allow-order").hide();
  //! $("#order_cancel").show();
  //! $("div.cart input#cart_item_submit").hide();
  //! $("div#cart_store input").add("div#cart_store textarea").add("div#cart_store select").each(function(i, item){ item.disabled = 'disabled'; });
  //! $("table.search-products").parents("form").hide();
  //! $("#save_cart_button").hide();
  //! //$(".delete-from-cart").unbind("click");
  //! $(".delete-from-cart").hide();
  activateSearchCancelButton();
  activateCommit();
  //$("#order .commit.button a.commit-button").bind("click", function(){onSelectSendForm(this); return false;});
  return false;
 });
}

function onSelectSendForm(obj){
 $(obj).parents("form").submit();
}

function runAllowOrder(){
 $('#allow-order .button').click(function(){
  $('#order').show();
  $('#allow-order').hide();
  makeAjaxCall("/orders/new.json",
   function(data){
    alert(data);
    $("#order").html(data["order"]);
    return false;
   },
   function(data){
    $("#order").hide();
    $("#allow-order").show();
  });
 });
}

function ordersTabOnClick(){
 var lst = $(this).parents(".tabbed_box").find(".dialogs .page");
 var tabs = $(this).parents(".tabbed_box").find(".tabs .tab");
 var idx = $(this).parents(".tabbed_box").find(".tabs .tab a").index($(this));
 if(idx == -1){
  return false;
 }
 var page = lst.eq(idx);
 var tab = tabs.eq(idx);
 if(page.hasClass("active")){
  page.removeClass("active");
  tab.removeClass("active");
 } else {
  lst.removeClass("active");
  page.addClass("active");
  tabs.removeClass("active");
  tab.addClass("active");
 }
 return false;
}

function ordersHideInactiveControls(){
 $('tr th.main_options_header').hide();
 $("tr td div.readable-amount").hide();
 $("tr td div.editable-amount").show();
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
 $("tr td div.readable-amount").hide();
 $("tr td div.editable-amount").show();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = ''; });
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
 $("tr td div.readable-amount").show();
 $("tr td div.editable-amount").hide();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = 'disabled'; });
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
 $("tr td div.readable-amount").show();
 $("tr td div.editable-amount").hide();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = 'disabled'; });
 $('tr th.reserve_header').show();
 $("tr td.reserve_data").show();
 $("tr td.reserve_data").each(function(i, item){
  var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][process_qty]"]').eq(0);
  $(item).append('<input type="text" name="' + cp.attr("name") + '" value="' + cp.val()+ '">');
 });
}

function ordersOnClickEnableReserveTransfer(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(3).hasClass("active")){
  return;
 }
 $("tr td div.readable-amount").show();
 $("tr td div.editable-amount").hide();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = 'disabled'; });
}

function ordersOnClickEnableRemoveLines(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(4).hasClass("active")){
  return;
 }
 $("tr td div.readable-amount").show();
 $("tr td div.editable-amount").hide();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = 'disabled'; });
 $('tr th.select_header').show();
 $("tr td.select_data").show();
 $('tr td.select_data input[type="checkbox"]').remove();
 $("tr td.select_data").each(function(i, item){
  var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][line_id]"]').eq(0);
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
 $('input[name^="order["][name$="][qty]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('input[name^="order["][name$="][line_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
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
 $('input:checked[name^="order["][name$="][line_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $(this).parents("form").submit();
}

function ordersRemoveProcess(){
 $("#remove_order a.button-style").click(ordersRemoveOnClick);
}

function ordersReserveOnClick(){
 var curr = this;
 $('input[name^="order["][name$="][line_id]"]').each(function(i, item){ ordersCopyToHidden(item, $(curr)); });
 $('td.reserve_data input[type="text"][name^="order["][name$="][process_qty]"]').each(function(i, item){ if($(item).val().match(/^\d+$/)){ ordersCopyToHidden(item, $(curr));} });
 $(this).parents("form").submit();
}

function ordersReserveProcess(){
 $("#reserve_order a.button-style").click(ordersReserveOnClick);
}

function ordersPickOnClick(){
 var curr = this;
 $('input[name^="order["][name$="][line_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $('td.reserve_data input[type="text"][name^="order["][name$="][process_qty]"]').each(function(i, item){ if($(item).val().match(/^\d+$/)){ ordersCopyToHidden(item, curr);} });
 $(curr).parents("form").submit();
}

function ordersPickProcess(){
 $("#pick_lines a.button-style").click(ordersPickOnClick);
}

//carts
/*(function($){
 $.fn.cart = function(){
  return this.each(function(){
   addElementToCart: function(){
   },
   init: function(){
   }
  });
 };
})(jQuery);*/
function cartsAddElementToCart(){
 if(gon.carts.length == 0){
  $('.cart-table').add('#order').hide();
 }
 $("#cart_store table tr:has(td)").remove();
 $.each(gon.changes, function(idx, item){
  $('table.search-products tr input.item-cart[value="' + item[0] + '"]').val(item[1]);
  $('table.search-products tr input.dms-cart[value="' + item[0] + '"]').val(item[1]);
 });
 if (gon.carts.length > 0){ //empty?
  $("#cart_store table").append(gon.rendered);
  $.each(gon.carts, function(idx, item){
   //$("#cart_store table").append(item.line);
   $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
   $('table.search-products input.dms-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
  });
  $(".cart-table").add("#order").show();
 }
 if($("#cart_store table tr").length >= 1){
  $("#cart_store").show();
 } else {
  $("#cart_store").hide();
 }
 //! $("div#order").hide();
 $("div#order").children().remove();
 $("div#order").append(gon.order);
 $('.select').selectList();
 $('.button-style').button();
 $('.switch').switchControl();
 activateCommit();
 //$('.commit a.button-style').off("click");
 //$('.commit a.button-style').on("click", function(){
 // $(this).parents('form').submit();
 // return false;
 //});
 if($(".calendar-input").length > 0){
  $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
 }
 activateSearchAllowOrderButton();
 //! $("#order").hide();
 //! $("#cancel_order").hide();
 //activateSearchCancelButton();
 //handleCartDelete();
 apply_hover_in_table_on_mmove();
 $('.form-hide .item').dropDown();
 cartsHandleRadioPicks();
 cartsHandleSaveOnFocusLost();
 cartsProcessRadioPicks();
}

function activateCommit(){
 $('.commit a.button-style').off("click");
 $('.commit a.button-style').on("click", function(){
  var frm = $(this).parents('form');
  frm.find("input.copied[type='hidden']").remove();
  var to_copy = frm.find('input.copiable').map(function(i, v){return v.value;});
  if(to_copy.length > 0){
   $.each(to_copy, function(idx, val){$('<input type="hidden" name="' + $(val).attr('name') + '" value="' + $(val).val() + '" class="copied">').appendTo(frm);});
  }
  frm.submit();
  return false;
 });
 //$('.commit:not(.preload) a.button-style').on("click", function(){
 // $(this).parents('form').submit();
 // return false;
 //});
}

//destroy
function cartsRemoveElementFromCarts(){
 //-# $("#cart_store").replaceWith("#{escape_javascript(render :partial => "carts/cart_table", :locals => {:cart => @carts})}");
 $('table.search-products tr:has(td input.item-cart[value="' + gon.deleted + '"])').find("td.input-in-cart").removeClass("exist speed");
 $('table.search-products tr:has(td input.item-cart[value="' + gon.deleted + '"])').find("td.input-in-cart input").val("");
 $('table.search-products tr:has(input.dms-cart[value="' + gon.deleted + '"])').find("td.input-in-cart").removeClass("exist speed");
 $('table.search-products tr:has(input.dms-cart[value="' + gon.deleted + '"])').find("td.input-in-cart input").val("");
 // need? $("table.search-products tr td input.item-cart[value=\"#{@old}\"]").val("#{@new}");

 $("#cart_store table tr:has(td)").remove();
 if (gon.carts.length > 0){ //empty?
  $("#cart_store table").append(gon.rendered);
  $.each(gon.carts, function(idx, item){
   //$("#cart_store table").append(item.line);
   $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
  });
  //$(".cart-table").add(".allow-order").show();
 }
 if($("#cart_store table tr").length > 1){
  $("#cart_store").add("#order").show();
 } else {
  $("#cart_store").add("#order").hide();
 }
 activateSearchCancelButton();
 $("div#order").children().remove();
 $("div#order").append(gon.order);
 //$("div#order").hide();
 //$('.form-hide .item').dropDown();
 activateCommit();
 //$('.commit a.button-style').off("click");
 //$('.commit a.button-style').on("click", function(){
 // $(this).parents('form').submit();
 // return false;
 //});
 cartsHandleRadioPicks();
 cartsHandleSaveOnFocusLost();
 cartsProcessRadioPicks();
}

function cartsSaveCart(){
 $("#cart_store table tr:has(td)").remove();
 if (gon.carts.length > 0){ //empty?
  $("#cart_store table").append(gon.rendered);
  $.each(gon.carts, function(idx, item){
   $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
  });
 }
 if($("#cart_store table tr").length > 1){
  $("#cart_store").add("#order").show();
 } else {
  $("#cart_store").add("#order").hide();
 }
 activateSearchCancelButton();
 $("div#order").children().remove();
 $("div#order").append(gon.order);
 activateCommit();
 //$('.commit a.button-style').off("click");
 //$('.commit a.button-style').on("click", function(){
 // $(this).parents('form').submit();
 // return false;
 //});
 cartsHandleRadioPicks();
 cartsHandleSaveOnFocusLost();
 cartsProcessRadioPicks();


 //$('.form-hide .item').dropDown();
 //! $("div#order").hide();
 //if($(".calendar-input").length > 0){
 // $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
 //}
 //activateSearchCancelButton();
 //activateSearchAllowButton();
 //$('.commit a.button-style').off("click");
 //$('.commit a.button-style').on("click", function(){
 // $(this).parents('form').submit();
 // return false;
 //});
 //$('.select').selectList();
 //$('.button-style').button();
 //$('.switch').switchControl();
 //$('.js').bind('ajax:success', function(evt, xhr, status){
 // eval(xhr.responseText);
 //});
 //cartsHandleRadioPicks();
 //cartsHandleSaveOnFocusLost();
 //cartsProcessRadioPicks();
}

function ordersRenderCreate(){
 $("table.search-products").parents("form").show();
 $("table.search-products tr:has(td)").add("table.search-products tr.heading").remove();
 $("input#search_query_string").val('');
 $("#cart_store table tr:has(td)").remove();
 $("#cart_store table").append(gon.carts);
 $("#cancel_order").hide();
 if(gon.carts.length > 0){
  $(".cart-table").add("#order").show();
 }
 if($("#cart_store table tr").length > 1){
  $("#cart_store").show();
 } else {
  $("#cart_store").hide();
 }
 activateCommit();
 //$('.commit a.button-style').click(function(){
 // $(this).parents('form').submit();
 // return false;
 //});
 $('.select').selectList();
 $('.button-style').button();
 $('.switch').switchControl();
 
 if(gon.redirect_to.length > 0){
  redirectTo("", gon.redirect_to);
 }
 if(gon.results.length > 0){
  placeResults(gon.results); //!!!!!
 }
}

function placeResults(res){
 //place strings into .info .flash, setting timer for 10 secs
 $.each(res, function(i, item){
  $("div#flash_place").append('<div class="flash ' + item.name + '">' + item.value + '</div>').children().hide();
 });
 $("div#flash_place div.flash").slideDown(500).delay(5000).slideUp(500);
}


function redirectTo(title, url){
    // Prepare
    var History = window.History; // Note: We are using a capital H instead of a lower h
    if ( !History.enabled ) {
         // History.js is disabled for this browser.
         // This is because we can optionally choose to support HTML4 browsers or not.
        return false;
    }

    // Bind to StateChange Event
    History.Adapter.bind(window,'statechange',function(){ // Note: We are using statechange instead of popstate
        var State = History.getState(); // Note: We are using History.getState() instead of event.state
        History.log(State.data, State.title, State.url);
    });

    // Change our States
    History.pushState({state:1}, title, url); // logs {state:1}, "State 1", "?state=1"
    History.forward();
    location.reload();
    //History.back(); // logs {state:3}, "State 3", "?state=3"
    //History.back(); // logs {state:1}, "State 1", "?state=1"
    //History.back(); // logs {}, "Home Page", "?"
    //History.go(2); // logs {state:3}, "State 3", "?state=3"

}

function cartsProcessRadioPicks(){
 if($("#cart_store tr.request").length > 0){
  $("#order .item.request textarea").each(function(i, item){ item.disabled = ''; });
 } else {
  $("#order .item.request textarea").each(function(i, item){ item.disabled = 'disabled'; });
 }
 if($("#cart_store tr.world").add("#cart_store tr.store").length > 0){
  $("#order .item.store textarea").each(function(i, item){ item.disabled = ''; });
 } else {
  $("#order .item.store textarea").each(function(i, item){ item.disabled = 'disabled'; });
 }
 if($("#cart_store tr.world").add('#cart_store tr.store:has(input:checked[type="radio"][value="pick"])').length > 0){
  $("#order .item.pick select").add("#order .item.pick input").each(function(i, item){ item.disabled = ''; });
  //$("#order .item.pick textarea").add("#order .item.pick select").each(function(i, item){ item.disabled = ''; });
 } else {
  //$("#order .item.pick textarea").add("#order .item.pick select").each(function(i, item){ item.disabled = 'disabled'; });
  $("#order .item.pick select").add("#order .item.pick input").each(function(i, item){ item.disabled = 'disabled'; });
 }
}

function cartsHandleRadioPicks(){
 $('#cart_store input[type="radio"]').on("click", function(){$("#cart_store form").submit();});
}

function cartsHandleSaveOnFocusLost(){
 $("#cart_store input").add("#cart_store textarea").on("focusout", function(evt){
  $("#cart_store form").submit();
  return false;
 });
}

function quotationsCopyToHidden(item, after){
 $('<input type="hidden" name="' + item.name + '" value="' + $(item).val() + '">').insertAfter($(after));
}

function quotationsHideInactiveControls(){
 $('tr th.main_options_header').hide();
 $("tr td div.readable-amount").hide();
 $("tr td div.editable-amount").show();
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

function quotationsTabOnClick(){
 var lst = $(this).parents(".tabbed_box").find(".dialogs .page");
 var tabs = $(this).parents(".tabbed_box").find(".tabs .tab");
 var idx = $(this).parents(".tabbed_box").find(".tabs .tab a").index($(this));
 if(idx == -1){
  return false;
 }
 var page = lst.eq(idx);
 var tab = tabs.eq(idx);
 if(page.hasClass("active")){
  page.removeClass("active");
  tab.removeClass("active");
 } else {
  lst.removeClass("active");
  page.addClass("active");
  tabs.removeClass("active");
  tab.addClass("active");
 }
 return false;
}

function quotationsSaveOnClick(){
 var curr = this;
 $('input[name^="quotation["][name$="][qty]"]').each(function(i, item){ quotationsCopyToHidden(item, curr); });
 $('input[name^="quotation["][name$="][line_id]"]').each(function(i, item){ quotationsCopyToHidden(item, curr); });
 $('td.main_options_data input[type="text"][name^="quotation["][name$="][note]"]').each(function(i, item){ quotationsCopyToHidden(item, curr); });
 //$('td.main_options_data input[type="text"][name^="quotation["][name$="][requirement]"]').each(function(i, item){ quotationsCopyToHidden(item, curr); });
 //$('textarea[id^="quotation_"][id$="_comment"]').each(function(i, item){ quotationsCopyToHidden(item, curr); });
 $(this).parents("form").submit();
}

function quotationsSaveProcess(){
 $("#save_quotation a.button-style").click(quotationsSaveOnClick);
}

function quotationsCancelOnClick(){
 var curr = this;
 $('input:checked[name^="quotation["][name$="][line_id]"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
 $(this).parents("form").submit();
}

function quotationsCancelProcess(){
 $("#remove_order a.button-style").click(quotationsCancelOnClick);
}

function quotationsOnClickEnableMainOptions(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(0).hasClass("active")){
  return;
 }

 $("tr th.main_options_header").show();
 $("tr td div.readable-amount").hide();
 $("tr td div.editable-amount").show();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = ''; });
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

function quotationsOnClickEnableCancelation(){
 if($(this).parents(".tabbed_box").find(".dialogs .page").eq(1).hasClass("active")){
  return;
 }
 $("tr td div.readable-amount").show();
 $("tr td div.editable-amount").hide();
 $("tr td div.editable-amount input").each(function(i, item){ item.disabled = 'disabled'; });
 $('tr th.reserve_header').show();
 $("tr td.reserve_data").show();
 $("tr td.reserve_data").each(function(i, item){
  var cp = $(item).parents("tr").find('td input[type="hidden"][name^="order["][name*="][line]["][name$="][process_qty]"]').eq(0);
  $(item).append('<input type="text" name="' + cp.attr("name") + '" value="' + cp.val()+ '">');
 });
}

function quotationsTabsProcess(){
 $(".tabbed_box .tabs .tab a#enable_main_options").click(quotationsHideInactiveControls).click(quotationsOnClickEnableMainOptions).click(quotationsTabOnClick);
 $(".tabbed_box .tabs .tab a#enable_cancelation").click(quotationsHideInactiveControls).click(quotationsOnClickEnableCancelation).click(quotationsTabOnClick);
}
