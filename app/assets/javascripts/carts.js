function cartsAddElementToCart(){
 var crts = {};
 $("table.search-products tr:has(input.item-code)").each(function(idx, item){
  takeValToHash(crts, "input.item-code", item);
  takeValToHash(crts, "td.input-in-cart input", item);
  takeValToHash(crts, "input.item-cart", item);
 });
 $("table.search-products tr:has(input.dms-code)").each(function(idx, item){
  takeValToHash(crts, "input.dms-code", item);
  takeValToHash(crts, "td.input-in-cart input", item);
  takeValToHash(crts, "input.dms-cart", item);
 });
 $("table.search-products tr:has(input.analog-code)").each(function(idx, item){
  takeValToHash(crts, "input.analog-code", item);
  takeValToHash(crts, "td.input-in-cart input", item);
  takeValToHash(crts, "input.analog-cart", item);
 });
 makeAjaxPost("/carts.json", 
  crts,
  function(data, reply, xhr){
   renderErrors(data.error);
   $("#cart_store").remove();
   $.each(data.changes, function(idx, item){
    $('table.search-products tr input.item-cart[value="' + item[0] + '"]').val(item[1]);
    $('table.search-products tr input.dms-cart[value="' + item[0] + '"]').val(item[1]);
    $('table.search-products tr input.analog-cart[value="' + item[0] + '"]').val(item[1]);
   });
   if (data.carts.length > 0){ //empty?
    $(".cart-table .cart").html(data.rendered);
    $.each(data.carts, function(idx, item){
     //$("#cart_store table").append(item.line);
     $('table.search-products input.item-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
     $('table.search-products input.dms-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
     $('table.search-products input.analog-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
    });
   }
   if($("#cart_store table tr").length > 1){
    $(".cart-table").show();
    $("#allow-order").show();
   } else {
    $(".cart-table").hide();
    $("#allow-order").hide();
   }
   $('.select').selectList();
   $('.button-style').button();
   $('.switch').switchControl();
   //activateCommit();
   if($(".calendar-input").length > 0){
    $(".calendar-input").datepicker({ dateFormat: 'yy-mm-dd' });
   }
   activateSearchAllowOrderButton();
   apply_hover_in_table_on_mmove();
   $('.form-hide .item').dropDown();
   cartsHandleRadioPicks();
   cartsHandleSaveOnFocusLost();
   cartsProcessRadioPicks();
   $('#cart_store .icon a.delete').click(cartsRemoveElementFromCarts);
  },
  function(){
   renderErrors({error: 'Ошибка связи'});
  }
 );
 return false;
}

//destroy
function cartsRemoveElementFromCarts(){
 makeAjaxDestroy(this.href,
  function(data, reply, xhr){
   renderErrors(data.error);
   //-# $("#cart_store").replaceWith("#{escape_javascript(render :partial => "carts/cart_table", :locals => {:cart => @carts})}");
   $('table.search-products tr:has(td input.item-cart[value="' + data.deleted + '"])').find("td.input-in-cart").removeClass("exist speed");
   $('table.search-products tr:has(td input.item-cart[value="' + data.deleted + '"])').find("td.input-in-cart input").val("");
   $('table.search-products tr:has(input.dms-cart[value="' + data.deleted + '"])').find("td.input-in-cart").removeClass("exist speed");
   $('table.search-products tr:has(input.dms-cart[value="' + data.deleted + '"])').find("td.input-in-cart input").val("");
   // need? $("table.search-products tr td input.item-cart[value=\"#{@old}\"]").val("#{@new}");
   $("#cart_store").remove();
   if (data.carts.length > 0){ //empty?
    $(".cart-table .cart").html(data.rendered);
    $.each(data.carts, function(idx, item){
     $('table.search-products input.item-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
    });
   }
   if($("#cart_store table tr").length > 1){
    $("#cart_store").add("#allow-order").show();
   } else {
    $("#cart_store").add("#allow-order").hide();
   }
   apply_hover_in_table_on_mmove();
   activateSearchCancelButton();
   //activateCommit();
   cartsHandleRadioPicks();
   cartsHandleSaveOnFocusLost();
   cartsProcessRadioPicks();
   $('#cart_store .icon a.delete').click(cartsRemoveElementFromCarts);
  },
  function(data){
   renderErrors({error: 'Ошибка связи'});
  }
 );
 return false;
}

function cartsSaveCart(){
 var crt = {};
 takeValToHash(crt, "input[name=\"utf8\"]", $(this).parents("form"));
 takeValToHash(crt, "input[name=\"_method\"]", $(this).parents("form"));
 takeValToHash(crt, "input[name=\"authenticity_token\"]", $(this).parents("form"));
 $("input[id^=\"cart_item_\"]", $(this).parents("form")).each(function(idx, item){
  takeValToHash(crt, "#" + item.id, null);
 });
 $("select[id^=\"cart_item_\"]", $(this).parents("form")).each(function(idx, item){
  takeValToHash(crt, "#" + item.id, null);
 });
 $("input[type=\"radio\"][id^=\"radio_cart_item_\"]:checked", $(this).parents("form")).each(function(idx, item){
  takeValToHash(crt, "#" + item.id, $(this).parents("form"));
 });
 makeAjaxPost(
  "/carts/save.json",
  crt,
  function(data, reply, xhr){
   renderErrors(data.error);
   $("#cart_store").remove();
   if (data.carts.length > 0){ //empty?
    $(".cart-table .cart").html(data.rendered);
    $.each(data.carts, function(idx, item){
     $('table.search-products input.item-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
    });
   }
   if($("#cart_store table tr").length > 1){
    $("#cart_store").show();
   } else {
    $("#cart_store").hide();
   }
   cartsHandleRadioPicks();
   cartsHandleSaveOnFocusLost();
   cartsProcessRadioPicks();
   apply_hover_in_table_on_mmove();
   $('#cart_store .icon a.delete').click(cartsRemoveElementFromCarts);

  },
  function(){
   renderErrors({error: 'Ошибка связи'});
  }
 );

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
 return false;
}

function cartsProcessRadioPicks(){
 //if($("#cart_store tr.request").length > 0){
 // $("#order .item.request textarea").each(function(i, item){ item.disabled = ''; });
 //} else {
 // $("#order .item.request textarea").each(function(i, item){ item.disabled = 'disabled'; });
 //}
 //if($("#cart_store tr.world").add("#cart_store tr.store").length > 0){
 // $("#order .item.store textarea").each(function(i, item){ item.disabled = ''; });
 //} else {
 // $("#order .item.store textarea").each(function(i, item){ item.disabled = 'disabled'; });
 //}
 //if($("#cart_store tr.world").add('#cart_store tr.store:has(input:checked[type="radio"][value="pick"])').length > 0){
 // $("#order .item.pick select").add("#order .item.pick input").each(function(i, item){ item.disabled = ''; });
 // //$("#order .item.pick textarea").add("#order .item.pick select").each(function(i, item){ item.disabled = ''; });
 //} else {
 // //$("#order .item.pick textarea").add("#order .item.pick select").each(function(i, item){ item.disabled = 'disabled'; });
 // $("#order .item.pick select").add("#order .item.pick input").each(function(i, item){ item.disabled = 'disabled'; });
 //}
}

function cartsHandleRadioPicks(){
 $('#cart_store input[type="radio"]').on("click", cartsSaveCart);
 //$('#cart_store input[type="radio"]').on("click", function(){$("#cart_store form").submit();});
}

function cartsHandleSaveOnFocusLost(){
 $("#cart_store input").add("#cart_store textarea").on("focusout", cartsSaveCart);
 $("#cart_store select").on("change", cartsSaveCart);
 //$("#cart_store input").add("#cart_store textarea").on("focusout", function(evt){
 // $("#cart_store form").submit();
 // return false;
 //});
}


