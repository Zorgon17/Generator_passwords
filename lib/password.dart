import 'package:hive/hive.dart';

part 'password.g.dart';

///Здесь описана сущность пароля (поля в БД)
@HiveType(typeId: 1)
class Password extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int size;

  @HiveField(2)
  String value;

  Password({
    required this.name,
    required this.size,
    required this.value
  });
}