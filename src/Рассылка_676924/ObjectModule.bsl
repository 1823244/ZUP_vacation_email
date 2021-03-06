﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает сведения о внешней обработке. !
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = ДополнительныеОтчетыИОбработки.СведенияОВнешнейОбработке("2.3.4.71");
	ПараметрыРегистрации.Информация = НСтр("ru = 'Рассылка уведомлений по отпускам'");
	ПараметрыРегистрации.Вид = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка();
	ПараметрыРегистрации.Версия = "1.1.2.0";
	ПараметрыРегистрации.БезопасныйРежим = Ложь;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Открыть главную форму'");
	Команда.Идентификатор = "ОткрытьФормуОбработки";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыОткрытиеФормы();
	Команда.ПоказыватьОповещение = Истина;
	
	Команда = ПараметрыРегистрации.Команды.Добавить();
	Команда.Представление = НСтр("ru = 'Разослать уведомления по графику отпусков (для настройки расписания)'");
	Команда.Идентификатор = "РазослатьУведомления";
	Команда.Использование = ДополнительныеОтчетыИОбработкиКлиентСервер.ТипКомандыВызовСерверногоМетода();
	Команда.ПоказыватьОповещение = Истина;
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

Процедура ЗаполнитьДокументыДляРассылки(ЗапускИзРегламентногоЗадания=Ложь) Экспорт

	ГрафикОтпусков.Очистить();	
	

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ПлановыеЕжегодныеОтпуска.Перенесен
		|			ТОГДА ПлановыеЕжегодныеОтпуска.ДокументПереноса
		|		ИНАЧЕ ПлановыеЕжегодныеОтпуска.ДокументПланирования
		|	КОНЕЦ КАК ДокументПланированияОтпуска,
		|	ВЫБОР
		|		КОГДА ПлановыеЕжегодныеОтпуска.Перенесен
		|			ТОГДА ПлановыеЕжегодныеОтпуска.ПеренесеннаяДатаНачала
		|		ИНАЧЕ ПлановыеЕжегодныеОтпуска.ДатаНачала
		|	КОНЕЦ КАК ДатаНачалаОтпуска,
		|	ВЫБОР
		|		КОГДА ПлановыеЕжегодныеОтпуска.Перенесен
		|			ТОГДА ПлановыеЕжегодныеОтпуска.ДокументПереноса.ДатаОкончания
		|		ИНАЧЕ ПлановыеЕжегодныеОтпуска.ДатаОкончания
		|	КОНЕЦ КАК ДатаОкончанияОтпуска,
		|	ВЫБОР
		|		КОГДА ПлановыеЕжегодныеОтпуска.Перенесен
		|			ТОГДА ПлановыеЕжегодныеОтпуска.ДокументПереноса.КоличествоДней
		|		ИНАЧЕ ПлановыеЕжегодныеОтпуска.КоличествоДней
		|	КОНЕЦ КАК КоличествоДнейОтпуска,
		|	ПлановыеЕжегодныеОтпуска.Сотрудник,
		|	ЕСТЬNULL(ФизическиеЛицаКонтактнаяИнформация.Представление, """") КАК АдресЭПСотрудника,
		|	ЕСТЬNULL(ПлановыеЕжегодныеОтпуска.Сотрудник.ФизическоеЛицо.ГруппаДоступа, ЗНАЧЕНИЕ(Справочник.ГруппыДоступаФизическихЛиц.ПустаяСсылка)) КАК ГруппаДоступаФизическогоЛица
		|ПОМЕСТИТЬ ВТплан
		|ИЗ
		|	РегистрСведений.ПлановыеЕжегодныеОтпуска КАК ПлановыеЕжегодныеОтпуска
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|		ПО ПлановыеЕжегодныеОтпуска.Сотрудник.ФизическоеЛицо = ФизическиеЛицаКонтактнаяИнформация.Ссылка
		|			И (ФизическиеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EMailФизическиеЛица))
		|ГДЕ
		|	ВЫБОР
		|			КОГДА ПлановыеЕжегодныеОтпуска.Перенесен
		|				ТОГДА &УсловиеНаДатуНачала1 И &УсловиеНаДатуОкончания1
		|			ИНАЧЕ &УсловиеНаДатуНачала2 И &УсловиеНаДатуОкончания2
		|		КОНЕЦ
		|	И ВЫБОР
		|		КОГДА &ЕстьОрганизация = Истина
		|			ТОГДА ПлановыеЕжегодныеОтпуска.Организация = &Организация
		|		ИНАЧЕ
		|			ИСТИНА
		|		КОНЕЦ
		|;   
		|
		|
		| 
		|
		|ВЫБРАТЬ
		|
		|	Док.Ссылка КАК ДокументПланированияОтпуска,
		|	Док.ДатаНачалаОсновногоОтпуска КАК ДатаНачалаОтпуска,
		|	Док.ДатаОкончанияОсновногоОтпуска КАК ДатаОкончанияОтпуска,
		|	Док.КоличествоДнейОсновногоОтпуска КАК КоличествоДнейОтпуска,
		|	Док.Сотрудник,
		|	ЕСТЬNULL(ФизическиеЛицаКонтактнаяИнформация.Представление, """") КАК АдресЭПСотрудника,
		|	ЕСТЬNULL(Док.Сотрудник.ФизическоеЛицо.ГруппаДоступа, ЗНАЧЕНИЕ(Справочник.ГруппыДоступаФизическихЛиц.ПустаяСсылка)) КАК ГруппаДоступаФизическогоЛица		
		|ПОМЕСТИТЬ ВТфакт
		|ИЗ
		|	Документ.Отпуск КАК Док
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ФизическиеЛица.КонтактнаяИнформация КАК ФизическиеЛицаКонтактнаяИнформация
		|		ПО Док.Сотрудник.ФизическоеЛицо = ФизическиеЛицаКонтактнаяИнформация.Ссылка
		|			И (ФизическиеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.EMailФизическиеЛица))
		|ГДЕ
		|	
		|	
		|	&УсловиеНаДатуНачала3 И &УсловиеНаДатуОкончания3
		|   И
		|   Док.Проведен = ИСТИНА
		|   И
		|	Док.ДатаНачалаОсновногоОтпуска <= &ДатаОтпусков
		|	И
		|	Док.ДатаНачалаОсновногоОтпуска >= &ТекДата
		|	И ВЫБОР
		|		КОГДА &ЕстьОрганизация = Истина
		|			ТОГДА Док.Организация = &Организация
		|		ИНАЧЕ
		|			ИСТИНА
		|		КОНЕЦ
		|;
		|
		|ВЫБРАТЬ
		|
		|	ЕСТЬNULL(ВТфакт.ДокументПланированияОтпуска, 	ВТплан.ДокументПланированияОтпуска) КАК ДокументПланированияОтпуска,
		|	ЕСТЬNULL(ВТфакт.ДатаНачалаОтпуска,				ВТплан.ДатаНачалаОтпуска) КАК ДатаНачалаОтпуска,
		|	ЕСТЬNULL(ВТфакт.ДатаОкончанияОтпуска, 			ВТплан.ДатаОкончанияОтпуска) КАК ДатаОкончанияОтпуска,
		|	ЕСТЬNULL(ВТфакт.КоличествоДнейОтпуска, 			ВТплан.КоличествоДнейОтпуска) КАК КоличествоДнейОтпуска,
		|	ЕСТЬNULL(ВТфакт.Сотрудник,						ВТплан.Сотрудник) КАК Сотрудник,
		|	ЕСТЬNULL(ВТфакт.АдресЭПСотрудника, 				ВТплан.АдресЭПСотрудника) КАК АдресЭПСотрудника,
		|	ЕСТЬNULL(ВТфакт.ГруппаДоступаФизическогоЛица, 	ВТплан.ГруппаДоступаФизическогоЛица) КАК ГруппаДоступаФизическогоЛица
		|
		|ИЗ
		|	ВТфакт
		|	ПОЛНОЕ СОЕДИНЕНИЕ ВТплан
		|	ПО ВТплан.Сотрудник = ВТфакт.Сотрудник
		|
		|
		|";
	
	МетаданныеПереносаОтпуска = Метаданные.Документы.ПереносОтпуска;
	Если МетаданныеПереносаОтпуска.реквизиты.Найти("УдалитьДатаОкончания") <> Неопределено Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст , "ПлановыеЕжегодныеОтпуска.ДокументПереноса.ДатаОкончания", "ПлановыеЕжегодныеОтпуска.ДокументПереноса.УдалитьДатаОкончания");
		Запрос.Текст = СтрЗаменить(Запрос.Текст , "ПлановыеЕжегодныеОтпуска.ДокументПереноса.КоличествоДней", "ПлановыеЕжегодныеОтпуска.ДокументПереноса.УдалитьКоличествоДней");
	КонецЕсли; 
	
	СтруктураНастроек = ХранилищеОбщихНастроек.Загрузить("РассылкаОтпусков_676924","СтруктураНастроек",,"Пользователь_676924");
	Если ТипЗнч(СтруктураНастроек)<>Тип("Структура") Тогда
		ГлубинаПроверки = 7;
	Иначе
		ГлубинаПроверки = СтруктураНастроек.ГлубинаПроверки;
	КонецЕсли;
	Запрос.УстановитьПараметр("ДатаОтпусков",НачалоДня(ТекущаяДата())+86400*ГлубинаПроверки);
	Запрос.УстановитьПараметр("ТекДата",НачалоДня(ТекущаяДата()));
	
	
	Если ЗапускИзРегламентногоЗадания=Истина Тогда
		Период.ДатаНачала = НачалоДня(ТекущаяДата());
		Период.ДатаОкончания = НачалоДня(НачалоДня(ТекущаяДата())+86400*ГлубинаПроверки);
	КонецЕсли;
	
	НачалоПериода 		= Период.ДатаНачала;
	ОкончаниеПериода 	= Период.ДатаОкончания;
	
	Если ЗначениеЗаполнено(НачалоПериода) Тогда
		Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуНачала1", "ПлановыеЕжегодныеОтпуска.ПеренесеннаяДатаНачала >= &НачалоПериода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуНачала2", "ПлановыеЕжегодныеОтпуска.ДатаНачала >= &НачалоПериода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуНачала3", "Док.ДатаНачалаОсновногоОтпуска >= &НачалоПериода");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуНачала1", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуНачала2", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуНачала3", "Истина");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОкончаниеПериода) Тогда
		Запрос.УстановитьПараметр("ОкончаниеПериода", ОкончаниеПериода);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуОкончания1", "ПлановыеЕжегодныеОтпуска.ПеренесеннаяДатаНачала <= &ОкончаниеПериода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуОкончания2", "ПлановыеЕжегодныеОтпуска.ДатаНачала <= &ОкончаниеПериода");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуОкончания3", "Док.ДатаНачалаОсновногоОтпуска <= &ОкончаниеПериода");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуОкончания1", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуОкончания2", "Истина");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеНаДатуОкончания3", "Истина");
	КонецЕсли;
	
	Если ТипЗнч(СтруктураНастроек)=Тип("Структура") И СтруктураНастроек.Свойство("Организация") И ЗначениеЗаполнено(СтруктураНастроек.Организация) Тогда
		ОрганизацияПараметр = СтруктураНастроек.Организация;
		Запрос.УстановитьПараметр("Организация",ОрганизацияПараметр);
		Запрос.УстановитьПараметр("ЕстьОрганизация",Истина);
	Иначе
		Запрос.УстановитьПараметр("Организация",Неопределено);
		Запрос.УстановитьПараметр("ЕстьОрганизация",Ложь);
	КонецЕсли;
	
	//+---------------------------------------------------------------
	//|		ВЫПОЛНЯЕМ ЗАПРОС
	//+---------------------------------------------------------------
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли;	
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ГрафикОтпусков.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
	КонецЦикла;
	
	МассивСотрудников = ГрафикОтпусков.ВыгрузитьКолонку("Сотрудник");
	КадровыеДанные = КадровыйУчет.КадровыеДанныеСотрудников(
		Истина, 
		МассивСотрудников, 
		"ТекущаяОрганизация,ФизическоеЛицо,ДолжностьПоШтатномуРасписанию,ВидЗанятости,Должность,Подразделение,Фамилия,Имя,Отчество", 
		ТекущаяДата());
		
	Для каждого СтрГрафикОтпусков Из ГрафикОтпусков Цикл

		СтрКадровыеДанные = КадровыеДанные.Найти(СтрГрафикОтпусков.Сотрудник, "Сотрудник");
		Если СтрКадровыеДанные <> Неопределено Тогда
			ЗаполнитьЗначенияСвойств(СтрГрафикОтпусков, СтрКадровыеДанные);
			СтрГрафикОтпусков.Организация = СтрКадровыеДанные.ТекущаяОрганизация;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьРассылку() Экспорт
	
	Если ГрафикОтпусков.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	
	
	ШаблонТелаПисьма = "";
	
	// получим адреса рассылки с закладки Настройки
	СтруктураНастроек = ХранилищеОбщихНастроек.Загрузить("РассылкаОтпусков_676924","СтруктураНастроек",,"Пользователь_676924");
	Если ТипЗнч(СтруктураНастроек)<>Тип("Структура") Тогда
		ВызватьИсключение "Сначала сохраните настройки!";
	Иначе
		ТЗАдресов = СтруктураНастроек.ТЗАдресов;
		Если ТипЗнч(ТЗАдресов) <> Тип("ТаблицаЗначений") Тогда
			ВызватьИсключение "Не заданы email-адреса для рассылки!"
		Иначе
			Если ТЗАдресов.Количество()=0 Тогда
				ВызватьИсключение "Не заданы email-адреса для рассылки!"
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(СтруктураНастроек.Тема) Тогда
			ВызватьИсключение "Не задана тема письма!";
		КонецЕсли;
		
		Если СтруктураНастроек.Свойство("Тело") И ЗначениеЗаполнено(СтруктураНастроек.Тело) Тогда
			ШаблонТелаПисьма = СтруктураНастроек.Тело;
		КонецЕсли;
		
	КонецЕсли;
		
	ИменаРеквизитовТабличнойЧасти = Новый Массив;
	РеквизитыТабличнойЧасти = ЭтотОбъект.Метаданные().ТабличныеЧасти[0].Реквизиты;
	Для Каждого РеквизитТабличнойЧасти Из РеквизитыТабличнойЧасти Цикл
		ИменаРеквизитовТабличнойЧасти.Добавить(РеквизитТабличнойЧасти.Имя);
	КонецЦикла;	
	
	Тема = СтруктураНастроек.Тема;
	
	
	СотрудникиСписком = Ложь;
	Если СокрЛП(ШаблонТелаПисьма)<>"" Тогда
		ПозСписка = СтрНайти( НРег(ШаблонТелаПисьма), НРег("[СписокСотрудниковНачало]"));
		СотрудникиСписком = ПозСписка > 0;
		
		Если СотрудникиСписком = Истина Тогда
			
			ТекстПисьма = СоздатьТекстПисьмаПоШаблону( ШаблонТелаПисьма, СтруктураНастроек );
			
			// отправляем одно письмо со всем сотрудниками из таблицы
		
			ОсновныеПолучатели = Новый Массив;
			Для Каждого Стр Из ТЗАдресов Цикл
				ОсновныеПолучатели.Добавить(Новый Структура("Адрес, Представление", Стр.email, Стр.ФИО));
			КонецЦикла;
			
			ДобавляемыеПолучатели = Новый Массив;
			Для Каждого СтрокаТаблицы Из ГрафикОтпусков Цикл
				Если ЗначениеЗаполнено(СтрокаТаблицы.АдресЭПСотрудника) Тогда
					ДобавляемыеПолучатели.Добавить(Новый Структура("Адрес, Представление", СтрокаТаблицы.АдресЭПСотрудника, СтрокаТаблицы.Сотрудник));
				КонецЕсли;
			КонецЦикла;
			
			Для каждого эл Из ДобавляемыеПолучатели Цикл
				ОсновныеПолучатели.Добавить( эл );
			КонецЦикла;
			
			
			РезультатОтправкиСообщенияСотруднику = ВыполнитьОтправкуПисьма(ТекстПисьма, Тема, ОсновныеПолучатели, Неопределено);
			
		Иначе
			
			// отправляем по одному письму на каждую строку таблицы
			
			Для Каждого СтрокаТаблицы Из ГрафикОтпусков Цикл
				
				ТекстПисьма = СоздатьТекстПисьмаПоШаблону( ШаблонТелаПисьма, СтруктураНастроек, СтрокаТаблицы );
				
				ОсновныеПолучатели = Новый Массив;
				Для Каждого Стр Из ТЗАдресов Цикл
					ОсновныеПолучатели.Добавить(Новый Структура("Адрес, Представление", Стр.email, Стр.ФИО));
				КонецЦикла;
				
				ДобавляемыеПолучатели = Новый Массив;
				Если ЗначениеЗаполнено(СтрокаТаблицы.АдресЭПСотрудника) Тогда
					ДобавляемыеПолучатели.Добавить(Новый Структура("Адрес, Представление", СтрокаТаблицы.АдресЭПСотрудника, СтрокаТаблицы.Сотрудник));
				КонецЕсли;
				
				Для каждого эл Из ДобавляемыеПолучатели Цикл
					ОсновныеПолучатели.Добавить( эл );
				КонецЦикла;
				
				РезультатОтправкиСообщенияСотруднику = ВыполнитьОтправкуПисьма(ТекстПисьма, Тема, ОсновныеПолучатели, Неопределено);
				
			КонецЦикла;
			
		КонецЕсли;
		
		
	Иначе
		
		// нет шаблона письма
		
		ОсновныеПолучатели = Новый Массив;
		Для Каждого Стр Из ТЗАдресов Цикл
			ОсновныеПолучатели.Добавить(Новый Структура("Адрес, Представление", Стр.email, Стр.ФИО));
		КонецЦикла;
		
		ТекстПисьма = "Автоматическая рассылка оповещения о приближающихся отпусках.
		|
		|Информируем вас, что через "+СтруктураНастроек.ГлубинаПроверки+" дней или ранее в отпуск уходят следующие сотрудники:
		|
		|";
		
		Для Каждого СтрокаТаблицы Из ГрафикОтпусков Цикл
			
			ПараметрыТекстаПисьма = ЗаполняемыеПараметрыТекста(СтрокаТаблицы, ИменаРеквизитовТабличнойЧасти);

			ДобавляемыеПолучатели = Новый Массив;
			Если ЗначениеЗаполнено(СтрокаТаблицы.АдресЭПСотрудника) Тогда
				ДобавляемыеПолучатели.Добавить(Новый Структура("Адрес, Представление", СтрокаТаблицы.АдресЭПСотрудника, ""));
			КонецЕсли;
			
			ТекстПисьма = ТекстПисьма + " - " + СтрокаТаблицы.Фамилия + " " + СтрокаТаблицы.Имя + " " + СтрокаТаблицы.Отчество + Символы.ПС; 
			ТекстПисьма = ТекстПисьма + "       " + "Период отпуска "+Формат(СтрокаТаблицы.ДатаНачалаОтпуска, "ДФ = дд.ММ.гггг")+" - "+Формат(СтрокаТаблицы.ДатаОкончанияОтпуска, "ДФ = дд.ММ.гггг") + Символы.ПС; 
			
		КонецЦикла;	
		
		ТекстПисьма = ТекстПисьма + "
		|"+Формат(ТекущаяДата(), "ДФ=дд.ММ.гггг");		
		
		Для каждого эл Из ДобавляемыеПолучатели Цикл
			ОсновныеПолучатели.Добавить( эл );
		КонецЦикла;
		
		РезультатОтправкиСообщенияСотруднику = ВыполнитьОтправкуПисьма(ТекстПисьма, Тема, ОсновныеПолучатели, Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьКоманду(ИмяКоманды, ПараметрыВыполнения) Экспорт
	
	ДатаЗавершенияВМиллисекундах = ТекущаяУниверсальнаяДатаВМиллисекундах() + 4;
	
	ПараметрыРегистрации = СведенияОВнешнейОбработке();
	ПараметрыРегистрации.Команды.Колонки.Идентификатор.Имя = "ИмяКоманды";
	ЭтаКоманда = ПараметрыРегистрации.Команды.Найти(ИмяКоманды, "ИмяКоманды");
	Если ЭтаКоманда = Неопределено Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Команда ""%1"" не поддерживается обработкой ""%2""'"),
			ИмяКоманды,
			Метаданные().Представление());
	КонецЕсли;
	
	Если ИмяКоманды = "РазослатьУведомления" Тогда
		ЗапускИзРегламентногоЗадания=Истина;
		ЗаполнитьДокументыДляРассылки(ЗапускИзРегламентногоЗадания);
		ВыполнитьРассылку();
	КонецЕсли;
	
	// Имитация длительной операции.
	Пока ТекущаяУниверсальнаяДатаВМиллисекундах() < ДатаЗавершенияВМиллисекундах Цикл
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СоздатьТекстПисьмаПоШаблону( Знач ТекстПисьма, СтруктураНастроек, ТекСтрокаТаблицыОтпусков = Неопределено )
	
	//		Глубина проверки
	
	Если СтрНайти( НРег(ТекстПисьма), НРег("[ГлубинаПроверки]") ) > 0 Тогда
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "[ГлубинаПроверки]", СтруктураНастроек.ГлубинаПроверки);
	КонецЕсли;
	
	//		ОРГАНИЗАЦИЯ
	
	Если СтрНайти( НРег(ТекстПисьма), НРег("[Организация]") ) > 0 Тогда
		
		// Если организация есть в настройках - берем её
		Если ТипЗнч(СтруктураНастроек)=Тип("Структура") И СтруктураНастроек.Свойство("Организация") И ЗначениеЗаполнено(СтруктураНастроек.Организация) Тогда
			ОрганизацияПараметр = СтруктураНастроек.Организация;
		Иначе
			// Если в настройках организации нет, то берем значение по-умолчанию для текущей базы
			ЗаполняемыеЗначения = Новый Структура("Организация", Неопределено);
			ЗарплатаКадры.ЗаполнитьЗначениеОрганизацииПоУмолчанию(ЗаполняемыеЗначения);
			ОрганизацияПараметр = ЗаполняемыеЗначения.Организация;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ОрганизацияПараметр) Тогда
			ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Организация]", ОрганизацияПараметр.Наименование);
		Иначе
			ТекстПисьма = СтрЗаменить(ТекстПисьма, "[Организация]", "<>");
		КонецЕсли;
		
	КонецЕсли;
	
	// 		текущая дата
	
	Если СтрНайти( НРег(ТекстПисьма), НРег("[ТекущаяДата]") ) > 0 Тогда
		ТекстПисьма = СтрЗаменить(ТекстПисьма, "[ТекущаяДата]", Формат(ТекущаяДата(), "ДФ=дд.ММ.гггг"));
	КонецЕсли;
	
	// 		Список сотрудников
	
	ТекстПисьмаСписокСотрудников = "";
	ПозСписка = СтрНайти( НРег(ТекстПисьма), НРег("[СписокСотрудниковНачало]"));
	Если ПозСписка > 0 Тогда
		
		
		ПозСпискаКонец = СтрНайти( НРег(ТекстПисьма), НРег("[СписокСотрудниковКонец]"));
		СтрокаСотрудникаШаблон = СокрЛП( Сред(ТекстПисьма, ПозСписка + 25, (ПозСпискаКонец-1) - (ПозСписка + 25)) );
		
		Для Каждого СтрокаТаблицы Из ГрафикОтпусков Цикл
			
			ТекстСотрудника = СтрокаСотрудникаШаблон;
			
			ЗаполнитьДанныеСотрудника( ТекстСотрудника, СтрокаТаблицы );
			
			ТекстПисьмаСписокСотрудников = ТекстПисьмаСписокСотрудников + ТекстСотрудника + Символы.ПС + Символы.ПС;
			
		КонецЦикла;
		
		ТекстПисьма1 = СокрЛП( Лев( ТекстПисьма, ПозСписка - 1 ) );
		ТекстПисьма2 = СокрЛП( Сред( ТекстПисьма, ПозСпискаКонец + 24 ) );
		
		ТекстПисьма = ТекстПисьма1 + Символы.ПС + Символы.ПС + ТекстПисьмаСписокСотрудников + Символы.ПС + ТекстПисьма2;
		
	Иначе
		ЗаполнитьДанныеСотрудника( ТекстПисьма, ТекСтрокаТаблицыОтпусков );
		
	КонецЕсли;
	
		
	Возврат ТекстПисьма;
		
