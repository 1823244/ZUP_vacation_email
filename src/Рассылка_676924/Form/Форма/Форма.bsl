﻿

#Область ОбработчикиСобытийЭлементовТаблицыФормыГрафикОтпусков

&НаКлиенте
Процедура ГрафикОтпусковВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ИмяЗначенияРеквизита = СтрЗаменить(Поле.Имя, "ГрафикОтпусков", "");
	
	ПоказатьЗначение(, Элементы.ГрафикОтпусков.ТекущиеДанные[ИмяЗначенияРеквизита]);

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьТаблицу(Команда)
	ЗаполнитьТаблицуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьРассылку(Команда)
	Если Модифицированность = Истина Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопроса",ЭтотОбъект), 
			"Перед выполнением рассылки требуется сохранить настройки! Ок?", РежимДиалогаВопрос.ОКОтмена);
	Иначе
		ВыполнитьРассылкуНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьТаблицуНаСервере()
	
	ОбработкаОбъект_ = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект_.ЗаполнитьДокументыДляРассылки();
	ЗначениеВРеквизитФормы(ОбработкаОбъект_, "Объект");
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьРассылкуНаСервере()
	
	РеквизитФормыВЗначение("Объект").ВыполнитьРассылку();
	
	ЗаполнитьТаблицуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьНастройки(Команда)
	СохранитьНастройкиСервер();
	Модифицированность=Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопроса( Результат, Парам2 ) Экспорт
	
    Если Результат = КодВозвратаДиалога.Отмена Тогда
        Возврат;
	КонецЕсли; 
	
	СохранитьНастройки(Неопределено);
	
	ВыполнитьРассылкуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиСервер()
	
	Попытка
		ТЗ = Объект.СписокПолучателей.Выгрузить();
	Исключение
		а=2;
	КонецПопытки;
	
	а=1;
	ШаблонТелаПисьма = СокрЛП(ШаблонПисьма);
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	//ОрганизацияПараметр = ?(ИспользоватьНесколькоОрганизаций, Организация, Неопределено);
	ОрганизацияПараметр = Организация;
	
	СтруктураНастроек = Новый Структура("ТЗАдресов, Тема, ГлубинаПроверки, Тело, Организация",ТЗ, Объект.ТемаПисьма, Объект.ГлубинаПроверки, ШаблонТелаПисьма, ОрганизацияПараметр);
	
	
	ХранилищеОбщихНастроек.Сохранить("РассылкаОтпусков_676924","СтруктураНастроек", СтруктураНастроек,,"Пользователь_676924");
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИспользоватьНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	СтруктураНастроек = ХранилищеОбщихНастроек.Загрузить("РассылкаОтпусков_676924","СтруктураНастроек",,"Пользователь_676924");
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
	
		Попытка
			ТЗ = СтруктураНастроек.ТЗАдресов;
			Объект.СписокПолучателей.Очистить();
			Для каждого Стр Из ТЗ Цикл
				НовСтр = Объект.СписокПолучателей.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтр, Стр);
			КонецЦикла;
			Объект.ТемаПисьма = СтруктураНастроек.Тема;
			Объект.ГлубинаПроверки = СтруктураНастроек.ГлубинаПроверки;
			Если СтруктураНастроек.Свойство("Тело") И ЗначениеЗаполнено(СтруктураНастроек.Тело) Тогда
				ШаблонПисьма = СтруктураНастроек.Тело;
			КонецЕсли;
			
		Исключение
		    //ОписаниеОшибки()
		КонецПопытки;
		
		Если СтруктураНастроек.Свойство("Организация") И ЗначениеЗаполнено(СтруктураНастроек.Организация) Тогда
			Организация = СтруктураНастроек.Организация;
		Иначе
			ЗаполняемыеЗначения = Новый Структура("Организация", Неопределено);
			ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
			Организация = ЗаполняемыеЗначения.Организация;
		КонецЕсли;
	Иначе
		
		ЗаполняемыеЗначения = Новый Структура("Организация", Неопределено);
		ЗарплатаКадры.ПолучитьЗначенияПоУмолчанию(ЗаполняемыеЗначения);
		Организация = ЗаполняемыеЗначения.Организация;		
		
	КонецЕсли;
	
	Если СтруктураНастроек.Свойство("ГлубинаПроверки") И ЗначениеЗаполнено(СтруктураНастроек.ГлубинаПроверки) Тогда
		ГлубинаПроверки = СтруктураНастроек.ГлубинаПроверки;
		Объект.Период.ДатаНачала = НачалоДня(ТекущаяДата());
		Объект.Период.ДатаОкончания = НачалоДня(НачалоДня(ТекущаяДата())+86400*ГлубинаПроверки);
	КонецЕсли;
	
	Элементы.Организация.Видимость = Истина;//ИспользоватьНесколькоОрганизаций;    // для отладки
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьШаблонПоУмолчанию(Команда)
	
	СписокШаблонов = Новый СписокЗначений;
	СписокШаблонов.Добавить(ШаблонПисьмаСотрудникиСписком(), "Сотрудники списком");
	СписокШаблонов.Добавить(ШаблонПисьмаСотрудникиПоОдному(), "Сотрудники по-одному");
	ПоказатьВыборИзМеню(Новый ОписаниеОповещения("ОбработатьВыборИзСписка",ЭтотОбъект), СписокШаблонов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВыборИзСписка(парам1, парам2) Экспорт
    Если парам1 = Неопределено Тогда
        Возврат;
	КонецЕсли; 
	ШаблонПисьма = парам1.Значение;
	Модифицированность=Истина;
КонецПроцедуры	

&НаСервере
Функция ШаблонПисьмаСотрудникиСписком()
	
	Об = РеквизитФормыВЗначение("Объект");
	Макет = Об.ПолучитьМакет("ШаблонПисьмаСотрудникиСписком");
	Возврат Макет.ПолучитьТекст();
		
КонецФункции

&НаСервере
Функция ШаблонПисьмаСотрудникиПоОдному()
	
	Об = РеквизитФормыВЗначение("Объект");
	Макет = Об.ПолучитьМакет("ШаблонПисьмаСотрудникиПоОдному");
	Возврат Макет.ПолучитьТекст();
		
КонецФункции

&НаКлиенте
Процедура ГлубинаПроверкиПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ТемаПисьмаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокПолучателейПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШаблонПисьмаПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

#КонецОбласти