import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../password.dart';
import '../utils/check_box_with_label.dart';

///Экран описывающий работу добавления пароля в БД

class PasswordFormScreen extends StatefulWidget {
  @override
  _PasswordFormScreenState createState() => _PasswordFormScreenState();
}

class _PasswordFormScreenState extends State<PasswordFormScreen> {

  //ключ формы для валидации
  final _formKey = GlobalKey<FormState>();
  //контроллер для текстового поля, где пользователь вводит название пароля
  final TextEditingController _nameController = TextEditingController();
  //TODO: Заменить на функцию генерации пароля
  static String passwordValue = 'Сраный пароль';

  //переменные для флажков в фоме
  bool autoGenerate = true;
  bool numbersInPassword = false;
  bool lowerCaseWordsInPassword = false;
  bool upperCaseWordsInPassword = false;
  //исходная длинапароля
  int passwordLength = 8;
  //экземпляр базы данных Hive, сс которой мы будем взаимодействовать
  Box<Password> passwordBox = Hive.box<Password>('passwords');

  //Метод dispose используется для освобождения ресурсов, выделенных для контроллера текстового поля.
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  //TODO:Доделать когда сделаешь генерацию пароля
  void addPassword() {
    if (_formKey.currentState!.validate()) {
      final password = Password(
        name: _nameController.text,
        size: passwordLength,
        value: passwordValue,
      );
      passwordBox.add(password);
      Navigator.pop(context); // Закрыть экран после добавления пароля
    }
  }

  ///Тут описан UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить Пароль')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Верхняя часть с текстовым полем и флажком автогенерации
              Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Название пароля',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста укажите название пароля';
                      }
                      return null;
                    },
                  ),
                  CheckboxWithLabel(
                    value: autoGenerate,
                    label: 'Автогенерация',
                    onChanged: (value) {
                      setState(() {
                        autoGenerate = value!;
                      });
                    },
                  ),
                ],
              ),

              // Поле пароля TODO: Если что-то небудет работать, то вот поле вывода пароля
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.black87, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        passwordValue,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Дополнительные настройки, если автогенерация выключена
              if (!autoGenerate)
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Длина пароля: $passwordLength'),
                        Expanded(
                          child: Slider(
                            value: passwordLength.toDouble(),
                            min: 8,
                            max: 14,
                            divisions: 6,
                            onChanged: (value) {
                              setState(() {
                                passwordLength = value.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CheckboxWithLabel(
                      value: numbersInPassword,
                      label: 'Использовать цифры',
                      onChanged: (value) {
                        setState(() {
                          numbersInPassword = value!;
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      value: lowerCaseWordsInPassword,
                      label: 'Использовать строчные буквы',
                      onChanged: (value) {
                        setState(() {
                          lowerCaseWordsInPassword = value!;
                        });
                      },
                    ),
                    CheckboxWithLabel(
                      value: upperCaseWordsInPassword,
                      label: 'Использовать заглавные буквы',
                      onChanged: (value) {
                        setState(() {
                          upperCaseWordsInPassword = value!;
                        });
                      },
                    ),
                  ],
                ),

              // Кнопка добавления пароля
              ElevatedButton(
                onPressed: addPassword,
                child: const Text('Добавить пароль'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50), // Кнопка на всю ширину
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
