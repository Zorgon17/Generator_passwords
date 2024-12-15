import 'package:flutter/material.dart';

/// Немного расширил чекбокс для ООП, а то в остальные части кода я его добавить забыл))))

class CheckboxWithLabel extends StatelessWidget {
  final bool value; // Текущее состояние чекбокса
  final String label; // Текст рядом с чекбоксом
  final ValueChanged<bool?> onChanged; // Функция для изменения состояния

  const CheckboxWithLabel({
    Key? key,
    required this.value,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
