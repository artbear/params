#Использовать "../src"
#Использовать asserts
#Использовать cmdline
#Использовать tempfiles
#Использовать 1commands

Перем юТест;

Перем МенеджерВременныхФайлов;
Перем ТекущийКаталогСохр;

Функция ПолучитьСписокТестов(Тестирование) Экспорт
	
	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	СписокТестов.Добавить("Тест_ЧтениеПараметровКоманднойСтроки");
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзФайла");
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзПлоскогоФайлаБезКлючаПоУмолчанию");
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзПереданногоФайлаПоУмолчанию");
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзФайлаПоУмолчанию");
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзФайлаСКомментариями");
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзФайлаПоСсылке");
	СписокТестов.Добавить("Тест_ПриоритетКоманднойСтрокиНадПараметрамиИзФайла");
	
	СписокТестов.Добавить("Тест_ЧтениеПараметровКомандыИзКоманднойСтроки");
	СписокТестов.Добавить("Тест_ЧтениеПараметровКомандыИзФайла");
	СписокТестов.Добавить("Тест_ПриоритетПараметровКомандыВФайлеНадДефолтнымиПараметрамиИзФайла");
	СписокТестов.Добавить("Тест_ПриоритетКоманднойСтрокиНадПараметрамиКомандыИзФайла");

	СписокТестов.Добавить("Тест_ЧтениеПараметровИзПеременныхСреды");
	СписокТестов.Добавить("Тест_ЧтениеПараметровКомандыИзПеременныхСреды");
	СписокТестов.Добавить("Тест_ПриоритетПеременныхСредыНадПараметрамиИзФайла");
	
	СписокТестов.Добавить("Тест_ПолучитьВнешнееСоответствиеПеременныхОкруженияПараметрамКоманд");
	
	СписокТестов.Добавить("Тест_ПроверяетВсюЦепочкуПриоритетов");
	СписокТестов.Добавить("Тест_ПроверяетВсюЦепочкуПриоритетовДляКоманды");
	
	СписокТестов.Добавить("Тест_ЧтениеПараметровИзНеСуществующегоФайла");

	Возврат СписокТестов;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	МенеджерВременныхФайлов = Новый МенеджерВременныхФайлов;
	МенеджерВременныхФайлов.БазовыйКаталог = МенеджерВременныхФайлов.СоздатьКаталог();

	ТекущийКаталогСохр = ТекущийКаталог();
	УстановитьТекущийКаталог(МенеджерВременныхФайлов.БазовыйКаталог);
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	УстановитьТекущийКаталог(ТекущийКаталогСохр);

	МенеджерВременныхФайлов.Удалить();
	МенеджерВременныхФайлов = Неопределено;

	ПараметрыСистемы.ИнициализироватьЛог();
КонецПроцедуры

