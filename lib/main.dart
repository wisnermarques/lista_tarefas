import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lista_tarefas/pages/todo_list_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inicializa a databaseFactory para plataformas desktop
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(),
    );
  }
}
