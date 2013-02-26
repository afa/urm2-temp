function cartsAddElementToCart(){
 var crts = {};
 $("table.search-products tr:has(input.item-code)").each(function(idx, item){
  var key = $("input.item-code", item).attr("name"); //TODO: refactor
  crts[key] = $("input.item-code", item).val();
  key = $("td.input-in-cart input", item).attr("name");
  crts[key] = $("td.input-in-cart input", item).val();
  key = $("input.item-cart", item).attr("name");
  crts[key] = $("input.item-cart", item).val();
 });
 $("table.search-products tr:has(input.dms-code)").each(function(idx, item){
  var key = $("input.dms-code", item).attr("name"); //TODO: refactor
  crts[key] = $("input.dms-code", item).val();
  key = $("td.input-in-cart input", item).attr("name");
  crts[key] = $("td.input-in-cart input", item).val();
  key = $("input.dms-cart", item).attr("name");
  crts[key] = $("input.dms-cart", item).val();
 });
 $("table.search-products tr:has(input.analog-code)").each(function(idx, item){
  var key = $("input.analog-code", item).attr("name"); //TODO: refactor
  crts[key] = $("input.analog-code", item).val();
  key = $("td.input-in-cart input", item).attr("name");
  crts[key] = $("td.input-in-cart input", item).val();
  key = $("input.analog-cart", item).attr("name");
  crts[key] = $("input.analog-cart", item).val();
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
    alert("sh")
    $(".cart-table").show();
    $("#allow-order").show();
   } else {
    alert("hi")
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
  },
  function(){}
 );
 return false;
}


