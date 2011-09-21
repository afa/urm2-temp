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
    $(data[kk]).insertAfter($("tr." + kk).last());
    $("tr.dms_" + kk + " th .plus").click(function(){
     alert("click "+kk+" " + $(this));
     $("tr.dms_" + kk).remove();
     if($("tr.analog_" + kk).add("tr.info_" + kk).length == 0){
      $("tr.gap_" + kk).remove();
     }
    });
   }

  });
 }
}

function insertGap(after, gap){
 if($("tr.gap_" + after).length == 0){
  var clctn = $("tr.dms_" + after).add("tr.info_" + after).add("tr.analog_" + after);
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
