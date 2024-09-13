import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_tarefas/models/tarefa.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem(
      {super.key,
      required this.tarefa,
      required Null Function(Tarefa tarefaRemovida) onDismissed});

  final Tarefa tarefa;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[200],
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd/MM/yyyy - HH:mm').format(tarefa.dateTime),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
          Text(
            tarefa.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
