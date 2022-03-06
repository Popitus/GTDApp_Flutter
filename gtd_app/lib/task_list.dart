import 'package:flutter/material.dart';
import 'package:gtd_app/done_settings.dart';
import 'package:gtd_app/settings.dart';
import 'package:gtd_app/task_widget.dart';
import 'package:gtd_domain/gtd_domain.dart';
import 'package:mow/mow.dart';
import 'package:gtd_app/drawer.dart';

class TaskListModel extends ModelPair<TaskRepository, DoneSettings> {
  TaskListModel(TaskRepository repo, DoneSettings settings)
      : super(repo, settings);
}

class TaskListPage extends MOWWidget<TaskListModel> {
  TaskListPage()
      : super(model: TaskListModel(TaskRepository.shared, DoneSettings.shared));

  @override
  MOWState<TaskListModel, TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends MOWState<TaskListModel, TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: GTDDrawer(),
        floatingActionButton:
            FloatingActionButton(onPressed: _newTask, child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text(kAppName),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return TaskWidget(TaskRepository.shared[index]);
          },
          itemCount: TaskRepository.shared.length,
        ));
  }

  void _newTask() {
    TaskRepository.shared.add(Task.toDo(description: 'New Task'));
  }
}
