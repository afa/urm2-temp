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


