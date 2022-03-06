import 'package:flutter/material.dart';
import 'package:gtd_app/done_settings.dart';
import 'package:gtd_domain/gtd_domain.dart';
import 'package:mow/mow.dart';
import 'package:gtd_app/detail_task.dart';

class TaskWidget extends MOWWidget<Task> {
  TaskWidget(Task task) : super(model: task);

  @override
  MOWState<Task, TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends MOWState<Task, TaskWidget> {
  late BuildContext? _ctxt;

  @override
  Widget build(BuildContext context) {
    _ctxt = context;
    return Dismissible(
      background: DismissibleBackground(),
      secondaryBackground: DismissibleBackground(align: MainAxisAlignment.end),
      onDismissed: (direction) {
        TaskRepository.shared.remove(model);
      },
      key: UniqueKey(),
      child: ListTile(
        onTap: () async {
          final task = await Navigator.of(context).push<Task>(MaterialPageRoute(
              builder: (context) => DetailTask(model: model)));
          // Hay que obligar a que se repinte la lista
          setState(() {});
        },
        leading: Checkbox(
          onChanged: (bool? newValue) {
            if (newValue != null) {
              if (newValue == true) {
                model.state = TaskState.done;
                // Comprobar que está en delete, para mandar alert
                _danger();
              } else {
                model.state = TaskState.toDo;
              }
            }
          },
          value: model.state == TaskState.done,
        ),
        title: _descriptionWidget(model.description),
      ),
    );
  }

  Widget _descriptionWidget(String text) {
    TextStyle? style;

    if (DoneSettings.shared[DoneOptions.greyOut] &&
        model.state == TaskState.done) {
      // le metemos un estilo gris
      style = TextStyle(fontStyle: FontStyle.italic, color: Colors.grey);
    }

    return Text(
      text,
      style: style,
    );
  }

  void _danger() {
    if (DoneSettings.shared[DoneOptions.greyOut] &&
        model.state == TaskState.done) {
      _dangerMessage();
    }
  }

  void _dangerMessage() async {
    final shouldDelete = await showDialog<bool>(
      barrierDismissible: false,
      context: _ctxt!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vas a borrar la tarea seleccionada!"),
          content: SingleChildScrollView(
            child: Text('De verdad quieres borrarla?'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'))
          ],
        );
      },
    );
    if (shouldDelete == true) {
      TaskRepository.shared.remove(model);
      // LLamar a un método del Repo que borra todas las tareas marcadas como done
      // mandando una sola notificacion.
      // => crea un método removeDone en el repo.
    }
  }
}

// Background
class DismissibleBackground extends StatelessWidget {
  late final String _text;
  late final Color _color;
  late final MainAxisAlignment _alignment;

  DismissibleBackground(
      {Key? key,
      String text = 'Delete',
      Color color = Colors.red,
      MainAxisAlignment align = MainAxisAlignment.start})
      : _color = color,
        _text = text,
        _alignment = align,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.delete,
              color: Colors.white70,
            ),
            Text(
              _text,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
            ),
            SizedBox(
              width: 5.0,
              height: 5.0,
            )
          ],
          mainAxisAlignment: _alignment,
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
    );
  }
}