Процедура Тест_ЧтениеПараметровКоманднойСтроки() Экспорт
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "4";
	
	ПутьФайлаНастроек = "1.txt";
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);
	ПараметрыКомСтроки.Добавить(ИМЯ_ПАРАМЕТРА);
	ПараметрыКомСтроки.Добавить(ЗНАЧЕНИЕ_ПАРАМЕТРА);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзФайла() Экспорт
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;
	
	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""default"" : { ""%1"": %2 } }", 
		ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА) );

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзФайлаСКомментариями() Экспорт
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;
	
	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон(
		"{ 
		| // простой комментарий
		|""%1"": %2, // вложенный комментарий 
		|""ЗначениямиСоСлешами"" : ""не комментарий""
		| }", 
		ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА) );

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
	Ожидаем.Что(Параметры["ЗначениямиСоСлешами"]).Равно("не комментарий");
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзФайлаПоСсылке() Экспорт
	ПараметрыСистемы.ИнициализироватьЛог("Отладка");
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);

	ПутьВложенногоФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьВложенногоФайлаНастроек, СтрШаблон("{ ""%1"": %2 }", 
		ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА) );
	ВложенныйФайл = Новый Файл(ПутьВложенногоФайлаНастроек);
		
	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон(
		"{ 
		| ""ReadFile"" : ""%1""
		| }", ВложенныйФайл.Имя) );

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"], "Команда").Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ], "ИМЯ_НАСТРОЙКИ").Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА], "ИМЯ_ПАРАМЕТРА").Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзПереданногоФайлаПоУмолчанию() Экспорт
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;
	
	ПутьФайлаНастроекПоУмолчанию = МенеджерВременныхФайлов.СоздатьФайл("json");
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроекПоУмолчанию, СтрШаблон("{ ""%1"": %2 } ", 
		ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА) );

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);

	ПараметрыКомСтроки = Новый Массив;

	ЧитательПараметров = Новый ЧитательПараметров;
	ЧитательПараметров.УстановитьФайлПоУмолчанию(ПутьФайлаНастроекПоУмолчанию);

	Параметры = ЧитательПараметров.Прочитать(Парсер, ПараметрыКомСтроки);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзФайлаПоУмолчанию() Экспорт
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;
	ИМЯ_СКРИПТА = "test.os";
	
	ПутьФайлаНастроекПоУмолчанию = ОбъединитьПути(МенеджерВременныхФайлов.БазовыйКаталог, 
		ЧтениеПараметров.ИмяФайлаНастроекПоУмолчанию());
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроекПоУмолчанию, СтрШаблон("{ ""%1"": %2 } ", 
		ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА) );

	ТекстСкрипта = "
	|#Использовать cmdline
	|#Использовать ""%1""
	|
	|Парсер = Новый ПарсерАргументовКоманднойСтроки();
	|Парсер.ДобавитьИменованныйПараметр(""%2"");
	|
	|Лог = Логирование.ПолучитьЛог(""%4"");
	|Лог.УстановитьУровень(УровниЛога.Отладка);
	|
	|Параметры = ЧтениеПараметров.Прочитать(Парсер, АргументыКоманднойСтроки);
	|
	|Если Параметры[""%2""] = %3 Тогда
	|	ЗавершитьРаботу(0);
	|Иначе
	|	ЗавершитьРаботу(1);
	|КонецЕсли;
	|";

	ТекстСкрипта = СтрШаблон(ТекстСкрипта, ПутьИсходников(), ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА,
		ПараметрыСистемы.ИмяЛогаСистемы());

	ПутьСкрипта = ОбъединитьПути(МенеджерВременныхФайлов.БазовыйКаталог, ИМЯ_СКРИПТА);
	СохранитьНастройкуВФайл(ПутьСкрипта, ТекстСкрипта);
	
	Команда = Новый Команда;
	Команда.УстановитьСтрокуЗапуска(СтрШаблон("oscript %1", ПутьСкрипта));
	// Команда.ПоказыватьВыводНемедленно(Истина);
	КодВозврата = Команда.Исполнить();

	СообщениеОшибки = СтрШаблон("Не удалось выполнить команду %1
	|%2", ПутьСкрипта, Команда.ПолучитьВывод());

	Ожидаем.Что(КодВозврата, СообщениеОшибки).Равно(0);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзПлоскогоФайлаБезКлючаПоУмолчанию() Экспорт
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;
	
	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""%1"": %2 } ", 
		ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА) );

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзНеСуществующегоФайла() Экспорт
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 3;
	
	ПутьФайлаНастроек = "НесуществующийПуть";

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Массив = Новый Массив;
	Массив.Добавить(Парсер);
	Массив.Добавить(ПараметрыКомСтроки);
	Массив.Добавить(ИМЯ_НАСТРОЙКИ);
	Массив.Добавить("");
	
	Ожидаем.Что(ЧтениеПараметров).Метод("Прочитать", Массив).ВыбрасываетИсключение("Файл настроек не существует");
КонецПроцедуры

