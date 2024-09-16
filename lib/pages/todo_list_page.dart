import 'package:flutter/material.dart';
import 'package:lista_tarefas/models/tarefa.dart';
import 'package:lista_tarefas/widgets/todo_list_item.dart';
import 'package:lista_tarefas/helpers/database_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List<Tarefa> tarefas = [];
  final TextEditingController todoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTarefas();
  }

  Future<void> _loadTarefas() async {
    final tarefasFromDb = await _dbHelper.getTarefas();
    setState(() {
      tarefas = tarefasFromDb;
    });
  }

  Future<void> _addTarefa(String title) async {
    Tarefa novaTarefa = Tarefa(title: title, dateTime: DateTime.now());
    await _dbHelper.insertTarefa(novaTarefa);
    _loadTarefas();
  }

  Future<void> _removeTarefa(Tarefa tarefa) async {
    if (tarefa.id != null) {
      await _dbHelper.deleteTarefa(tarefa.id!);
      _loadTarefas();
    }
  }

  Future<void> _clearTarefas() async {
    await _dbHelper.clearTarefas();
    _loadTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Adicione uma tarefa',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        if (text.isNotEmpty) {
                          _addTarefa(text);
                          todoController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Tarefa tarefa in tarefas)
                        Dismissible(
                          key: Key(tarefa.title),
                          direction: DismissDirection.startToEnd,
                          onDismissed: (direction) {
                            Tarefa tarefaRemovida = tarefa;
                            int tarefaIndex = tarefas.indexOf(tarefa);

                            // Remove a tarefa da lista
                            setState(() {
                              tarefas.removeAt(tarefaIndex);
                            });

                            // Exibe o SnackBar com a opção de desfazer
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Tarefa "${tarefaRemovida.title}" removida'),
                                    action: SnackBarAction(
                                      label: 'Desfazer',
                                      onPressed: () {
                                        // Desfazer a remoção da tarefa
                                        setState(() {
                                          tarefas.insert(
                                              tarefaIndex, tarefaRemovida);
                                        });
                                      },
                                    ),
                                    duration: const Duration(seconds: 5),
                                  ),
                                )
                                .closed
                                .then((reason) {
                              // Se o usuário não clicou em "Desfazer", persiste a exclusão no banco de dados
                              if (reason != SnackBarClosedReason.action) {
                                // Chamar função para excluir a tarefa do banco de dados
                                _removeTarefa(tarefaRemovida);
                              }
                            });
                          },
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.only(left: 16),
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          child: TodoListItem(
                            tarefa: tarefa,
                            onDismissed: (Tarefa tarefaRemovida) {
                              setState(() {
                                tarefas.remove(tarefaRemovida);
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${tarefas.length} tarefas pendentes',
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: tarefas.isEmpty ? null : _clearTarefas,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00d7f3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'Limpar tudo',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
