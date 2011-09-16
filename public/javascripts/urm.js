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
