
//Глобальные объекты, инициализируются модулями ниже
var header = false, //Шапка
	cartBox = false, //Корзина в шапке
	searchBox = false; //Поиск в шапке

(function($){
	
	/*-----------------------------------------
	  Шапка
	-----------------------------------------*/
	$.fn.header = function(){
		
		return this.each(function(){
								  
			var hd = $(this);
			var hh = $('#header-height');
			
			// Шапка
			header = {
				header: hd, //Контейнер шапки
				headerHeight: hh, //Контейнер высоты шапки
				panel: $('.header-panel',hd), //Панель в шапке
				lineScroll: $('.scroll-show',hd), //Линия прокрутки вверх, при фиксированной шапке
				headerDOM: hd.get(0),
				htmlDOM: document.getElementsByTagName('html')[0],
				bodyDOM: document.body,
				flagVScroll: false, //Флаг обработчика для вертикальной прокрутки
				staticF: false,
				
				// Контроль высоты хедера
				heightMonitor: {
					block: hh,
					header: hd,
					set: function(h){
						this.block.css('height',(this.block.height()+h)+'px');
					},
					check: function(){
						this.block.css('height',this.header.height()+'px');
					},
					animate: function(h,s){
						if(this.block.css('display')=='block') this.block.animate({height:this.block.height()+h},s);
					}
				},
				
				// Включить/отключить обработчики для скроллов
				checkScroll: function(){
					var hFixed = this.header.hasClass('header-fixed');
					if(hFixed) this.flagVScroll = true; else this.flagVScroll = false;
					if((this.htmlDOM.scrollTop?this.htmlDOM.scrollTop:this.bodyDOM.scrollTop)>0 && !header.staticF) this.lineScroll.show(); else this.lineScroll.hide();
				},
				
				// Статическая шапка
				static: function(){
					mBody = this.htmlDOM.scrollTop?this.htmlDOM:this.bodyDOM;
					if(mBody.scrollTop && settings.animation){
						setTimeout(function() {
							if (mBody.scrollTop>0){
								mBody.scrollTop -=40;
								setTimeout(arguments.callee, 10);
							}else{
								header.headerHeight.hide();
								header.header.removeClass('header-fixed').addClass('header-static');
								header.checkScroll();
							}
						}, 10);
					}else{
						mBody.scrollTop = 0;
						this.headerHeight.hide();
						this.header.removeClass('header-fixed').addClass('header-static');
					}
					header.staticF = true;
					this.checkScroll();
				},
				
				// Фиксированная шапка
				fixed: function(){
					if($(window).width()>=1000){
						this.header.removeClass('header-static').addClass('header-fixed');
						this.headerHeight.show();
						this.heightMonitor.check();
						header.staticF = false;
						this.checkScroll();
					}
				},
				
				// Инициализация
				init: function(){
					
					var headerDOM = this.headerDOM, htmlDOM = this.htmlDOM, bodyDOM = this.bodyDOM, lineScroll = this.lineScroll;
					
					// Для ие6-7 обертываем все содержимое таблицей для устранения проблем с перерисовкой елементов
					if( $.browser.msie && $.browser.version < 8) $('.all').wrapInner('<table class="all-ie"><tr><td class="all-ie"></td></tr></table>');
					
					// Линия, отделяющая контент от шапки, которая появляется при фиксированной шапке и прокрученном вертикальном скролле
					$(window).scroll(function(){
						if(header.flagVScroll)
							if((htmlDOM.scrollTop?htmlDOM.scrollTop:bodyDOM.scrollTop)>0) lineScroll.show();
							else lineScroll.hide();
					});
					
					// Установка начальных параметров шапки
					if(settings.header.hide){
						this.panel.css({marginTop:-104});
						$('.button-slide-panel a',this.header).removeClass('up').addClass('down');
						this.header.removeClass('header-static').addClass('header-fixed');
						this.headerHeight.show();
					}
					/*if(!settings.header.static){
						this.header.removeClass('header-static').addClass('header-fixed');
						this.headerHeight.show();
					}*/
					this.heightMonitor.check();
					this.checkScroll();
					
					// Переключение шапки в статический режим, если окно меньше 1000рх по ширине
					if($(window).width()<1000){ 
						var tmp = header.staticF;
						header.static();
						header.staticF = tmp;
					}else{
						if(!header.staticF) header.fixed();
					}
					$(window).resize(function(){
						if($(window).width()<1000){ 
							var tmp = header.staticF;
							header.static();
							header.staticF = tmp;
						}else{
							if(!header.staticF) header.fixed();
						}				  
					});
					
					// Прокрутка вверх с помощью кнопки
					$('.scroll-content-block a').click(function(e){
						mBody = htmlDOM.scrollTop?htmlDOM:bodyDOM;
						if(mBody.scrollTop && settings.animation){
							setTimeout(function() {
								if (mBody.scrollTop>0){
									mBody.scrollTop -=40;
									setTimeout(arguments.callee, 10);
								}
							}, 10);
						}else{
							mBody.scrollTop = 0;
						}
						e.preventDefault();
					});
					
					// Скрыть/показать шапку
					$('.button-slide-panel a',this.header).click(function(e){
						if($(this).hasClass('up')){
							if(settings.animation){
								header.panel.animate({marginTop:-104},settings.header.speedAnimation,function(){header.fixed();});
								header.heightMonitor.animate(-104,settings.header.speedAnimation);
							}else{
								header.panel.css({marginTop:-104});
								header.heightMonitor.set(-104);
								header.fixed();
							}
							makeAjaxCall("/main/set?id=hideheader&value=1", function(){}, function(){});
							$(this).removeClass('up').addClass('down');
							settings.header.hide = true;
						}
						else{
							if(settings.animation){
								header.panel.animate({marginTop:0},settings.header.speedAnimation,function(){header.static();});
								header.heightMonitor.animate(104,settings.header.speedAnimation);
							}else{
								header.panel.css({marginTop:0});
								header.heightMonitor.set(104);
								header.static();
							}
							makeAjaxCall("/main/set?id=hideheader&value=0", function(){}, function(){});
							$(this).removeClass('down').addClass('up');
							settings.header.hide = false;
						}
						e.preventDefault();
					});
					
					// Главное меню
					var mainMenu = $('.main-menu'),
						mainMenuButtons = $('.button:has(.submenu-shadow)',mainMenu),
						mainMenuSubmenu = $('.submenu-shadow',mainMenuButtons);
						
					mainMenuButtons.each(function(){
																			   
						var button = $(this),
							submenu = $('.submenu-shadow',button),
							link = $('.link',button);
						
						if( $.browser.msie && $.browser.version < 8 && submenu.width()<200) submenu.css('width','200px');
						
						link.click(function(e){
							if(button.hasClass('sub-active')){
								button.removeClass('sub-active');
								submenu.hide();
							}else{
								mainMenuButtons.removeClass('sub-active');				 
								mainMenuSubmenu.hide();
								button.addClass('sub-active');
								submenu.show();
							}
							e.preventDefault();					
						})
						submenu.find('li>a').mousedown(function(){
							$(this).addClass('active');
						})
						.mouseup(function(){
							$(this).removeClass('active');
						});
						
					});
					mainMenu.click(function(e){e.stopPropagation()});
					$('body').click(function(){
						mainMenuButtons.removeClass('sub-active');				 
						mainMenuSubmenu.hide();
					});
					
				}
				
			}
			
			// Инициализация шапки
			header.init();
			
		});
	
	};
	
	/*-----------------------------------------
	  Корзина (тестовая версия, будет меняться)
	-----------------------------------------*/
	$.fn.cartBox = function(){
		
		return this.each(function(){
			
			cartBox = {
				cart: $(this), //Корзина
				panel: $('.panel',$(this)), //Плашка, по клику - сворачивается/разворачивается корзина
				
				// Инициализация
				init: function(){
					
					// Установка начальных параметров шапки
					if(!settings.cartBox.hide){
						this.cart.css({marginTop:0});
						this.panel.removeClass('close');
					}
					
					// Скрыть/показать корзину
					this.panel.click(function(e){
						if(!$(this).hasClass('close')){
							if(settings.animation){
								cartBox.cart.animate({marginTop:-85},settings.cartBox.speedAnimation);
							}else{
								cartBox.cart.css({marginTop:-85});
							}
							$(this).addClass('close');
							settings.cartBox.hide = true;
						}
						else{
							if(settings.animation){
								cartBox.cart.animate({marginTop:0},settings.cartBox.speedAnimation);
							}else{
								cartBox.cart.css({marginTop:0});
							}
							$(this).removeClass('close');
							settings.cartBox.hide = false;
						}
						e.preventDefault();
					});
			
				}
			}
			
			// Инициализация корзины
			cartBox.init();
			
						  
		});
		
	};


	/*-----------------------------------------
	  Поиск
	-----------------------------------------*/
	$.fn.searchBox = function(){
		
		return this.each(function(){
			
			var searchBlock = $(this);
			
			searchBox = {
				searchBlock: searchBlock, //Блок поиска
				buttonCloseSearch: $('.close-link',searchBlock), //Кнопка "свернуть корзину"
				tabSearch: $('#header .tab-search'), //Кнопка сворачивания поиска
				searchTabBlocks: $('.search-tab-block',searchBlock), //Блоки поиска с параметрами
				searchTabs: $('.search-tabs a:not(.more)',searchBlock), //Табы переключения блоков поиска
				timer: false, //Таймер
				listArea: $('.list-area',searchBlock), //Текстовое поле поиска по списку
				areaOpen: false,
				
				// Инициализация
				init: function(){
					
					// Свернуть поиск
					this.buttonCloseSearch.click(function(e){
						searchBox.searchBlock.hide();
						header.heightMonitor.check();
						searchBox.tabSearch.show();
						settings.searchBox.hide = true;
						e.preventDefault();
					});
					
					// Развернуть поиск
					this.tabSearch.click(function(e){
						searchBox.searchBlock.show();
						header.heightMonitor.check();
						searchBox.tabSearch.hide();
						settings.searchBox.hide = false;
						e.preventDefault();
					});
					
					// Табы
					this.searchTabs.click(function(e){
						searchBox.searchTabs.removeClass('active');
						$(this).addClass('active');
						searchBox.searchTabBlocks.hide();
						searchBox.searchTabBlocks.eq($(this).index()).show();
						header.heightMonitor.check();
						e.preventDefault();
					});
					
					// Сворачивание/разворачивание поиска
					this.listArea.parent().bind('mouseenter',function(){
						if(searchBox.searchTabs.eq(0).hasClass('active') && !searchBox.listArea.hasClass('big') && !searchBox.areaOpen){
							searchBox.listArea.addClass('big');
							if(searchBox.timer) clearTimeout(searchBox.timer);
							if(settings.animation){
								searchBox.timer = setTimeout(
									function(){
										searchBox.listArea.animate({height:'13em'},500);
									},150);
							}else{
								searchBox.timer = setTimeout(
									function(){
										searchBox.listArea.css({height:'13em'});
									},150);
							}
						}
					}).bind('focusout',function(){
						searchBox.areaOpen = false;
						if(searchBox.searchTabs.eq(0).hasClass('active') && searchBox.listArea.hasClass('big')){
							searchBox.listArea.removeClass('big');
							if(searchBox.timer) clearTimeout(searchBox.timer);
							if(settings.animation){
								searchBox.listArea.animate({height:'1.1em'},500); 
							}else{
								searchBox.listArea.css({height:'1.1em'}); 
							}
						}
					})
					.bind('mouseleave focusout',function(){
						if(searchBox.searchTabs.eq(0).hasClass('active') && searchBox.listArea.hasClass('big') && !searchBox.areaOpen){
							searchBox.listArea.removeClass('big');
							if(searchBox.timer) clearTimeout(searchBox.timer);
							if(settings.animation){
								searchBox.timer = setTimeout(
									function(){
										searchBox.listArea.animate({height:'1.1em'},500); 
									},1500);
							}else{
								searchBox.timer = setTimeout(
									function(){
										searchBox.listArea.css({height:'1.1em'}); 
									},1500);
							}
						}
					}).bind('focusin',function(){
						searchBox.areaOpen = true;
					});
					
				}
				
			}
			
			// Инициализация поиска
			searchBox.init();
			
						  
		});
		
	};

	/*-----------------------------------------
	  feedback
	-----------------------------------------*/
 $.fn.feedbackBox = function(){
		
  return this.each(function(){
			
   var feedbackBlock = $(this);
			
   feedbackBox = {
    feedbackBlock: feedbackBlock, //Блок поиска
    buttonCloseFeedback: $('.close-link',feedbackBlock), //Кнопка "свернуть корзину"
    tabFeedback: $('#header .tab-feedback'), //Кнопка сворачивания поиска
    feedbackSend: $("a.feedsend", feedbackBlock),
    feedbackFileAdd: $("a.feed-file-add", feedbackBlock),
    feedbackFileDrop: $("tr.files a.feed-file-drop", feedbackBlock),
    //searchTabBlocks: $('.feedback-tab-block',searchBlock), //Блоки поиска с параметрами
    //searchTabs: $('.search-tabs a:not(.more)',searchBlock), //Табы переключения блоков поиска
    timer: false, //Таймер
    //listArea: $('.list-area',searchBlock), //Текстовое поле поиска по списку
    //areaOpen: false,
				
    // Инициализация
    init: function(){
					
     // Свернуть поиск
     this.buttonCloseFeedback.click(function(e){
      feedbackBox.feedbackBlock.hide();
      header.heightMonitor.check();
      feedbackBox.tabFeedback.show();
      settings.feedbackBox.hide = true;
      e.preventDefault();
     });
					
     // Развернуть поиск
     this.tabFeedback.click(function(e){
      feedbackBox.feedbackBlock.show();
      header.heightMonitor.check();
      feedbackBox.tabFeedback.hide();
      settings.feedbackBox.hide = false;
      e.preventDefault();
     });

     // commit
     this.feedbackSend.click(function(e){

      $(feedbackBox.feedbackSend).parents("form").submit();
      $(feedbackBox).find("table tr.files").remove();
      $(feedbackBox).find("table input#message_subject").val("УРМ: ");
      $(feedbackBox).find("table textarea#message_body").val("");
      $(feedbackBox).find("select#mail_type").val(1);
      e.preventDefault();
     });
     this.feedbackFileDrop.click(function(e){
      $(this).parents("tr.files").remove();
      e.preventDefault();
     });
     this.feedbackFileAdd.click(function(e){
      $('<tr class="files"><td><div class="upload"><input name="message_upload[]" type="file"></div></td><td><a class="feed-file-drop" href="#">Удалить</a></td></tr>').appendTo($("table", feedbackBlock)).find('a.feed-file-drop').click(function(e){ $(this).parents("tr.files").remove(); e.preventDefault(); });
      e.preventDefault();
     });
					
     // Табы
     /*this.feedbackTabs.click(function(e){
      feedbackBox.feedbackTabs.removeClass('active');
      $(this).addClass('active');
      feedbackBox.feedbackTabBlocks.hide();
      feedbackBox.feedbackTabBlocks.eq($(this).index()).show();
      header.heightMonitor.check();
      e.preventDefault();
     });*/
					
     // Сворачивание/разворачивание поиска
     /*this.listArea.parent().bind('mouseenter',function(){
      if(searchBox.searchTabs.eq(0).hasClass('active') && !searchBox.listArea.hasClass('big') && !searchBox.areaOpen){
       searchBox.listArea.addClass('big');
       if(searchBox.timer) clearTimeout(searchBox.timer);
       if(settings.animation){
       searchBox.timer = setTimeout(
        function(){
         searchBox.listArea.animate({height:'13em'},500);
        },150);
     }else{
      searchBox.timer = setTimeout(
       function(){
        searchBox.listArea.css({height:'13em'});
       },150);
      }
     }
     }).bind('focusout',function(){
      searchBox.areaOpen = false;
      if(searchBox.searchTabs.eq(0).hasClass('active') && searchBox.listArea.hasClass('big')){
       searchBox.listArea.removeClass('big');
       if(searchBox.timer) clearTimeout(searchBox.timer);
       if(settings.animation){
        searchBox.listArea.animate({height:'1.1em'},500); 
       }else{
        searchBox.listArea.css({height:'1.1em'}); 
       }
      }
     })
     .bind('mouseleave focusout',function(){
      if(searchBox.searchTabs.eq(0).hasClass('active') && searchBox.listArea.hasClass('big') && !searchBox.areaOpen){
       searchBox.listArea.removeClass('big');
       if(searchBox.timer) clearTimeout(searchBox.timer);
       if(settings.animation){
        searchBox.timer = setTimeout(
         function(){
          searchBox.listArea.animate({height:'1.1em'},500); 
         },1500);
       }else{
        searchBox.timer = setTimeout(
         function(){
          searchBox.listArea.css({height:'1.1em'}); 
         },1500);
       }
      }
     }).bind('focusin',function(){
      searchBox.areaOpen = true;
     });
*/
    }
			
   }
			
   // Инициализация поиска
   feedbackBox.init();
			
						  
  });
		
 };

})(jQuery);
