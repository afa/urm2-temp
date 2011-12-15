(function($){

 /*-----------------------------------------
  Поле ввода "Добавить в корзину" для таблицы вывода списка продукции
 -----------------------------------------*/
/* $.fn.inputInCart = function(){

  return this.each(function(){

   var cell = $(this), //Ячейка с контроллом
    speedLink = $('.speed-cart-button',cell), //Иконка быстрого оформления заказа
    input = $('input',cell), //Вввод колличества продукции
    countLink = $('.count',cell), //Изменение колличества продукции
    timer = false //Таймер появления иконки быстрого оформления заказа
    //eventBody = true;
    ;
   //Вввод/изменнение колличества продукции в поле ввода
   $('input',cell).blur(function(){
    //eventBody = false;
    var val = $(this).val();
    //if(!$(this).hasClass('invalid') && parseInt(val)>0){
    if($(this).validate({returnIsValid:true}) && parseInt(val)>0){
     countLink.text(val);
     if(settings.controls.inputInCart.speedIconShow){
      cell.addClass('speed');
      if(settings.animation) speedLink.fadeIn(settings.controls.inputInCart.speedIconAnimate); else speedLink.show();
      timer = setTimeout(function(){cell.removeClass('speed').addClass('exist'); speedLink.hide();},settings.controls.inputInCart.speedIconTimeShow);
     }
     else{
      cell.addClass('exist');
     }
    }
    else{
     if(this.value == '0') this.value='';
     cell.removeClass('edit speed');
     speedLink.hide();
     if(timer) clearTimeout(timer);
    }
   })
   .keydown(function(e){ // по нажатию на клавишу Enter
    if(e.keyCode==13){
     $(this).blur();
    }				   
   });

   //Показать поле ввода для изменнения колличества продукции
   countLink.click(function(e){
    cell.removeClass('exist speed').addClass('edit');
    speedLink.hide();
    input.focus().select();
    e.preventDefault();
   });


   if(settings.controls.inputInCart.speedIconShow){

    //Показать иконку быстрого оформления заказа при наведении на ячейку
    cell.hover(function(){
     if(timer) clearTimeout(timer);
     if(cell.hasClass('exist')){
      cell.addClass('speed');
      if(settings.animation) speedLink.fadeIn(settings.controls.inputInCart.speedIconAnimate); else speedLink.show();
     }
    },function(){
     if(cell.hasClass('speed')){
      cell.removeClass('speed').addClass('exist');
      speedLink.hide();
     }
    })
    .click(function(e){e.stopPropagation();});

    //Скрыть иконку быстрого оформления заказа при клике в пустом месте
    /*$('body').click(function(){
     if(eventBody && cell.hasClass('speed')){
      cell.removeClass('speed').addClass('exist');
      speedLink.hide();
     }
     eventBody = true;
    });* /
   }
  });

 };*/
	
	/*-----------------------------------------
	  Выпадающий список
	-----------------------------------------*/
 $.fn.selectList = function(o){

  //Возможно придется в будущем добавить в настойки функцию, которая вызывается при изменении активного пункта
  /* var o = $.extend({
   shange:function(){}
  },o); */

  return this.each(function(){

   var sel = $(this),
    subList = $('.sub',sel),
    input = $('input',sel),
    subLinks = $('a',subList);

   //Активный пункт из списка
   var active = $('a[name|=' + input.eq(0).val()+']');
   if (active.length == 0){
    sel.prepend(subLinks.eq(0).hide().clone().show().addClass('active').addClass("showed"));
    active = $('.active', sel);
   } else {
    sel.prepend(active.eq(0).hide().removeClass('active').clone().show().addClass('active').addClass('showed'));
    active = $('.active', sel);
   }

   input.val(active.get(0).name);

   //Показать/скрыть список
   active.click(function(e){
    subList.toggle();
    sel.toggleClass('hover');
    e.preventDefault();
    return false;
   });

   //Клик в пустом месте закрывает список
   $('body').click(function(){
    subList.hide();
    sel.removeClass('hover');
   });

   //Выбрать пункт из списка
   subLinks.click(function(e){
    input.val(this.name);
    subLinks.show();
    $(this).hide();
    active.attr('name',this.name).text(this.innerHTML);
    subList.hide();
    sel.removeClass('hover');
    e.preventDefault();
    //active.parents("form").eq(0).submit();
   });

  });

 };


 /*-----------------------------------------
   Раскрывающийся блок
 -----------------------------------------*/
 $.fn.dropDown = function(o){

  return this.each(function(){

   var name = $('.name a',$(this)),
    hideBlock = $('.hide',$(this));

   name.click( function(e){
    if(settings.animation){
     hideBlock.slideToggle(settings.controls.dropDown.speed);	
    }else{
     hideBlock.toggle();
    }
    e.preventDefault();
   });


  });

 };


 /*-----------------------------------------
   Стандартная кнопка
 -----------------------------------------*/
 $.fn.button = function(){

  return this.each(function(){

   $(this).mousedown(function(){
    $(this).addClass('click');
   })
   .mouseup(function(){
    $(this).removeClass('click'); 
   });


  });

 };


 /*-----------------------------------------
   Выпадающее меню для стандартной кнопки
 -----------------------------------------*/
 $.fn.buttonMenu = function(){

  return this.each(function(){

   var buttonMenu = $(this),
    button = $('.button-style',buttonMenu),
    subMenu = $('.button-style-sub',buttonMenu);

   button.unbind();

   if( $.browser.msie && $.browser.version < 7){
    subMenu.css('width',button.width());
   }

   buttonMenu.click(function(e){e.stopPropagation()});

   $('body').click(function(){
    buttonMenu.removeClass('hover');
    button.removeClass('hover click');
    subMenu.hide();					 
   });

   button.click(function(e){
    if(buttonMenu.hasClass('hover')){
     buttonMenu.removeClass('hover');
     button.removeClass('hover click');
     subMenu.hide();
    }else{
     buttonMenu.addClass('hover');
     button.addClass('click');
     if(settings.animation) subMenu.slideDown(150); else subMenu.show();
    }
    e.preventDefault();
   });

  });

 };


 /*-----------------------------------------
   Фильтры
 -----------------------------------------*/
 $.fn.switchControl = function(){

  return this.each(function(){

   var switchControl = $(this),
    links = $('a',switchControl);

   //none
   if(switchControl.hasClass('none')) return;

   //radio
   if(switchControl.hasClass('radio')){
    links.click(function(e){
     links.removeClass('active');
     $(this).addClass('active');
     e.preventDefault();
    });
   }

   //check
   if(switchControl.hasClass('check')){
    if($('input[name="' + links.attr("name") + '"]').attr("value") == "1") {
     links.addClass("active");
    } else {
     links.removeClass("active");
    }
    links.click(function(e){
     $(this).toggleClass('active');
     $('input[name="'+ $(this).attr("name") +'"]').attr("value", $(this).hasClass("active") ? '1' : '0');
     e.preventDefault();
    });
    $('input[name="' + links.attr("name") + '"]').watch("disabled", function(e){
     alert("toggled");
     if ($('input[name="'+ $(this).attr("name") +'"]').is(':disabled')) {
      links.addClass('disabled');
     } else {
      links.removeClass('disabled');
     }
     e.preventDefault();
    }, 400);
   }


  });

 };

})(jQuery);