КонецФункции

Функция ЗаполнитьДанныеСотрудника( ТекстСотрудника, ТекСтрокаТаблицыОтпусков )
	
	Если СтрНайти( НРег(ТекстСотрудника), НРег("[Сотрудник]") )>0 Тогда
		ТекстСотрудника = СтрЗаменить( ТекстСотрудника, "[Сотрудник]", Строка(ТекСтрокаТаблицыОтпусков.Сотрудник) );
	КонецЕсли;
	
	Если СтрНайти( НРег(ТекстСотрудника), НРег("[Должность]") )>0 Тогда
		ТекстСотрудника = СтрЗаменить( ТекстСотрудника, "[Должность]", Строка(ТекСтрокаТаблицыОтпусков.Должность) );
	КонецЕсли;
	
	Если СтрНайти( НРег(ТекстСотрудника), НРег("[Подразделение]") )>0 Тогда
		ТекстСотрудника = СтрЗаменить( ТекстСотрудника, "[Подразделение]", Строка(ТекСтрокаТаблицыОтпусков.Подразделение) );
	КонецЕсли;
	
	Если СтрНайти( НРег(ТекстСотрудника), НРег("[ДатаНачалаОтпуска]") )>0 Тогда
		ТекстСотрудника = СтрЗаменить( ТекстСотрудника, "[ДатаНачалаОтпуска]", Формат(ТекСтрокаТаблицыОтпусков.ДатаНачалаОтпуска, "ДФ = дд.ММ.гггг") );
	КонецЕсли;
	
	Если СтрНайти( НРег(ТекстСотрудника), НРег("[ДатаОкончанияОтпуска]") )>0 Тогда
		ТекстСотрудника = СтрЗаменить( ТекстСотрудника, "[ДатаОкончанияОтпуска]", Формат(ТекСтрокаТаблицыОтпусков.ДатаОкончанияОтпуска, "ДФ = дд.ММ.гггг") );
	КонецЕсли;
	
	Если СтрНайти( НРег(ТекстСотрудника), НРег("[ВсегоДней]") )>0 Тогда
		ТекстСотрудника = СтрЗаменить( ТекстСотрудника, "[ВсегоДней]", Строка(ТекСтрокаТаблицыОтпусков.КоличествоДнейОтпуска) );
	КонецЕсли;
	
