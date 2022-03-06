import 'package:flutter/material.dart';
import 'package:gtd_app/done_settings.dart';
import 'package:gtd_app/settings.dart';
import 'package:gtd_app/task_list.dart';
import 'package:gtd_domain/gtd_domain.dart';

void main() {
  // Caragar datos chorras en repo
  if (kDebug == true) {
    TaskRepository.shared.addTestData(amount: 10);
  }

  // Arranca la UI
  runApp(GTDApp());
}

class GTDApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      home: TaskListPage(),
    );
  }
}
