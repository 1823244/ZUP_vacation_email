## Внешняя обработка, реализующая рассылку уведомлений о предстоящих отпусках для ЗУП 3.1 ПРОФ  

Может быть подключена через функционал дополнительных обработок БСП и запускаться по расписанию.  

https://infostart.ru/public/837180/  

## Описание и инструкция  

Обработка рассылает уведомления о предстоящих отпусках сотрудников. Возможна настройка собственного шаблона письма.
Обработка базируется на решении для ЗУП 3.1 версии КОРП, но сделана для версии ПРОФ. Основные отличия:
* Не используется справочник ШаблоныСообщений, т.к. его просто нет в данной конфигурации
* Настройки глубины просмотра, списка получателей, темы письма вынесены на форму обработки и сохраняются в хранилище общих настроек

2018-09-06. Добавлены шаблоны текста письма.

Ссылка на исходную публикацию //infostart.ru/public/676924/

Тестировалась в версии "Зарплата и управление персоналом, редакция 3.1 (3.1.5.212)"

### Инструкция (также доступна во встроенной справке).

Информация об отпусках собирается из документов "Отпуск" и "ГрафикОтпусков". Приоритет у документа "Отпуск".

Настройки содержат список адресатов в формате "ФИО" - "email", тему письма, глубину проверки в днях и шаблон текста письма. Глубина проверки определяет, за сколько дней до наступления отпуска будет отправлено уведомление. Так, например, при начале отпуска 31 мая уведомления начнут приходить, начиная с 24 мая.

Пример содержания письма представлен ниже:

Рассылка оповещения о приближающихся отпусках по организации Ооо лютик.

Информируем вас, что через 7 дней или ранее в отпуск уходят следующие сотрудники:

- Иванов Андрей Семенович, Директор, подразделение Основное подразделение
       Период отпуска 15.06.2018 - 20.06.2018, всего дней 6.

- John Noble, Юрист, подразделение Основное подразделение
       Период отпуска 14.06.2018 - 06.07.2018, всего дней 23.

С уважением, отдел по работе с персоналом.

09.06.2018

### Шаблоны писем.  

На закладке "Шаблон письма" можно написать собственный текст. Текст для подстановки (параметр) заключается в квадратные скобки, без пробелов, например: [Сотрудник]

В шаблоне доступны следующие переменные:

[ГлубинаПроверки] - за сколько дней до начала отпуска придет уведомление.  
[Сотрудник] - сотрудник из документа отпуска  
[Организация] - организация из документа отпуска  
[Должность] - должность сотрудника из кадровых данных  
[ДатаНачалаОтпуска] - дата, начало отпуска  
[ДатаОкончанияОтпуска] - дата, конец отпуска  
[ВсегоДней] - число, количество дней отпуска  
[ТекущаяДата] - дата, для вывода в письме  
[СписокСотрудниковНачало] - служебное поле, означающее, что будет сформировано одно письмо для всех сотрудников из таблицы отпусков  
[СписокСотрудниковКонец] - служебное поле, фиксирующее конец шаблона для строки сотрудника.  

В именах параметров следует соблюдать регистр букв.

### Алгоритмы работы.  

Всего предусмотрено 2 алгоритма формирования писем:

1.Одно письмо всем получателям из списка на закладке "Настройки" + сами сотрудники. В теле письма будет сформирован список из сотрудников, уходящих в отпуск.

2.На каждого сотрудника из таблицы отпусков будет сформировано отдельное письмо.

Переключение между режимами осуществляется выбором нужного шаблона письма. В обработку добавлены 2 предопределенных шаблона, чтобы упростить эту задачу.
Если шаблон письма содержит параметры [СписокСотрудниковНачало] и [СписокСотрудниковКонец], то будет испоьзоваться первый вариант рассылки, иначе - второй.

END