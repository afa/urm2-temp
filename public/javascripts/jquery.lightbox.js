/*
 *
 * EDITED SPECIAL FOR www.compel.ru
 *
 *
 * lightbox - jQuery Plugin
 * Simple and fancy lightbox alternative
 *
 * Copyright (c) 2008 - 2010 Janis Skarnelis
 *
 * Requires: jQuery v1.3+
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */

;(function($) {
		 
	var tmp, 
		loading, 
		loading_min, 
		overlay, 
		wrap, 
		outer, 
		content, 
		close, 
		title, 

		selectedOpts = {}, 
		selectedObj = 0, 

		ajaxLoader = null,

		loadingTimer,
		loadingFrame = 1,
		loadingTimerMin,
		loadingFrameMin = 1,

		titleStr = '',
		start_pos,
		final_pos,
		busy = false, //Включить режим "выполняется"
		fx = $.extend($('<div/>')[0], { prop: 0 }),

		isIE6 = $.browser.msie && $.browser.version < 7 && !window.XMLHttpRequest,


	/*********************
	 * Private methods 
	 *********************/
	
	//Прекратить загрузку текущего окна
	_abort = function() {
		
		loading.hide();
		loading_min.hide();

		if (ajaxLoader) {
			ajaxLoader.abort();
		}

		tmp.empty();
	},
	
	//Показать ошибку
	_error = function() {
		if (false === selectedOpts.onError(selectedObj, selectedOpts)) {
			loading.hide();
			loading_min.hide();
			busy = false;
			return;
		}

		selectedOpts.titleShow = false;

		selectedOpts.width = 'auto';
		selectedOpts.height = 'auto';

		tmp.html( '<p id="lightbox-error">The requested content cannot be loaded.<br />Please try again later.</p>' );

		_process_inline();
	},
	
	//Инициализация отдельного окна
	_start = function() {
		var obj = selectedObj,
			href, //Ссылка на контент
			type, //Тип окна
			title, //Заголовок
			str, 
			emb, 
			ret;
		
		//Прекращаем загрузку текущего окна
		_abort();
		
		//Присваиваем настройки текущего окна
		selectedOpts = $.extend({}, $.fn.lightbox.defaults, (typeof $(obj).data('lightbox') == 'undefined' ? selectedOpts : $(obj).data('lightbox')));
		
		//Вызываем пользовательскую функция перед загрузкой контента
		ret = selectedOpts.onStart(selectedObj, selectedOpts);
		
		//Если функция возвратила отрицательный результат - выходим
		if (ret === false) {
			busy = false;
			return;
		//В противном случае, если функция возвратила объект, обновляем настройки окна
		} else if (typeof ret == 'object') {
			selectedOpts = $.extend(selectedOpts, ret);
		}
		
		//Устанавливаем заголовок
		title = selectedOpts.title || (obj.nodeName ? $(obj).attr('titlebox') : obj.title) || '';
		
		//Устанавливаем ссылку
		href = selectedOpts.href || (obj.nodeName ? $(obj).attr('href') : obj.href) || null;
		if ((/^(?:javascript)/i).test(href) || href == '#') {
			href = null;
		}
		
		//Устанавливаем тип окна
		if (selectedOpts.type) {
			type = selectedOpts.type;

			if (!href) {
				href = selectedOpts.content;
			}

		} else if (selectedOpts.content) {
			type = 'html';

		} else if (href) {
			if ($(obj).hasClass("iframe")) {
				type = 'iframe';

			} else if (href.indexOf("#") === 0) {
				type = 'inline';

			} else {
				type = 'ajax';
			}
		}
		if (!type) {
			_error();
			return;
		}
		
		//Присваиваем obj id контента
		if (type == 'inline') {
			obj	= href.substr(href.indexOf("#"));
			type = $(obj).length > 0 ? 'inline' : 'ajax';
		}
		
		//Обновляем параметры текущего окна
		selectedOpts.type = type;
		selectedOpts.href = href;
		selectedOpts.title = title;
		
		//Устанавливаем значение ширины и высоты в "auto" для включенной опции autoDimensions
		if (selectedOpts.autoDimensions) {
			if (selectedOpts.type != 'iframe') {
				selectedOpts.width = 'auto';
				selectedOpts.height = 'auto';
			} else {
				selectedOpts.autoDimensions = false;	
			}
		}
		
		//Устанавливаем настройки для плавающего окна
		if (selectedOpts.float){
			selectedOpts.overlayShow = false;
			selectedOpts.modal = false;
		}
		
		//Устанавливаем настройки для включенной опции модального окна
		if (selectedOpts.modal) {
			selectedOpts.overlayShow = true;
			selectedOpts.hideOnOverlayClick = false;
			selectedOpts.enableEscapeButton = false;
			selectedOpts.showCloseButton = false;
		}
		
		// При событии lightbox-change, вставляем контент окна в блок .lightbox-inline-tmp
		$('.lightbox-inline-tmp').unbind('lightbox-cancel').bind('lightbox-change', function() {
			$(this).replaceWith(content.children().children());				
		});
		
		//Взависимости от типа окна, выполняем необходимые действия
		switch (type) {
			case 'html' :
				tmp.html( selectedOpts.content );
				_process_inline();
			break;

			case 'inline' :
				//Если контент уже открыт в окне, выходим
				if ( $(obj).parent().is('#lightbox-content') === true) {
					busy = false;
					return;
				}
				
				//Вставляем блок .lightbox-inline-tmp перед контентом и навешиваем события для хранения временных данных
				$('<div class="lightbox-inline-tmp" />')
					.hide()
					.insertBefore( $(obj) )
					.bind('lightbox-cleanup', function() {
						$(this).replaceWith(content.children().children());
					}).bind('lightbox-cancel', function() {
						$(this).replaceWith(tmp.children().children());
					});
				
				//Переносим контент в блок tmp
				$(obj).appendTo(tmp);
				
				//Выполняем операции для инлайнового контента
				_process_inline();
			break;

			case 'ajax':
				busy = false;

				$.lightbox.showActivity();
				
				$.ajax($.extend({}, selectedOpts.ajax, {
					url: href,
					data: selectedOpts.ajax.data || {},
					type: 'get',
					success: function(data) {
						
						tmp.html( data );
						if (tmp.html()) {
							loading.hide();
							loading_min.hide();
							_process_inline();
						} else
							_error();
					},
					error: _error
				}));

			break;

			case 'iframe':
				_show();
			break;
		}
	},
	
	//Показать контент для инлайнового блока
	_process_inline = function() {
		//Преобразуем ширину и высоту в нужный формат
		var
			w = selectedOpts.width,
			h = selectedOpts.height;

		if (w.toString().indexOf('%') > -1) {
			w = parseInt( $(window).width() * parseFloat(w) / 100, 10) + 'px';

		} else {
			w = w == 'auto' ? false : w + 'px';	
		}

		if (h.toString().indexOf('%') > -1) {
			h = parseInt( $(window).height() * parseFloat(h) / 100, 10) + 'px';

		} else {
			h = h == 'auto' ? false : h + 'px';	
		}
		
		//Прописываем ширину и высоту для tmp
		tmp.wrapInner('<div style="' + (w?'width:'+w+';':'') + 'overflow: ' + selectedOpts.scrolling + ';' + ((selectedOpts.scrolling=='auto' && !w && !$.support.opacity)?'overflow-x:hidden;':'') + ((selectedOpts.scrolling=='auto' && !h && !$.support.opacity)?'overflow-y:hidden;padding-bottom:16px;':'') + 'position:relative;"></div>');
		selectedOpts.width = tmp.width() + (((selectedOpts.scrolling=='auto') && !w && h && (tmp.height() > selectedOpts.height)) ? 54 : 30);
		if(h) tmp.children().css('height',h);
		selectedOpts.height = tmp.height() + 60;
		
		//Формируем окно
		_show();
	},
	
	//Сформировать окно
	_show = function() {
		var pos, equal;
		
		//Скрываем блок загрузки
		loading.hide();
		loading_min.hide();
		
		//Если окно уже загружено и функция onCleanup возвращает отрицательный результат, выходим
		if (wrap.is(":visible") && false === selectedOpts.onCleanup(selectedObj, selectedOpts)) {
			$.event.trigger('lightbox-cancel');

			busy = false;
			return;
		}
		
		//Включаем режим "выполняется"
		busy = true;
		
		//Удаляем навешанные ранее события
		$(content.add( overlay )).unbind();
		
		$(window).unbind("resize.fb scroll.fb");
		$(document).unbind('keydown.fb click.fb');
		
		//Если оверлей включен - показываем его, в противном случае - скрываем
		if (selectedOpts.overlayShow) {
			overlay.css({
				'background-color' : selectedOpts.overlayColor,
				'opacity' : selectedOpts.overlayOpacity,					
				'height' : $(document).height()
			});
			if (!overlay.is(':visible')) {
				//Удаляем селекты для ие6
				if (isIE6) {
					$('select:not(#lightbox-tmp select)').filter(function() {
						return this.style.visibility !== 'hidden';
					}).css({'visibility' : 'hidden'}).one('lightbox-cleanup', function() {
						this.style.visibility = 'inherit';
					});
				}

				overlay.show();
			}
		} else {
			overlay.hide();
		}
		
		//Получаем размеры и координаты нового окна
		final_pos = _get_zoom_to();
		
		//Формируем заголовок
		titleStr = selectedOpts.title || '';

		if ((selectedOpts.titleShow === false) || !titleStr || !titleStr.length) {
			title.html('&nbsp;');
		}

		title.removeAttr('class').addClass('popup-title '+selectedOpts.titleClass).html( titleStr );
		
		//Если есть старое окно
		if (wrap.is(":visible")) {
			
			//Если новое окно плавающее
			if(selectedOpts.float){
				
				content.fadeTo(settings.animation ? selectedOpts.changeFade : 0, 0.3, function() {
					
					//Выполняем событие, что окно будет изменено
					$.event.trigger('lightbox-change');
					
					//Выставляем новые параметры контента в окне
					content
						.empty()
						.removeAttr('filter')
					
					//Показываем новый контент
					content.html( tmp.contents() ).fadeTo(settings.animation ? selectedOpts.changeFade : 0, 1, _finish);
					
				});
				
			}else{
			
				//Скрываем навигацию
				close.hide();
				
				//Сохраняем размеры и координаты старого окна
				pos = wrap.position(),
	
				start_pos = {
					top	 : pos.top,
					left : pos.left,
					width : wrap.width(),
					height : wrap.height()
				};
				
				//Опеределем, есть ли разница в размерах между новым и старым окном
				equal = (start_pos.width == final_pos.width && start_pos.height == final_pos.height);
				
				//Скрываем контент
				content.fadeTo(settings.animation ? selectedOpts.changeFade : 0, 0.3, function() {
					//Показать новый контент
					var finish_resizing = function() {
						content.html( tmp.contents() ).fadeTo(settings.animation ? selectedOpts.changeFade : 0, 1, _finish);
					};
					
					//Выполняем событие, что окно будет изменено
					$.event.trigger('lightbox-change');
					
					//Выставляем новые параметры контента в окне
					content
						.empty()
						.removeAttr('filter')
						.css({
							'width'	: final_pos.width-30,
							'height' : selectedOpts.autoDimensions ? 'auto' : final_pos.height - 30
						});
					
					//Если новое окно по размерам идентично старому - показываем новый контент
					if (equal) {
						finish_resizing();
	
					} else {
						//Меняем размеры окна
						fx.prop = 0;
	
						$(fx).animate({prop: 1}, {
							 duration : (settings.animation ? selectedOpts.changeSpeed : 0),
							 easing : selectedOpts.easingChange,
							 step : _draw,
							 complete : finish_resizing
						});
					}
				});
			}

			return;
		}
		
		//Если нет старого окна
		
		//Удаляем старые стили окна
		wrap.removeAttr("style");
		
		//Устанавливаем размеры контента
		content
			.css({
				'width' : final_pos.width-30,
				'height' : selectedOpts.autoDimensions ? 'auto' : final_pos.height - 30
			})
			.html( tmp.contents() );
		
		//Показываем окно
		wrap
			.css(final_pos)
			.fadeIn( settings.animation ? selectedOpts.speedIn : 0, _finish );
	},
	
	//Завершить показ контента с учетом настроек
	_finish = function () {
		if (!$.support.opacity) {
			content.get(0).style.removeAttribute('filter');
			wrap.get(0).style.removeAttribute('filter');
		}

		if (selectedOpts.autoDimensions){
			content.css('height', 'auto');
		}

		wrap.css('height', 'auto');

		if (selectedOpts.showCloseButton){
			close.show();
		}

		if (selectedOpts.hideOnOverlayClick){
			overlay.bind('click', $.lightbox.close);
		}
		
		if(!selectedOpts.float){
			$(window).bind("resize.fb", $.lightbox.resize);
			$(window).bind("scroll.fb", $.lightbox.center);
		}
		if(selectedOpts.hideOnLeaveClick){
			$(document).bind("click.fb", $.lightbox.close);	
		}
		
		if (selectedOpts.enableEscapeButton) {
			$(document).bind('keydown.fb', function(e) {
				if (e.keyCode == 27 && selectedOpts.enableEscapeButton) {
					e.preventDefault();
					$.lightbox.close();
				}
			});
		}
		
		if (selectedOpts.type == 'iframe') {
			$('<iframe id="lightbox-frame" name="lightbox-frame' + new Date().getTime() + '" frameborder="0" hspace="0" ' + ($.browser.msie ? 'allowtransparency="true""' : '') + ' style="overflow:' + selectedOpts.scrolling + ';" src="' + selectedOpts.href + '"></iframe>').appendTo(content);
		}

		wrap.show();

		busy = false;
		
		if(!selectedOpts.float) $.lightbox.center();
		
		selectedOpts.onComplete(selectedObj, selectedOpts);

	},
	
	//Отпозиционировать новое окно относительно старого с учетом коэффициента
	_draw = function(pos) {
		var dim = {
			width : parseInt(start_pos.width + (final_pos.width - start_pos.width) * pos, 10),
			height : parseInt(start_pos.height + (final_pos.height - start_pos.height) * pos, 10),

			top : parseInt(start_pos.top + (final_pos.top - start_pos.top) * pos, 10),
			left : parseInt(start_pos.left + (final_pos.left - start_pos.left) * pos, 10)
		};

		if (typeof final_pos.opacity !== 'undefined') {
			dim.opacity = pos < 0.5 ? 0.5 : pos;
		}

		wrap.css(dim);

		content.css({
			'width' : dim.width - 30,
			'height' : dim.height - 60
		});
	},
	
	//Получить размеры документа
	_get_viewport = function() {
		return [
			$(window).width(),
			$(window).height(),
			$(document).scrollLeft(),
			$(document).scrollTop()
		];
	},
	
	//Получить размеры и координаты нового окна
	_get_zoom_to = function () {
		var view = _get_viewport(),
			to = {},
			ratio,
			ws = false, 
			hs = false;
		
		//Вычисляем ширину окна
		if (selectedOpts.width.toString().indexOf('%') > -1) {
			to.width = parseInt((view[0] * parseFloat(selectedOpts.width)) / 100, 10);
		} else {
			to.width = selectedOpts.width;
		}
		
		//Вычисляем высоту окна
		if (selectedOpts.height.toString().indexOf('%') > -1) {
			to.height = parseInt((view[1] * parseFloat(selectedOpts.height)) / 100, 10);
		} else {
			to.height = selectedOpts.height;
		}
		
		//Если окно выходит за пределы видимости экрана - уменьшаем ширину и высоту окна
		if (to.width > view[0] - 60) {
			tmp.children().css({overflowX:'auto',width:'100%'});
			to.width = view[0] - 60;
			ws = true;
		}
		if (to.height > view[1] - 60) {
			tmp.children().css({overflowY:'auto',height:view[1]-130+'px'});
			to.height = view[1] - 60;
			hs = true;
		}
		if(!ws && hs) to.width += 24;
		
		//Вычисляем координаты положения окна
		if(selectedOpts.float && selectedObj){
			
			var pos = $(selectedObj).offset();
			pos.leftX = pos.left - view[2];
			pos.topX = pos.top - view[3];
			
			to.top = pos.top - 10;
			to.left = pos.left;
			
			if(pos.leftX > (view[0] - pos.leftX)) to.left = pos.left - to.width;
			if(to.left - view[2] > view[0] - to.width) to.left = view[0] + view[2] - to.width - 30;
			if(to.left - view[2] < 30) to.left = view[2] + 30;
			
			if(to.top - view[3] > view[1] - to.height - 30) to.top = view[1] + view[3] - to.height - 30;
			if(to.top - view[3] < 30) to.top = view[3] + 30;
			
		}else{
			to.top = parseInt(Math.max(view[3] - 20, view[3] + ((view[1] - to.height) * 0.5)), 10);
			to.left = parseInt(Math.max(view[2] - 20, view[2] + ((view[0] - to.width) * 0.5)), 10);
		}
		return to;
	},

	_animate_loading = function() {
		if (!loading.is(':visible')){
			clearInterval(loadingTimer);
			return;
		}

		$('div', loading).css('top', (loadingFrame * -40) + 'px');

		loadingFrame = (loadingFrame + 1) % 12;
	};
	
	_animate_loading_min = function() {
		if (!loading_min.is(':visible')){
			clearInterval(loadingTimerMin);
			return;
		}

		$('div', loading_min).css('top', (loadingFrameMin * -15) + 'px');

		loadingFrameMin = (loadingFrameMin + 1) % 12;
	};

	/*********************
	 * Public methods    
	 *********************/
	
	//Подключение
	$.fn.lightbox = function(options) {
		//Если нет элементов, возвращаем текущений элемент
		if (!$(this).length) {
			return this;
		}

		$(this)
			//Сохраняем настройки в текущем эелементе
			.data('lightbox', $.extend({}, options, ($.metadata ? $(this).metadata() : {})))
			//Удаляем событие на клик, если раньше они были навешаны с помощью текущего плагина
			.unbind('click.fb')
			//Добавляем событие на клик
			.bind('click.fb', function(e) {
									   
				e.preventDefault();
				e.stopPropagation();
				
				//Если в данный момент включен режим "выполняется", выходим
				if (busy) {
					return;
				}
				
				//Устанавливаем галерею в режим "выполняется"
				busy = true;
				
				//Убираем фокус с текущего элемента
				$(this).blur();
				
				//Добавляем текущий элемент в массив
				selectedObj = this;
				
				//Инициализируем текущее окно
				 if(wrap.is(':visible') && !$(this).parents('#lightbox-content').length){
					 busy = false;
					 $.lightbox.close(true);
				 }else _start();

				return;
			});

		return this;
	};
	
	//Вызываем окно
	$.lightbox = function(obj) {
		var opts;
		
		//Если в данный момент включен режим "выполняется", выходим
		if (busy) {
			return;
		}
		
		//Устанавливаем режим "выполняется"
		busy = true;
		opts = typeof arguments[1] !== 'undefined' ? arguments[1] : {};
		
		
		if (typeof obj == 'object') {
			$(obj).data('lightbox', $.extend({}, opts, obj));
		} else {
			obj = $({}).data('lightbox', $.extend({content : obj}, opts));
		}

		selectedObj = obj;
		
		//Инициализируем текущее окно
		_start();
	};
	
	//Показать анимацию загрузки окна
	$.lightbox.showActivity = function() {
		if(selectedOpts.float){
			var pos = $(selectedObj).offset();
			clearInterval(loadingTimerMin);

			loading_min.css({
				top:pos.top+'px',
				left:pos.left-18+'px'
			}).show();
			loadingTimerMin = setInterval(_animate_loading_min, 66);
		}else{
			clearInterval(loadingTimer);

			loading.show();
			loadingTimer = setInterval(_animate_loading, 66);
		}
		
	};

	//Скрыть анимацию загрузки окна
	$.lightbox.hideActivity = function() {
		loading_min.hide();
		loading.hide();
	};
	
	//Отмена загрузки содержимого
	$.lightbox.cancel = function() {
		if (busy) {
			return;
		}

		busy = true;

		$.event.trigger('lightbox-cancel');

		_abort();

		selectedOpts.onCancel(selectedObj, selectedOpts);

		busy = false;
	};
	
	//Закрыть окно
	// Note: within an iframe use - parent.$.lightbox.close();
	$.lightbox.close = function(start) {
		if (busy || wrap.is(':hidden')) {
			return;
		}

		busy = true;

		if (selectedOpts && false === selectedOpts.onCleanup(selectedObj, selectedOpts)) {
			busy = false;
			return;
		}

		_abort();

		close.hide();

		$(content.add( overlay )).unbind();

		$(window).unbind("resize.fb scroll.fb");
		$(document).unbind('keydown.fb click.fb');

		content.find('iframe').attr('src', isIE6 && /^https/i.test(window.location.href || '') ? 'javascript:void(false)' : 'about:blank');

		wrap.stop();
		
		wrap.fadeOut( settings.animation ? selectedOpts.speedOut : 0, function(){ 
			overlay.fadeOut(settings.animation ? 'fast' : 0);

			title.html('&nbsp;');
			wrap.hide();

			$.event.trigger('lightbox-cleanup');

			content.empty();

			selectedOpts.onClosed(selectedObj, selectedOpts);
			
			selectedOpts =  {};

			busy = false;
			
			if(start==true) _start();
				else selectedObj =  0;
		});
		
		
		
	};
	
	//Resize
	$.lightbox.resize = function() {
		if (overlay.is(':visible')) {
			overlay.css('height', $(document).height());
		}

		$.lightbox.center(true);
	};
	
	//Отобразить окно по центру
	$.lightbox.center = function() {
		var view, align;

		if (busy) {
			return;	
		}

		align = arguments[0] === true ? 1 : 0;
		view = _get_viewport();

		if (!align && (wrap.width() > view[0] || wrap.height() > view[1])) {
			return;	
		}
		
		wrap
			.stop()
			.animate({
				'top' : parseInt(Math.max(view[3] - 20, view[3] + ((view[1] - content.height() - 30) * 0.5))),
				'left' : parseInt(Math.max(view[2] - 20, view[2] + ((view[0] - content.width() - 30) * 0.5)))
			}, settings.animation ? 200 : 0);
	};
	
	//Инициализация
	$.lightbox.init = function() {
		
		//Если уже инициализировали, выходим
		if ($("#lightbox-wrap").length) {
			return;
		}
		
		//Построение пустого окна
		$('body').append(
			tmp	= $('<div id="lightbox-tmp"></div>'),
			loading	= $('<div id="lightbox-loading"><div></div></div>'),
			loading_min	= $('<div id="lightbox-loading-min"><div></div></div>'),
			overlay	= $('<div id="lightbox-overlay"></div>'),
			wrap = $('<div id="lightbox-wrap"></div>')
		);
		outer = $('<div id="lightbox-outer"></div>')
			.append('<table class="popap-table"><tr><td class="back-tl">&nbsp;</td><td class="back-tx">&nbsp;</td><td class="back-tr">&nbsp;</td></tr><tr><td class="back-ly">&nbsp;</td><td class="popup-content-td"><div class="popup-content"></div></td><td class="back-ry">&nbsp;</td></tr><tr><td class="back-bl">&nbsp;</td><td class="back-bx">&nbsp;</td><td class="back-br">&nbsp;</td></tr></table>')
			.appendTo( wrap );
		outer.find('.popup-content').append(
			close = $('<a href="javascript:;" class="button-close"><span class="j-link">закрыть</span></a>'),
			title = $('<div class="popup-title"></div>'),
			content = $('<div id="lightbox-content"></div>')
		);
		
		//События для закрытия
		wrap.bind('click',function(e){return false;});
		close.hide().click($.lightbox.close);
		loading.click($.lightbox.cancel);
		loading_min.click($.lightbox.cancel);
		
		//Прозрачность для ие
		if (!$.support.opacity) {
			wrap.addClass('lightbox-ie');
		}
		
		//Стили для ие6
		if (isIE6) {
			loading.addClass('lightbox-ie6');
			wrap.addClass('lightbox-ie6');

			$('<iframe id="lightbox-hide-sel-frame" src="' + (/^https/i.test(window.location.href || '') ? 'javascript:void(false)' : 'about:blank' ) + '" scrolling="no" border="0" frameborder="0" tabindex="-1"></iframe>').prependTo(outer);
		}
		
	};
	
	//Настройки
	$.fn.lightbox.defaults = {
		modal : false, //Модальное окно: "overlayShow" включен, а "hideOnOverlayClick", "enableEscapeButton", "showCloseButton" выключены
		float : false, //Позиционирование окна: 'center' - по центру экрана, 'float' - возле места вызова окна
		scrolling : 'visible',	//Полоса прокрутки: 'visible', 'auto', 'scroll' or 'hidden'

		width : 560, //Ширина для iframe, также для "inline" контента, если "autoDimensions" выключен
		height : 340, //Высота для iframe, также для "inline" контента, если "autoDimensions" выключен

		autoDimensions : true, //Определять размеры содержимого для "inline" и "ajax"

		ajax : {}, //Настройки ajax

		hideOnOverlayClick : true, //Закрывать по клику на затемняющий слой
		hideOnLeaveClick : false, //Закрывать по клику вне области окна
		
		overlayShow : true, //Включить затемняющий слой

		titleShow : true, //Показать заголовок окна
		titleClass : '', //Класс для заголовка окна
		
		showCloseButton	 : true, //Показать кнопку "Закрыть"
		enableEscapeButton : true, //Включить закрытие окна по нажатию на клавишу "Esc"
		
		overlayOpacity : 0.5, //Прозрачность затемняющего слоя
		overlayColor : '#FFF', //Цвет затемняющего слоя
		speedIn : 300, //Время анимации появления окна
		speedOut : 300, //Время анимации закрытия окна
		changeSpeed : 300, //Время изменения размера окна
		changeFade : 'fast', //Скорость изменения контента в окне
		easingIn : 'swing', //Эффект для нелинейной анимации при появлении окна
		easingOut : 'swing', //Эффект для нелинейной анимации при закрытии окна
		easingChange : 'swing', //Эффект для нелинейной анимации при изменении окна
		
		onStart : function(){}, //Будет вызвана перед загрузкой контента
		onCancel : function(){},  //Будет вызвана, если загрузка контента отменена
		onComplete : function(){}, //Будет вызвана после показа контента
		onCleanup : function(){}, //Будет вызвана перед закрытием окна
		onClosed : function(){}, //Будет вызвана после закрытия окна
		onError : function(){} //Будет вызвана при ошибке
	};
	
	//Запускаем инициализацию после загрузки документа
	$(document).ready(function() {
		$.lightbox.init();
	});

})(jQuery);