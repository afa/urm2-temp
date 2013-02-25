function cartsAddElementToCart(){
 var crts = new Array;
 $("table.search-products tr:has(input.item-code)").each(function(idx, item){
  var key = $("input.item-code", item).attr("name");
  crts[key] = $("input.item-code", item).val();
  alert(key);
  alert(crts[key]);
  key = $("td.input-in-cart input", item).attr("name");
  crts[key] = $("td.input-in-cart input", item).val();
  alert(key);
  alert(crts[key]);
  key = $("input.item-cart", item).attr("name");
  crts[key] = $("input.item-cart", item).val();
  alert(key);
  alert(crts[key]);
 });
 alert(crts.length);
 makeAjaxPost("/carts.json", 
  crts,
  function(data, reply, xhr){
   if(data.carts.length == 0){
    $('.cart-table').add('#order').hide();
    $("#cart_store table tr:has(td)").remove();
    $.each(data.changes, function(idx, item){
     $('table.search-products tr input.item-cart[value="' + item[0] + '"]').val(item[1]);
     $('table.search-products tr input.dms-cart[value="' + item[0] + '"]').val(item[1]);
    });
    if (data.carts.length > 0){ //empty?
     $("#cart_store table").append(data.rendered);
     $.each(data.carts, function(idx, item){
      //$("#cart_store table").append(item.line);
      $('table.search-products input.item-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
      $('table.search-products input.dms-cart[value="' + item.obj_id +'"]').parents("tr").find('td.input-in-cart input[type="text"]').val(item.amount);
     });
     $(".cart-table").add("#order").show();
    }
   }
   if($("#cart_store table tr").length >= 1){
    $("#cart_store").show();
    $("#allow-order").show();
   } else {
    $("#cart_store").hide();
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


