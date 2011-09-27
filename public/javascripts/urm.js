/* helper for URM2 */

function search_icons_handle(){
 $('.js').bind('ajax:success', function(evt, xhr, status){
  eval(xhr.responseText);
 });
 $('.js').bind('ajax:complete', function(evt, xhr, status){
  $(this).parents('.icon').find('.slider').hide();
  $(this).parents('.icon').find('a').show();
  //$(this).parents('.icons').find('.slider').hide('1000');
 });
 $('.icon .js').bind('ajax:beforeSend', function(evt, xhr, status){
  $(this).parents('.icon').find('a').hide();
  //$(this).parents('.icons').find('.slider').show();
  $(this).parents('.icon').find('.slider').show();
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

function load_dms_bundle(from_where, need_load){
 if(need_load){
  $.getJSON(from_where, "", function(data){
   $("div.dms_loader").hide();
   for(var kk in data){
    $(data[kk]).insertAfter($("tr.item_" + kk).last());
    $("tr.dms_item_" + kk + " th .plus").click(function(){
     var obj = $(this).parents("tr").find("th .icon input.after").first().val();
     //alert("click "+obj+" " + $(this).parents("tr").first().prop("class"));
     $("tr.dms_item_" + obj).remove();
     if($("tr.analog_item_" + obj).add("tr.info_item_" + obj).length == 0){
      $("tr.gap_" + obj).remove();
     }
    });
   }

  });
 }
}

function load_dms(here, id){
 if($("tr.dms_item_" + here).length > 0){
  $("tr.dms_item_" + here).remove();
 }
 var items = $.getJSON("/main/dms?code=" + id + "&after=" + here);
//get items
//- if @items.empty?
 //$("#{escape_javascript(render(:partial => "dms_empty", :locals => {:after => @after}))}").insertAfter($("tr.item_" + here).add("tr.info_item_" + here).last());
//- else
 //$("#{escape_javascript(render(:partial => "dms_header", :locals => {:after => @after}))}").insertAfter($("tr.item_" + here).add("tr.info_item_" + here).last());
 //$("#{escape_javascript(render( :partial => "dms_line", :collection => @items, :locals => {:after => @after}))}").insertAfter($("tr.dms_item_" + here + ".heading").last());
 if($("tr.gap_" + here).length == 0  ){
  //$("#{escape_javascript(render(:partial => "gap_line", :locals => {:after => @after}))}").insertAfter($("tr.dms_item_" + here).add("tr.analog_item_" + here).add("tr.info_item_" + here).last());
 }
 $("tr.dms_item_" + here + " th .plus").click(function(){
 $("tr.dms_item_" + here).remove();
 if($("tr.analog_item_" + here).add("tr.info_item_" + here).length == 0){
  $("tr.gap_" + here).remove();
 }
});

}

function insertGap(after, gap){
 if($("tr.gap_" + after).length == 0){
  var clctn = $("tr.dms_item_" + after).add("tr.info_item_" + after).add("tr.analog_item_" + after);
  if(clctn.length > 0){
   $(gap).insertAfter(clctn.last());
  }
 }
 $("tr.gap_" + after).show();
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
