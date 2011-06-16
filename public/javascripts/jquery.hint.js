(function($){
	
	$.fn.hint = function(){
		
		return this.each(function(){
			
			var hint = $(this),
				hintIcon = hint.find('img'),
				mainWrapper = $('.all');
			
			if(!$('.hint-block').size()){
				mainWrapper.append($('<div class="hint-block"><div class="corner"></div><span class="hint-text"></span></div>').hide());
			}
			
			hintBlock = $('.hint-block');
			
			hint.hover(function(){
				$(this).addClass('hint-hover');
				hintBlock.css({
					top: (hintIcon.offset().top-40)+'px',
					left: (hintIcon.offset().left+6)+'px'
				}).find('.hint-text').html(hintIcon.attr('alt'));
				hintBlock.show();
			},function(){
				$(this).removeClass('hint-hover');
				hintBlock.hide();
			});
			
		});
	
	};

})(jQuery);