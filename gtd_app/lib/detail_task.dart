import 'package:flutter/material.dart';
import 'package:gtd_app/done_settings.dart';
import 'package:gtd_domain/gtd_domain.dart';
import 'package:mow/mow.dart';

class DetailTask extends MOWWidget<Task> {
  DetailTask({required Task model, Key? key}) : super(model: model, key: key);

  @override
  MOWState<Task, DetailTask> createState() => _DetailTaskState();
}

class _DetailTaskState extends MOWState<Task, DetailTask> {
  final _controller = TextEditingController();
  late BuildContext? _ctxt;

  // Dos opciones para los dos botones
  List<bool> isSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    // Comprobar estado inicial del estado del boton
    if (model.state == TaskState.toDo) {
      isSelected[0] = true;
      isSelected[1] = false;
      isSelected[2] = false;
    } else {
      isSelected[0] = false;
      isSelected[1] = true;
      isSelected[2] = false;
    }

    // Contexto
    _ctxt = context;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle de la Tarea'),
        leading: BackButton(onPressed: () => returnToCaller(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                setState(() {});
              },
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Escribir Tarea',
                labelText: 'Tarea:',
                border: OutlineInputBorder(),
                icon: Icon(Icons.task),
                suffixIcon: _iconButton(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            ToggleButtons(
              children: <Widget>[
                Icon(Icons.block),
                Icon(Icons.check_circle_outline),
                Icon(Icons.delete),
              ],
              isSelected: isSelected,
              onPressed: _onTapHandler,
            )
          ],
        ),
      ),
    );
  }

  IconButton? _iconButton() {
    IconButton? ic;

    if (_controller.text.isEmpty) {
      ic = null;
    } else {
      ic = IconButton(
          onPressed: () {
            setState(() {
              _controller.clear();
            });
          },
          icon: Icon(Icons.clear));
    }

    return ic;
  }

  void _onTapHandler(int index) {
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      if (buttonIndex == index) {
        isSelected[buttonIndex] = true;
        if (isSelected[2] == true && (DoneSettings.shared[DoneOptions.delete] || DoneSettings.shared[DoneOptions.greyOut])) {
          _alertMessage(index);
        } else {
        if (model.state == TaskState.toDo) {
          model.state = TaskState.done;
          if (DoneSettings.shared[DoneOptions.delete]) {
            _alertMessage(index);
          }
        } else {
          model.state = TaskState.toDo;
        }
      }
      } else {
        isSelected[buttonIndex] = false;
      }
    }
  }

  // Funcion de llamar a la alerta de mensaje
  void _alertMessage(int index) async {
    final shouldDelete = await showDialog<bool>(
      barrierDismissible: false,
      context: _ctxt!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Vas a borrar la tarea?"),
          content: SingleChildScrollView(
            child: Text('De verdad que quieres borrarla?'),
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
      Navigator.pop(context);
      TaskRepository.shared.remove(model);
      //TaskRepository.shared.removeWhere(filter:;
    }
  }



  // Ciclo de vida
  @override
  void initState() {
    super.initState();

    // le meto en el controlador el valor inicial
    _controller.text = model.description;
    // Empezamos a observar el controlador para ir guardando cambios en la task

    _controller.addListener(_updateModel);
  }

  void _updateModel() {
    model.description = _controller.text;
    print(model);
  }

  @override
  void dispose() {
    // Nos damos de baja de las observaciones del controlador y lo destruimos
    _controller.removeListener(_updateModel);
    _controller.dispose();
    super.dispose();
  }

  void returnToCaller(BuildContext context) {
    Navigator.of(context).pop<Task?>(model);
  }
}
