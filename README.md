Чтение/запись параметров для скриптов OneScript
==
 
Обсудить [![Join the chat at https://gitter.im/EvilBeaver/oscript-library](https://badges.gitter.im/EvilBeaver/oscript-library.svg)](https://gitter.im/EvilBeaver/oscript-library?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Описание 
===

Библиотека проекта `oscript.io` для автоматизации использования различных настроек для командных приложений/скриптов OneScript.

Возможности:

+ чтение настроек из произвольных json-файлов
  + из явно заданных файлов
  + из файлов с именем по умолчанию
+ чтение настроек из иерархических json-файлов
+ чтение настроек из "вложенных" json-файлов, которые связаны ссылками
+ чтение настроек из переменных среды
+ чтение настроек из командной строки, в т.ч. с передачей нескольких файлов в одном параметре
+ одновременное использование вышеуказанных возможностей согласно приоритетам

Установка
===

используйте пакетный менеджер `opm` из стандартной поставки дистрибутива `oscript.io`

```cmd
opm install params
```

После чего доступно использование модулей и классов библиотеки через `#Использовать params` в коде скриптов.

Использование
===

### 1. Вызов из командной строки

Примеры вызова:
```cmd
my-app command --settings my-settings.json --options 2
```
или
```cmd
my-app command --settings server.json;"storage.json"
```
или
```cmd
my-app command --spec-settings-key server.json;"storage.json"
```
или при использовании файла по умолчанию params.json (или другого, установленного в коде продукта)
```cmd
my-app command --options 1
```

### 2. Форматы json-файлов настроек

+ Иерархический файл настройки

```json
{
    "default": {
        "--ibconnection": "/F./build/ib",
        "--db-user": "Администратор",
        "--db-pwd": "",
        "--ordinaryapp": "0"
    },

    "vanessa": {
        "--vanessasettings": "./tools/VBParams.json",
        "--workspace": ".",
        "--pathvanessa": "./tools/vanessa-behavior/vanessa-behavior.epf",
        "--additional": "/DisplayAllFunctions /L ru"
    }
}
```
Параметры команды (`vanessa`) имеют более высокий приоритет, чем настройки ключа `default`

В ключе `default` удобно указывать параметры, которые являются общими для нескольких команд.

  - Другой вариант, без явного ключа `default`
```json
{
    "--ibconnection": "/F./build/ib",

    "vanessa": {
        "--vanessasettings": "./tools/VBParams.json",
    }
}
```

+ Плоский файл настройки
```json
{
    "--ibconnection": "/F./build/ib",
    "--db-user": "Администратор",
    "--db-pwd": "",
    "--ordinaryapp": "0",

    "--vanessasettings": "./tools/VBParams.json",
    "--workspace": ".",
    "--pathvanessa": "./tools/vanessa-behavior/vanessa-behavior.epf",
    "--additional": "/DisplayAllFunctions /L ru"
}
```

+ Возможно чтение вложенных файлов (по ссылке)

  + Если в файле параметров указать имя параметра, которое начинается с `ReadFile`, 
  + а в значении путь к файлу (в том числе относительно текущего файла),
    + то будут прочитан так же и указанный файл.
  + возможно любая вложенность

```json
{
    "ReadFile": "main.json",
    "ReadFile.server1c": "c:\tools\settings\server1c.json",
    "ReadFile.storage": "./storage.json"
}
```

+ Возможно русские имена параметров
+ Возможно использование чисел и булевых параметров
```json
{
    "таймаут": 10,
    "ИспользоватьТаймаут": true,
    "ИспользоватьТиповуюВыгрузку": false
}
```

+ Возможно использование подстановок значений

При разработке очень желательно указывать один параметр всего единожды, в одном месте файла/файлов.

+ Например, когда изменится версия платформы 1С на сервере - нужно изменить только один параметр, а не множество файлов.

```json
{
    "v8version": "8.3.10.2299",
    "bin": "c:/program Files (x86)/1cv8/%v8version%/bin/1cv8.exe"
}
```

+ Возможно использование обычных комментариев 1С

```json
{
    // простой комментарий
    "таймаут": 10 // комментарий-продолжение строки
}
```

### 3. Переопределение параметров

В случае необходимости переопределения параметров запуска используется схема приоритетов.

Приоритет в порядке возрастания (от минимального до максимального приоритета)
+ `params.json` (в корне проекта)
  + явно заданный json-файл по умолчанию, явно указаннный припрограммной установке
+ `--settings ../env.json` (указание файла настроек вручную)
  + или другой ключ командной строки, явно указаннный при программной установке
+ `явно_заданный_префикс_*` (из переменных окружения)
  + по умолчанию префикс `ONESCRIPT_APP_`
+ ключи командной строки

Описание:
+ На первоначальном этапе читаются настройки из файла настроек, указанного в ключе команды ```--settings tools/vrunner.json```
+ Потом, если настройка есть в переменной окружения, тогда берем из еe.
+ Если же настройка есть, как в файле json, так и в переменной окружения и непосредственно в командной строке, то берем настройку из командной строки.

Например:

>  + **Переопределение переменной окружения:**

  1. Допустим, в файле vrunner.json указана настройка
        ```json
        "--db-user":"Администратор"
        ```
        а нам для определенного случая надо переопределить имя пользователя, 
        тогда можно установить переменную: ```set RUNNER_DBUSER=Иванов``` и в данный параметр будет передано значение `Иванов`

  2. Очистка значения после установки 
        ```cmd
        set RUNNER_DBUSER=Иванов
        set RUNNER_DBUSER=
        ```
        в данном случаи установлено полностью пустое значение и имя пользователя будет взято из tools/vrunner.json, если оно там есть. 

  3. Установка пустого значения:
        ```cmd
        set RUNNER_DBUSER=""
        set RUNNER_DBUSER=''
        ```

        Если необходимо установить в поле пустое значение, тогда указываем кавычки и в параметр `--db-user` будет установлена пустая строка. 
        
  4. Переопределение через параметры командной строки. 
    
        Любое указание параметра в командной строке имеет наивысший приоритет.

Программный интерфейс
===

Вся библиотека работает по принципам защитного программирования, в т.ч. активно используются утверждения.

В случае возникновения ошибочных ситуаций немедленно выбрасываются исключения.

### 1. Модуль ЧтениеПараметров

Используется для обычного/простого использования библиотеки в своем приложении.

#### Прочитать

```bsl
// Выполнить основной анализ и получить финальные параметры с учетом командной строки, переменных среды, файлов настроек
//
// Параметры:
//   Парсер - <ПарсерАргументовКоманднойСтроки> - ранее инициализированный парсер со всеми настройками командной строки (из пакета cmdline)
//   Аргументы - <Массив>, необязательный - набор аргументов командной строки, 
//		Если не указан, используется штатная коллекция АргументыКоманднойСтроки
//   КлючФайлаНастроек - <Строка>, необязательный - именованный параметр командной строки, 
//		который указывает на json-файл настройки 
//		Если не указан, используется ключ "--settings"
//   ПрефиксПеременныхСреды - <Строка>, необязательный - 
//		Если не указан, используется ключ "ONESCRIPT_APP_"
//
//  Возвращаемое значение:
//   <Соответствие> - итоговые параметры
//
Функция Прочитать(Парсер, Знач Аргументы = Неопределено, 
		Знач КлючФайлаНастроек = "", Знач ПрефиксПеременныхСреды = "") Экспорт
```

+ Пример использования в своем скрипте
```bsl
#Использовать params

Парсер = Новый ПарсерАргументовКоманднойСтроки();
Парсер.ДобавитьИменованныйПараметр("Параметр");

Параметры = ЧтениеПараметров.Прочитать(Парсер, АргументыКоманднойСтроки);

Если Параметры["Параметр"] = "Успешно" Тогда
	ЗавершитьРаботу(0);
Иначе
	ЗавершитьРаботу(1);
КонецЕсли;
```

#### Получить

```bsl
// Получает значение параметра по имени ключа
// Предварительно нужно прочитать параметры с помощью метода Прочитать
//
// Параметры:
//   КлючПараметра - <Строка> - произвольный ключ
//   ЗначениеПоУмолчанию - <Строка>, необязательный - значение по умолчанию, если значение не получено из настроек
//
//  Возвращаемое значение:
//   <Любой> - значение по ключу
//
```

+ Дополнительные параметры настроек библиотеки:

#### КлючКомандыВФайлеНастроекПоУмолчанию

```bsl
// Возвращает ключ по умолчанию в файле настройки для всех параметров, которые не заданы в настройке команды
//
//  Возвращаемое значение:
//   <Строка> "default"
```

#### КлючФайлаНастроек

```bsl
// Возвращает ключ командной строки для файла настроек
//
//  Возвращаемое значение:
//   <Строка> "--settings"
```

#### ПрефиксПеременныхОкружения

```bsl
// Возвращает префикс переменных окружения по умолчанию
//
//  Возвращаемое значение:
//   <Строка> "ONESCRIPT_APP_"
```

#### ИмяФайлаНастроекПоУмолчанию

```bsl
// Возвращает имя по умолчанию для файла с настройками
//
//  Возвращаемое значение:
//   <Строка> "params.json"
```

#### ПрефиксКлючаДляЧтенияВложенногоФайлаНастроек

```bsl
// Возвращает префикс ключа для чтения вложенного файла настроек
//
//  Возвращаемое значение:
//   <Строка> "ReadFile"
//
```

### 2. Класс ЧитательПараметров

#### Прочитать

```bsl
метод Функция Прочитать(Парсер, Знач Аргументы = Неопределено, 
		Знач КлючФайлаНастроек = "", Знач ПрефиксПеременныхСреды = "") Экспорт
```

+ описание аналогично `ЧтениеПараметров.Прочитать`

#### Получить

```bsl
Функция Получить(КлючПараметра, ЗначениеПоУмолчанию = Неопределено) Экспорт
```

+ описание аналогично `ЧтениеПараметров.Получить`

#### Дополнительные методы:

#### УстановитьТекущийКаталогПроекта

```bsl
// Установить текущий каталог проекта-клиента
//
// Параметры:
//   ПарамТекущийКаталогПроекта - <Строка> - путь каталога
```

#### ПолучитьТекущийКаталогПроекта

```bsl
// Получить текущий каталог проекта-клиента
//
//  Возвращаемое значение:
//   <Строка> - путь каталога
```

#### УстановитьФайлПоУмолчанию

```bsl
// Установить путь к файлу настроек по умолчанию
//
// Параметры:
//   НовыйПутьФайлаНастроек - <Строка> - путь файла
```

#### ЗагрузитьСоответствиеПеременныхОкруженияПараметрамКоманд

```bsl
// Загрузить соответствие переменных окружения параметрам команд
//
// Параметры:
//   Источник - <Соответствие или ФиксированноеСоответствие> - откуда загружаем
//		ключ - имя переменной окружения
//		значение - имя соответствующего ключа/параметра настройки
//
```

Вывод отладочной информации
===

Управление выводом логов выполняется с помощью типовой для oscript-library настройки логирования через пакет logos.

Основной лог проекта имеет название `oscript.lib.params`.
