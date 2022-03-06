import 'package:gtd_domain/gtd_domain.dart';
import 'package:updatable/updatable.dart';

class ImmutableTask {
  late String _description;

  // Accessors
  String get description => _description;
  set description(String newValue) {
    if (newValue != _description) {
      _description = newValue;
    }
  }

  // Constructors
  ImmutableTask({required String description}) : _description = description;

  // Overrides

  @override
  String toString() {
    return '<$runtimeType: $description>';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return other is ImmutableTask && _description == other.description;
    }
  }

  @override
  int get hashCode => description.hashCode;
}

enum TaskState { toDo, doing, done }

class Task extends ImmutableTask with Updatable {
  late TaskState _state;

  TaskState get state => _state;
  set state(TaskState newValue) {
    if (newValue != _state) {
      changeState(() {
        _state = newValue;
      });
    }
  }

  // Constructor "designado"
  Task({required String description, required TaskState state})
      : _state = state,
        super(description: description);

  // Constructores con nombre
  Task.toDo({required String description})
      : _state = TaskState.toDo,
        super(description: description);

  Task.done({required String description})
      : _state = TaskState.done,
        super(description: description);

  // Overrides
  @override
  String toString() {
    return '<$runtimeType: $state $description>';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return other is Task &&
          state == other.state &&
          description == other.description;
    }
  }

  @override
  int get hashCode => Object.hashAll([description, state]);
}
