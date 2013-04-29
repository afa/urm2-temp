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

function makeAjaxPost(ajaxUrl, dataHash, functionSuccess, functionFailure){
 $.ajax({
  type: "POST",
  url: ajaxUrl,
  //contentType: "application/json; charset=utf-8",
  data: $.param(dataHash),
  dataType: "json",
  processData: false,
  success: functionSuccess,
  error: functionFailure
 });
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

function toggleGap(after){
 if($("tr.dms_item_" + after).add("tr.info_item_" + after).add("tr.analog_item_" + after).find(":visible").length > 0){
  $("tr.gap_" + after).show();
 } else {
  $("tr.gap_" + after).hide();
 }
}

function placeInfoData(data){
 var row_id = data["row_id"];
 var code = data["code"];
 renderErrors(data.error);
 if(/^\s*$/.test(data["info"])){
  $(data["empty"]).insertAfter($("tr.item_" + row_id).last());
 } else {
  $(data["info"]).insertAfter($("tr.item_" + row_id).last());
  /*if(!/^\s*$/.test(data["cart"])){
   $(".cart").empty();
   $(data["cart"]).appendTo($(".cart"));
  }*/
  insertGap(row_id, data["gap"]);
 }
 //return false;
}

function showInfo(evt){
 var row_id = $(this).parents("tr").prop("class").match(/\bitem_(\w+)\b/)[1];
 if($("tr.info_item_" + row_id).length == 0){
  makeAjaxCall(this.href,    //"/main/info?code=" + code + "&after=" + row_id,
   placeInfoData,
   function(data){
   renderErrors([{error: 'Ошибка связи'}]);
    //$("tr.item_" + row_id + " .icon .slider").hide();
    //$("tr.item_" + row_id + " .icon .dms").show().removeClass("active");
  });
 } else {
  $("tr.info_item_" + row_id).toggle();
  $("tr.info_item_" + row_id).toggleClass("hidden");
  toggleGap(row_id);
  //$("tr.item_" + row_id + " .icon .slider").hide();
  //$("tr.item_" + row_id + " .icon .dms").show();
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
    renderErrors(data.error);
    $("#order").html(data["order"]);
    initCalendar();
    $("#cart_store .icon").hide();
    $("#cart_store textarea").add("#cart_store input").add("#cart_store select").each(function(idx, item){
     $(item).attr("disabled", 'disabled');
    });
    $("form:has(table.search-products)").hide();
    //activateCommit();
    cartsProcessRadioPicks();
    $(".button#make_order").click(ordersRenderCreate);
    $("div.button#cancel_order a").click(function(){
     $("#order").empty();
     $("#cart_store .icon").show();
     $("#cart_store textarea").add("#cart_store input").add("#cart_store select").removeAttr("disabled");
     $('#allow-order').show();
     $("form:has(table.search-products)").show();
     event.preventDefault();
    });
   },
   function(data){
   renderErrors([{error: 'Ошибка связи'}]);
    $("#order").hide();
    $("#allow-order").show();
  });
  event.preventDefault();
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
 $('select[id^="order_"][id$="_application_area_id"]').each(function(i, item){ ordersCopyToHidden(item, curr); });
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
