

(function($) {
	$.fn.validationEngineLanguage = function() {};
	$.validationEngineLanguage = {
		newLang: function() {
			$.validationEngineLanguage.allRules = 	{"required":{    			// Add your regex rules here, you can take telephone as an example
						"regex":"none",
						"alertText":"* Необходимо заполнить",
						"alertTextCheckboxMultiple":"* Вы должны выбрать вариант",
						"alertTextCheckboxe":"* Необходимо отметить"},
					"length":{
						"regex":"none",
						"alertText":"*Должно быть от ",
						"alertText2":" до ",
						"alertText3": " символов"},
					"maxCheckbox":{
						"regex":"none",
						"alertText":"* Нельзя выбрать столько вариантов"},	
					"minCheckbox":{
						"regex":"none",
						"alertText":"* Пожайлуста выберите ",
						"alertText2":" опции"},	
					"confirm":{
						"regex":"none",
						"alertText":"* Значения не совпадают"},		
					"telephone":{
						"regex":"/^[0-9\-\(\)\ ]+$/",
						"alertText":"* Неправильный формат телефона"},	
					"email":{
						"regex":"/^[a-zA-Z0-9_\.\-]+\@([a-zA-Z0-9\-]+\.)+[a-zA-Z0-9]{2,4}$/",
						"alertText":"* Неверный формат email"},	
					"date":{
                         "regex":"/^[0-9]{4}\-\[0-9]{1,2}\-\[0-9]{1,2}$/",
                         "alertText":"* Неправильная дата, должно быть в ГГГГ-MM-ДД формате"},
					"onlyNumber":{
						"regex":"/^[0-9\ ]+$/",
						"alertText":"* Значение должно быть числом"},
					"max":{
						"regex":"none",
						"alertText":"* Значение должно быть не больше "},
					"min":{
						"regex":"none",
						"alertText":"* Значение должно быть не меньше "},
					"noSpecialCaracters":{
						"regex":"/^[0-9a-zA-Z]+$/",
						"alertText":"* Запрещены специальные символы"},	
					"ajaxUser":{
						"file":"validateUser.php",
						"extraData":"name=eric",
						"alertTextOk":"* Этот пользователь доступен",	
						"alertTextLoad":"* Загрузка, подождите",
						"alertText":"* Этот пользователь уже занят"},	
					"ajaxName":{
						"file":"validateUser.php",
						"alertText":"* Это имя уже занято",
						"alertTextOk":"* Это имя доступно",	
						"alertTextLoad":"* Загрузка"},		
					"onlyLetter":{
						"regex":"/^[a-zA-Z\ \']+$/",
						"alertText":"* Только буквы"},
					"validate2fields":{
    					"nname":"validate2fields",
    					"alertText":"* Вы должны заполнить поля с именем и фамилией"}	
					}	
					
		}
	}
})(jQuery);

$(document).ready(function() {	
	$.validationEngineLanguage.newLang()
});