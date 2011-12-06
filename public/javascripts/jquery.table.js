(function($){
		  
	$(function(){
			   
		/*-----------------------------------------
		  Горизонтальный скроллинг таблицы
		-----------------------------------------*/
		window.tableScroller = {
			scroller: $('.scroller-table'),
			scrollContentWidth: $('.scroll-content-width'),
			page: $('.all'),
			off: false,
			maxWidth: 0,
			check: function(){
				if($(window).width()<1000){ 
					this.page.addClass('table-scroll-additional');
					this.off = true;
				}else{
					this.page.removeClass('table-scroll-additional');
					this.off = false;
				}
			},
			addTable: function(wrapperTable){
				if(wrapperTable.hasClass('scroll')){
					var tableBlock = $('.table-block',wrapperTable);
					var tableScr = $('.table-scrolling',wrapperTable);
					var table = $('.table-style',wrapperTable);
					
					// Обнуляем скролл
					$(window).bind('load.scroll',function(){tableBlock.scrollLeft(0);});
					
					// Если ширина максимальной таблицы не вычислена
					if(!this.maxWidth){
						
						var tableBlockWidth = tableBlock.width();
						
						// Ищем максимальную ширину таблицы
						$('.table-navigation-block.scroll .table-style').each(function(){
							var width = $(this).width();
							if(width > tableScroller.maxWidth) tableScroller.maxWidth = width;
						});
						
						// Ширина контента в полосе прокрутки
						this.scrollContentWidth.css('width',(this.maxWidth+tableBlockWidth*0.04)+'px');
						
						// Если скролл необходим - показываем его
						if( tableBlockWidth < this.maxWidth){ this.scroller.show(); }else{ this.scroller.hide(); }
					}
					
					// Если ширина текущей таблицы меньше максимальной
					if(table.width() < this.maxWidth) tableScr.width(this.maxWidth);
					
					// Событие прокрутки таблицы
					this.scroller.bind('scroll',function(){
						tableBlock.scrollLeft($(this).scrollLeft());
					});
				}
			},
			// Обновление параметров скроллинга
			refresh: function(){
				this.check();
				if(!this.off){
					this.maxWidth = 0;
					this.scrollContentWidth.width(0);
					this.scroller.unbind('scroll');
					$(window).unbind('load.scroll');
					this.scroller.scrollLeft(0);
					$('.table-navigation-block.scroll').each(function(){
						tableScroller.addTable($(this));
					});
				}
			}
		};
		
		// При ресайзе обновляем параметры скроллинга
		$(window).resize(function(){
			tableScroller.refresh();
		});

	});

		  
	$.fn.table = function(){
		
		return this.each(function(){
			
			var mainWrapper = $(this);
			var container = $('.table-scrolling',mainWrapper);
			var table = $('.table-style',mainWrapper);
			
			// Активная строка в таблице
			$('>tbody>tr:has(>td):not(.sub-row-line)',table).hover(function(){
				$(this).addClass('hover');
			},function(){
				$(this).removeClass('hover');
			});
			
			/*// Пагинация
			$('.table-pagination a',mainWrapper).click(function(e){
				// Подгружаем новую таблицу, ссылка для запроса хранится в href
				e.preventDefault();
			});*/
			
			/*-----------------------------------------
			  События для корзины (в попапе и на отдельной странице)
			-----------------------------------------*/
			if(table.hasClass('cart') || table.hasClass('cart-min')){
			
				// Удалить из корзины
				$('.delete-from-cart',table).click(function(e){
					$(this).parents('tr:first').remove();
					if(!table.find('td').size()) table.remove();
					e.preventDefault();
				});
			
			}
			
			/*-----------------------------------------
			  Выделение строк
			-----------------------------------------*/
			if(table.hasClass('order-list') || table.hasClass('order-one')){
				$('th.check-product input:checkbox',table).click(function(){
					if($(this).attr('checked')) $('td.check-product input:checkbox',table).attr('checked','checked');
						else $('td.check-product input:checkbox',table).removeAttr('checked');
				});
			
			}
			
			/*-----------------------------------------
			  События для заказа
			-----------------------------------------*/
			if(table.hasClass('order-one')){
			
				// Удалить из заказа
				$('.delete-from-order',table).click(function(e){
					$(this).parents('tr:first').remove();
					if(!table.find('td').size()) table.remove();
					e.preventDefault();
				});
			
			}
			
			/*-----------------------------------------
			  События для вывода списка продукции
			-----------------------------------------*/
			if(table.hasClass('search-products')){
				
				//Поле ввода "Добавить в корзину" для таблицы вывода списка продукции
				//$('.input-in-cart',table).inputInCart();
				
				// Нумерация строк
				//table.find('tr').each(function(index){
				//	$(this).addClass('product'+index);
				//	$(this).attr('product',index);
				});
				
				//Выпадающий блок с ценой конечного потребителя
				$('.full-price a').lightbox({
					title:'Цена конечного потребителя',
					float:true
				});
				
				// Разделитель
				// !!! var trLine = $('<tr class="sub-row-line"><td colspan="'+ $('tr:has(td)',table).first().children('td').size() +'">&nbsp;</td></tr>');
				
				// Выпадающий блок "Замены"
				$('.icons .replacement DISABLE',table).click( function(e){
					var curLink = $(this);
					var tr = curLink.parents('tr:first');
					var trM = tr;
					var idTr = tr.attr('product');
					
					if(tr.next().hasClass('sub-row-block')) tr = tr.nextUntil(':not(.sub-row-block)');
					if(tr.next().hasClass('sub-table-dms-'+idTr)) tr = tr.nextUntil(':not(.sub-table-dms-'+idTr+')').last();
					
					if(curLink.hasClass('active')){// Закрываем блок
					
						curLink.removeClass('active');
						$('.sub-table-'+idTr,table).remove();
						if(!$('.sub-block-'+idTr,table).size() && !$('.sub-table-dms-'+idTr,table).size()){
							trM.removeClass('title-back');
							$('.sub-line-'+idTr,table).remove();
						}
						/*else{
							$('.sub-line-'+idTr+':not(:last)',table).remove();
						}*/
						tableScroller.refresh();
						
					}else{// Открываем блок
						trM.addClass('title-back');
						curLink.addClass('active');
						
						// !!! if(!$('.sub-block-'+idTr,table).size() && !$('.sub-table-dms-'+idTr,table).size())  tr.after(trLine.clone().addClass('sub-line-'+idTr));
						
						// События для строк с заменами
						tr.after(
							$('#replacement-ajax table tr').clone().addClass('sub-table-'+idTr).each(function(index){
								
								var cur = $(this);
								
								// Нумерация строк для таблицы с заменами
								cur.addClass('sub-product'+index);
								cur.attr('sub-product',+index);
								
								// Иконка "Закрыть"
								$('.plus',cur).click(function(e){
									curLink.removeClass('active');
									$('.sub-table-'+idTr,table).remove();
									if(!$('.sub-block-'+idTr,table).size() && !$('.sub-table-dms-'+idTr,table).size()){
										trM.removeClass('title-back');
										$('.sub-line-'+idTr,table).remove();
									}
									/*else{
										$('.sub-line-'+idTr+':not(:last)',table).remove();
									}*/
									e.preventDefault();
								});
								
								// Активная строка 
								cur.filter(':has(>td):not(.sub-row-line)').hover(function(){
									$(this).addClass('hover');
								},function(){
									$(this).removeClass('hover');
								});
								
								//Поле ввода "Добавить в корзину"
								$('.input-in-cart',cur).inputInCart();
								
								// Выпадающий блок "Описание" для таблицы с заменами
								$('.name a, .producer a',cur).click( function(e){
									var curLink = $(this);
									var tr = curLink.parents('tr:first');
									var idCur = tr.attr('sub-product');
									
									if(tr.next().hasClass('sub-row-block')){// Закрываем блок
										tr.removeClass('title-back-s');
										$('.sub-sub-block-'+idCur,table).remove();
										//$('.sub-sub-line-'+idCur,table).remove();
										tableScroller.refresh();
										
									}else{// Открываем блок
										tr.addClass('title-back-s');
										//if(!tr.next().hasClass('sub-row-line')) tr.after(trLine.clone().addClass('sub-line-'+idTr).addClass('sub-sub-line-'+idCur));
										
										// События для блока с описанием
										tr.after(
											$('#info-ajax .sub-row-block').clone().addClass('sub-table-'+idTr).addClass('sub-sub-block-'+idCur).each(function(){
																															 
												var cur = $(this);
												
												// Иконка "Закрыть"
												$('.plus',cur).click(function(e){
													tr.removeClass('title-back-s');
													$('.sub-sub-block-'+idCur,table).remove();
													//$('.sub-sub-line-'+idCur,table).remove();
													e.preventDefault();
												});
											})
										);
										tableScroller.refresh();
										
									}
									
									e.preventDefault();
								});
								
							})
						);
						tableScroller.refresh();
					}
					
					e.preventDefault();
					
				});
				
				// Выпадающий блок "ДМС"
				$('.icons .dms',table).click( function(e){
					var curLink = $(this);
					var tr = curLink.parents('tr:first');
					var trM = tr;
					var idTr = tr.attr('product');
					
					if(tr.next().hasClass('sub-row-block')) tr = tr.nextUntil(':not(.sub-row-block)');
					
					if(curLink.hasClass('active')){// Закрываем блок
					
						curLink.removeClass('active');
						$('.sub-table-dms-'+idTr,table).remove();
						if(!$('.sub-block-'+idTr,table).size() && !$('.sub-table-'+idTr,table).size()){
							trM.removeClass('title-back');
							$('.sub-line-'+idTr,table).remove();
						}
						tableScroller.refresh();
						
					}else{// Открываем блок
						trM.addClass('title-back');
						curLink.addClass('active');
						
						// !!! if(!$('.sub-block-'+idTr,table).size() && !$('.sub-table-'+idTr,table).size())  tr.after(trLine.clone().addClass('sub-line-'+idTr));
						
						// События для строк ДМС
						tr.after(
							$('#dms-ajax table tr').clone().addClass('sub-table-dms-'+idTr).each(function(index){
								
								var cur = $(this);
								
								// Нумерация строк для таблицы с заменами
								cur.addClass('sub-product-dms-'+index);
								cur.attr('sub-product-dms',+index);
								
								// Иконка "Закрыть"
								$('.plus',cur).click(function(e){
									curLink.removeClass('active');
									$('.sub-table-dms-'+idTr,table).remove();
									if(!$('.sub-block-'+idTr,table).size() && !$('.sub-table-'+idTr,table).size()){
										trM.removeClass('title-back');
										$('.sub-line-'+idTr,table).remove();
									}
									e.preventDefault();
								});
								
								// Активная строка 
								cur.filter(':has(>td):not(.sub-row-line)').hover(function(){
									$(this).addClass('hover');
								},function(){
									$(this).removeClass('hover');
								});
								
								//Поле ввода "Добавить в корзину"
								$('.input-in-cart',cur).inputInCart();
								
							})
						);
						tableScroller.refresh();
					}
					
					e.preventDefault();
					
				});
				
				// Выпадающий блок "Описание"
				$('.name a, .producer a',table).click( function(e){
					var curLink = $(this);
					var tr = curLink.parents('tr:first');
					var idTr = tr.attr('product');
					
					if(tr.next().hasClass('sub-row-block')){// Закрываем блок
					
						$('.sub-block-'+idTr,table).remove();
						if(!$('.sub-table-'+idTr,table).size() && !$('.sub-table-dms-'+idTr,table).size()){
							tr.removeClass('title-back');
							$('.sub-line-'+idTr,table).remove();
						}
						tableScroller.refresh();
						
					}else{// Открываем блок
						tr.addClass('title-back');
						
						// !!! if(!$('.sub-table-'+idTr,table).size() && !$('.sub-table-dms-'+idTr,table).size()) tr.after(trLine.clone().addClass('sub-line-'+idTr));
						
						// События для блока с описанием
						tr.after(
							$('#info-ajax .sub-row-block').clone().addClass('sub-block-'+idTr).each(function(){
																											 
								var cur = $(this);
								
								// Иконка "Закрыть"
								$('.plus',cur).click(function(e){
									$('.sub-block-'+idTr,table).remove();
									if(!$('.sub-table-'+idTr,table).size() && !$('.sub-table-dms-'+idTr,table).size()){
										tr.removeClass('title-back');
										$('.sub-line-'+idTr,table).remove();
									}
									e.preventDefault();
								});
							})
						);
						tableScroller.refresh();
						
					}
					
					e.preventDefault();
				});
			}
			
			/*-----------------------------------------
			  ---
			-----------------------------------------*/
			
		});
	
	};

})(jQuery);