КонецФункции

Функция ВыполнитьОтправкуПисьма(Знач ТелоПисьма, Знач Тема, Получатели, ЗаменяемыеПараметрыТекстаПисьма = Неопределено)
	
	Результат = Новый Структура("Отправлено, ОписаниеОшибки", Ложь);

	ПараметрыПисьма = Новый Структура();
	ПараметрыПисьма.Вставить("Тема", Тема);
	ПараметрыПисьма.Вставить("Кодировка", "utf-8");
	ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст);
	
	Если ЗначениеЗаполнено(ЗаменяемыеПараметрыТекстаПисьма) Тогда
		
		Для Каждого ЗаменяемыйПараметрТекста Из ЗаменяемыеПараметрыТекстаПисьма Цикл
			ТелоПисьма = СтрЗаменить(ТелоПисьма, ЗаменяемыйПараметрТекста.Имя, ЗаменяемыйПараметрТекста.Значение);
		КонецЦикла;	
		
	КонецЕсли;
	
	ПараметрыПисьма.Вставить("Тело", ТелоПисьма);
	ПараметрыПисьма.Вставить("Кому", Получатели);
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		МодульРаботаСПочтовымиСообщениями = ОбщегоНазначения.ОбщийМодуль("РаботаСПочтовымиСообщениями");
		Если МодульРаботаСПочтовымиСообщениями.ДоступнаОтправкаПисем() Тогда
			УчетнаяЗапись = МодульРаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
			МодульРаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
			Результат.Отправлено = Истина;
		Иначе
			Результат.ОписаниеОшибки  = НСтр("ru = 'Сообщение не может быть отправлено сразу.'");
			Возврат Результат;
		КонецЕсли;
	КонецЕсли;

	Возврат Результат;
	
КонецФункции	

Функция ЗаполняемыеПараметрыТекста(Знач СтрокаТабличнойЧасти, ИменаРеквизитовТабличнойЧасти)
	
	МассивВозврата = Новый Массив;
	
	Для Каждого ИмяРеквизита Из ИменаРеквизитовТабличнойЧасти Цикл
		
		ЗначениеСтрокиТаблицы = СтрокаТабличнойЧасти[ИмяРеквизита];
		
		Если ТипЗнч(ЗначениеСтрокиТаблицы) = Тип("Дата") Тогда
			ЗначениеСтрокиТаблицы = Формат(ЗначениеСтрокиТаблицы, "ДФ=dd.MM.yyyy");
		КонецЕсли;	
		
		ИмяРеквизитаДляТекста = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("[%1]", ИмяРеквизита);
		
		МассивВозврата.Добавить(Новый Структура("Имя, Значение", ИмяРеквизитаДляТекста, ЗначениеСтрокиТаблицы));
		
	КонецЦикла;	
	
	Возврат МассивВозврата;
	
КонецФункции	

#КонецОбласти

#КонецЕсли

