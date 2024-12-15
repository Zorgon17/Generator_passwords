import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import '../password.dart';
import 'PasswordFormScreen.dart';


/// Тут список из всех паролей, которые мы добавили в БД

class PasswordListScreen extends StatefulWidget {
  @override
  _PasswordListScreenState createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    //Создаемм экземпляр БД
    Box<Password> passwordBox = Hive.box<Password>('passwords');
    //Здесь описан UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список Паролей'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PasswordFormScreen()),
              );
            },
          ),
        ],
        bottom: PreferredSize( //позволяет добавлять виджеты в AppBar
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск по названиям',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),

      //отвечает за отображение паролей, он позволяет обновлять UI
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ValueListenableBuilder(
          valueListenable: passwordBox.listenable(),
          builder: (context, Box<Password> box, _) {
            //реализация фильтрации полейпо поисковвому запросу
            final passwords = box.values
                .where((password) => password.name.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            //Непосредственно UI для отображения
            return passwords.isEmpty
                ? const Center(child: Text('Список паролей пуст'))
                : ListView.builder(
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                final password = passwords[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Добавлен в избранное')),
                            );
                          },
                          icon: const Icon(Icons.favorite_border),
                        ),
                        Expanded(
                          child: Text(
                            'Пароль: ${password.name}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: password.value));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Пароль скопирован')),
                            );
                          },
                          icon: const Icon(Icons.copy),
                        ),
                        IconButton(
                          onPressed: () {
                            box.deleteAt(index);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Пароль удален')),
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}