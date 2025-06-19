import 'package:flutter/material.dart';
import 'que_model.dart';

class McqCard extends StatelessWidget {
  final Question question;
  final int? selectedIndex;
  final Function(int?) onOptionSelected;

  const McqCard({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.text, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            for (int i = 0; i < question.options.length; i++)
              RadioListTile(
                title: Text(question.options[i]),
                value: i,
                groupValue: selectedIndex,
                onChanged: onOptionSelected,
              ),
          ],
        ),
      ),
    );
  }
}
