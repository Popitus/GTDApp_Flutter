import 'package:flutter/material.dart';
import 'package:gtd_app/done_settings.dart';
import 'package:gtd_domain/gtd_domain.dart';
import 'package:mow/mow.dart';

class DoneOptionsWidget extends MOWWidget<DoneSettings> {
  DoneOptionsWidget({required DoneSettings model}) : super(model: model);
  @override
  MOWState<DoneSettings, DoneOptionsWidget> createState() =>
      _DoneOptionsState();
}

class _DoneOptionsState extends MOWState<DoneSettings, DoneOptionsWidget> {
  late BuildContext? _ctxt;

  @override
  Widget build(BuildContext context) {
    _ctxt = context;

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ToggleButtons(
        children: [
          _button('Nada'),
          _button('Borrado Selectivo'),
          _button('Borrado Total', destructive: true)
        ],
        isSelected: model.toList(),
        direction: Axis.vertical,
        onPressed: _tapHandler,
      ),
    );
  }

  void _tapHandler(int index) async {
    // cuala es la opción que quiero cambiar
    DoneOptions opt = DoneOptions.values[index];

    if (DoneSettings.shared[opt] == false) {
      DoneSettings.shared[opt] = true;
    } else {
      DoneSettings.shared[opt] = false;
    }

    if (opt == DoneOptions.delete) {
      final shouldDelete = await showDialog<bool>(
        barrierDismissible: false,
        context: _ctxt!,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Vas a borrar las tareas marcadas"),
            content: SingleChildScrollView(
              child: Text('De verdad de la buena quieres borrarlas?'),
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

      // Se contempla el futuro y sabemos la respuesta del usuario
      if (shouldDelete == true) {
        TaskRepository.shared.removeList();

      }
    }
  }

  Widget _button(String caption, {bool destructive = false}) {
    if (!destructive) {
      return Text(caption);
    } else {
      return Row(
        children: [
          Icon(
            Icons.dangerous,
            size: 14,
            color: Colors.deepOrange[900],
          ),
          Text(caption)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      );
    }
  }
}

bool _pruebaFunction(Task element) {
  return true;
}
