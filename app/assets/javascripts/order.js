function ordersRenderCreate(){
 var frm = {};
 var prnt = $(this).parents("form");
 takeValToHash(frm, "input[name=\"utf8\"]", prnt);
 takeValToHash(frm, "input[name=\"authenticity_token\"]", prnt);
 $("select[id^=\"use_sale_\"]", prnt).each(function(idx, item){
  takeValToHash(frm, '#' + item.id, null);
 });
 $("textarea[name^=\"order_comment\"]", prnt).each(function(idx, item){
  takeValToHash(frm, 'textarea[name^="' + item.name + '"]', null);
 });
 takeValToHash(frm, "select[id=\"delivery_type\"]", prnt);
 takeValToHash(frm, "input[name=\"date_picker\"]", prnt);
 takeValToHash(frm, "textarea[name=\"comment\"]", prnt);
 makeAjaxPost('/orders.json',
  frm,
  function(data, reply, xhr){
   $("table.search-products").parents("form").show();
   $("table.search-products tr:has(td)").add("table.search-products tr.heading").remove();
   $("input#search_query_string").val('');
   $("#cart_store").remove();
   $(".cart-table .cart").html(data.carts);
   $("#cancel_order").hide();
   //if($("#cart_store tr:has(td)").length > 1){
   // $(".cart-table").add("#order").show();
   //}
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
 
   if(data.redirect_to){
    redirectTo("", data.redirect_to);
   }
   if(data.results.length > 0){
    placeResults(data.results); //!!!!!
   }
  },
  function(){}
 );
 return false;
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


