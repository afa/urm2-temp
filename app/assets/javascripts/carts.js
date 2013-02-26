function takeValToHash(hash, seek, scope){
  var key = $(seek, scope).attr("name"); //TODO: refactor
  hash[key] = $(seek, scope).val();
}
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
    //$('.cart-table').add('#order').hide();
   $("#cart_store").remove();
   $.each(data.changes, function(idx, item){
    $('table.search-products tr input.item-cart[value="' + item[0] + '"]').val(item[1]);
    $('table.search-products tr input.dms-cart[value="' + item[0] + '"]').val(item[1]);
   });
   if (data.carts.length > 0){ //empty?
    $(".cart-table .cart").html(data.rendered);
    $.each(data.carts, function(idx, item){
     //$("#cart_store table").append(item.line);
     $('table.search-products input.item-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
     $('table.search-products input.dms-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
    });
    //$(".cart-table").add("#order").show();
   }
   if($("#cart_store table tr").length >= 1){
    $(".cart-table").show();
    $("#allow-order").show();
   } else {
    $(".cart-table").hide();
    $("#allow-order").hide();
   }
   //! $("div#order").hide();
   //$("div#order").children().remove();
   //$("div#order").append(gon.order);
   //? need form processing? :TODO:
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
   $('#cart_store .icon a.delete').click(cartsRemoveElementFromCarts);
  },
  function(){}
 );
 return false;
}

//destroy
function cartsRemoveElementFromCarts(){
 makeAjaxDestroy(this.href,
  function(data, reply, xhr){
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
     //$("#cart_store table").append(item.line);
     $('table.search-products input.item-cart[value="' + item.id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
    });
    //$(".cart-table").add(".allow-order").show();
   }
   if($("#cart_store table tr").length > 1){
    $("#cart_store").add("#order").add("#allow-order").show();
   } else {
    $("#cart_store").add("#order").add("#allow-order").hide();
   }
   apply_hover_in_table_on_mmove();
   activateSearchCancelButton();
   activateCommit();
   cartsHandleRadioPicks();
   cartsHandleSaveOnFocusLost();
   cartsProcessRadioPicks();
   $('#cart_store .icon a.delete').click(cartsRemoveElementFromCarts);
  },
  function(data){}
 );
 return false;
}


