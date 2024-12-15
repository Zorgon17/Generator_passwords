import 'package:flutter/material.dart';
import 'package:flutter_application_1/password.dart';
import 'package:flutter_application_1/screens/PasswordListScreen.dart';
import 'package:hive_flutter/hive_flutter.dart';

/*
async — это модификатор, который добавляется к функции, чтобы указать,
что она выполняет асинхронные операции.

Функция, помеченная как async, всегда возвращает объект Future.
Это означает, что функция не будет блокировать поток выполнения.
Вместо этого она будет выполняться в фоновом режиме, и результат будет доступен позже.

await — это оператор, который используется внутри функции, помеченной как async.
Он заставляет выполнение кода ждать завершения асинхронной операции перед тем,
как продолжить выполнение следующих строк кода.
 */

///Точка входа в программу.
///Это первая функция, которая вызывается при запуске приложения.
void main() async {
  //Гарантируем, что все объекты необходимые для работы программы проинициализированны, это важно например при работе с БД
  WidgetsFlutterBinding.ensureInitialized();
  // Настраивает Hive для работы с платформой Flutter, что позволяет ему использовать файловую систему приложения для хранения данных.
  await Hive.initFlutter();
  //Регистрируем адаптер (необходим для сериализации и десереаллизации)
  Hive.registerAdapter(PasswordAdapter());
  //Открываем БД
  await Hive.openBox<Password>('passwords');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //я так понял используется для идентефикации виджета
  MyApp({Key? key}) : super(key: key);

  final String title = 'Генератор паролей';
/*
Метод build возвращает дерево виджетов, которое отображает пользовательский интерфейс приложения.
Он принимает BuildContext, который предоставляет информацию о местоположении этого виджета в дереве виджетов.
 */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      //Домашний экран(Первый который показывается при запуске приложения)
      home: PasswordListScreen(),
    );
  }
}