Процедура Тест_ПриоритетКоманднойСтрокиНадПараметрамиИзФайла() Экспорт
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "4";

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""default"" : { ""%1"": ""НеверноеЗначение"" } }", 
		ИМЯ_ПАРАМЕТРА));

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);
	ПараметрыКомСтроки.Добавить(ИМЯ_ПАРАМЕТРА);
	ПараметрыКомСтроки.Добавить(ЗНАЧЕНИЕ_ПАРАМЕТРА);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровКомандыИзКоманднойСтроки() Экспорт
	
	ИМЯ_КОМАНДЫ = "test";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "41";

	ПутьФайлаНастроек = "1.txt";
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИМЯ_КОМАНДЫ);
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИМЯ_ПАРАМЕТРА);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ИМЯ_КОМАНДЫ);
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);
	ПараметрыКомСтроки.Добавить(ИМЯ_ПАРАМЕТРА);
	ПараметрыКомСтроки.Добавить(ЗНАЧЕНИЕ_ПАРАМЕТРА);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(ИМЯ_КОМАНДЫ);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровКомандыИзФайла() Экспорт
	ИМЯ_КОМАНДЫ = "test";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 5;

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");	

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИМЯ_КОМАНДЫ);
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИМЯ_ПАРАМЕТРА);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""%1"" : { ""%2"": %3 } }" , 
		ИМЯ_КОМАНДЫ, ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА));

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ИМЯ_КОМАНДЫ);
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(ИМЯ_КОМАНДЫ);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ПриоритетПараметровКомандыВФайлеНадДефолтнымиПараметрамиИзФайла() Экспорт

	ИМЯ_КОМАНДЫ = "test";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = 5;

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");	

	ТекстФайлаНастроек = "
	|{ ""default"" : { ""%2"": ""НеверноеЗначение"" }
	|, ""%1"" : { ""%2"": %3 }
	|}";
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон(ТекстФайлаНастроек , 
	ИМЯ_КОМАНДЫ, ИМЯ_ПАРАМЕТРА, ЗНАЧЕНИЕ_ПАРАМЕТРА));

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИМЯ_КОМАНДЫ);
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИМЯ_ПАРАМЕТРА);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ИМЯ_КОМАНДЫ);
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(ИМЯ_КОМАНДЫ);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ПриоритетКоманднойСтрокиНадПараметрамиКомандыИзФайла() Экспорт
	ИМЯ_КОМАНДЫ = "test";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "4";

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИМЯ_КОМАНДЫ);
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИМЯ_ПАРАМЕТРА);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""default"" : { ""%1"": ""НеверноеЗначение"" } }", 
		ИМЯ_ПАРАМЕТРА));

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ИМЯ_КОМАНДЫ);
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);
	ПараметрыКомСтроки.Добавить(ИМЯ_ПАРАМЕТРА);
	ПараметрыКомСтроки.Добавить(ЗНАЧЕНИЕ_ПАРАМЕТРА);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, ИМЯ_НАСТРОЙКИ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(ИМЯ_КОМАНДЫ);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровИзПеременныхСреды() Экспорт
	ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ = "PARAMS_TEST_";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "47";
	
	УстановитьПеременнуюСреды(СтрШаблон("%1%2", 
		ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ, ИМЯ_ПАРАМЕТРА), ЗНАЧЕНИЕ_ПАРАМЕТРА);
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	ПараметрыКомСтроки = Новый Массив;

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, "", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ);

	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ЧтениеПараметровКомандыИзПеременныхСреды() Экспорт
	ИМЯ_КОМАНДЫ = "test";
	ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ = "PARAMS_TEST_";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "47";
	
	УстановитьПеременнуюСреды(СтрШаблон("%1%2_%3", 
		ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ, ИМЯ_КОМАНДЫ, ИМЯ_ПАРАМЕТРА), ЗНАЧЕНИЕ_ПАРАМЕТРА);
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИМЯ_КОМАНДЫ);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИМЯ_ПАРАМЕТРА);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ИМЯ_КОМАНДЫ);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, "", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(ИМЯ_КОМАНДЫ);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ПриоритетПеременныхСредыНадПараметрамиИзФайла() Экспорт
	ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ = "PARAMS_TEST_";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "51";
	
	УстановитьПеременнуюСреды(СтрШаблон("%1%2", 
		ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ, ИМЯ_ПАРАМЕТРА), ЗНАЧЕНИЕ_ПАРАМЕТРА);

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""default"" : { ""%1"": ""НеверноеЗначение"" } }", 
		ИМЯ_ПАРАМЕТРА));
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);

	Параметры = ЧтениеПараметров.Прочитать(Парсер, ПараметрыКомСтроки, "", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ПолучитьВнешнееСоответствиеПеременныхОкруженияПараметрамКоманд() Экспорт
	ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ = "PARAMS_TEST_";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "47";
	
	ИмяПеременнойСредыПоУмолчанию = СтрШаблон("%1%2", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ, ИМЯ_ПАРАМЕТРА);
	УстановитьПеременнуюСреды(ИмяПеременнойСредыПоУмолчанию, Неопределено);
	
	ИмяПеременнойСредыДляСоответствия = СтрШаблон("ADD_%1", ИмяПеременнойСредыПоУмолчанию);
	УстановитьПеременнуюСреды(ИмяПеременнойСредыДляСоответствия, ЗНАЧЕНИЕ_ПАРАМЕТРА);
	
	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);
	
	СоответствиеПеременных = Новый Соответствие();
	СоответствиеПеременных.Вставить(ИмяПеременнойСредыДляСоответствия, ИМЯ_ПАРАМЕТРА);
	СоответствиеПеременных = Новый ФиксированноеСоответствие(СоответствиеПеременных);
	
	ЧитательПараметров = Новый ЧитательПараметров;
	ЧитательПараметров.ЗагрузитьСоответствиеПеременныхОкруженияПараметрамКоманд(СоответствиеПеременных);

	ПараметрыКомСтроки = Новый Массив;

	Параметры = ЧитательПараметров.Прочитать(Парсер, ПараметрыКомСтроки, "", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ);

	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ПроверяетВсюЦепочкуПриоритетов() Экспорт
	ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ = "PARAMS_TEST_";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "51";
	
	УстановитьПеременнуюСреды(СтрШаблон("%1%2", 
		ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ, ИМЯ_ПАРАМЕТРА), "НеверноеЗначение 2");

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""%1"": ""НеверноеЗначение"" }", 
		ИМЯ_ПАРАМЕТРА));

	ПутьФайлаНастроекПоУмолчанию = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьФайлаНастроекПоУмолчанию, СтрШаблон("{ ""%1"": ""НеверноеЗначениеПоУмолчанию"" }", 
		ИМЯ_ПАРАМЕТРА));

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	Парсер.ДобавитьПараметр(ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметр(ИМЯ_ПАРАМЕТРА);

	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);
	ПараметрыКомСтроки.Добавить(ИМЯ_ПАРАМЕТРА);
	ПараметрыКомСтроки.Добавить(ЗНАЧЕНИЕ_ПАРАМЕТРА);

	ЧитательПараметров = Новый ЧитательПараметров;
	ЧитательПараметров.УстановитьФайлПоУмолчанию(ПутьФайлаНастроекПоУмолчанию);

	Параметры = ЧитательПараметров.Прочитать(Парсер, ПараметрыКомСтроки, "", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(Неопределено);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура Тест_ПроверяетВсюЦепочкуПриоритетовДляКоманды() Экспорт
	ИМЯ_КОМАНДЫ = "test";
	ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ = "PARAMS_TEST_";
	ИМЯ_НАСТРОЙКИ = "Настройки";
	ИМЯ_ПАРАМЕТРА = "Параметр";
	ЗНАЧЕНИЕ_ПАРАМЕТРА = "51";
	
	УстановитьПеременнуюСреды(СтрШаблон("%1%2_%3", 
		ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ, ИМЯ_КОМАНДЫ, ИМЯ_ПАРАМЕТРА), "НеверноеЗначение 2");

	ПутьФайлаНастроек = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьФайлаНастроек, СтрШаблон("{ ""default"" : { ""%1"": ""НеверноеЗначение"" } }", 
		ИМЯ_ПАРАМЕТРА));

	ПутьФайлаНастроекПоУмолчанию = МенеджерВременныхФайлов.СоздатьФайл("json");
	СохранитьНастройкуВФайл(ПутьФайлаНастроекПоУмолчанию, СтрШаблон("{ ""%1"": ""НеверноеЗначениеПоУмолчанию"" }", 
		ИМЯ_ПАРАМЕТРА));

	Парсер = Новый ПарсерАргументовКоманднойСтроки();
	ОписаниеКоманды = Парсер.ОписаниеКоманды(ИМЯ_КОМАНДЫ);
	Парсер.ДобавитьПозиционныйПараметрКоманды(ОписаниеКоманды, ИМЯ_НАСТРОЙКИ);
	Парсер.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды, ИМЯ_ПАРАМЕТРА);
	Парсер.ДобавитьКоманду(ОписаниеКоманды);
	
	ПараметрыКомСтроки = Новый Массив;
	ПараметрыКомСтроки.Добавить(ИМЯ_КОМАНДЫ);
	ПараметрыКомСтроки.Добавить(ПутьФайлаНастроек);
	ПараметрыКомСтроки.Добавить(ИМЯ_ПАРАМЕТРА);
	ПараметрыКомСтроки.Добавить(ЗНАЧЕНИЕ_ПАРАМЕТРА);

	ЧитательПараметров = Новый ЧитательПараметров;
	ЧитательПараметров.УстановитьФайлПоУмолчанию(ПутьФайлаНастроекПоУмолчанию);

	Параметры = ЧитательПараметров.Прочитать(Парсер, ПараметрыКомСтроки, "", ПРЕФИКС_ПЕРЕМЕННЫХ_ОКРУЖЕНИЯ);

	Ожидаем.Что(Параметры).ИмеетТип("Соответствие");
	Ожидаем.Что(Параметры["Команда"]).Равно(ИМЯ_КОМАНДЫ);
	Ожидаем.Что(Параметры[ИМЯ_НАСТРОЙКИ]).Равно(ПутьФайлаНастроек);
	Ожидаем.Что(Параметры[ИМЯ_ПАРАМЕТРА]).Равно(ЗНАЧЕНИЕ_ПАРАМЕТРА);
КонецПроцедуры

Процедура СохранитьНастройкуВФайл(Знач ПутьФайлаНастроек, Знач СтрокаНастроек)
	ЗаписьТекста = Новый ЗаписьТекста(ПутьФайлаНастроек);
	ЗаписьТекста.ЗаписатьСтроку(СтрокаНастроек);
	ЗаписьТекста.Закрыть();
КонецПроцедуры

Функция ПутьИсходников()
	Возврат ОбъединитьПути(ТекущийСценарий().Каталог, "..", "src");
КонецФункции // ПутьИсходников()