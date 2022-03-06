import 'package:gtd_domain/src/task.dart';
import 'package:test/test.dart';

void main() {
  group('Task', () {
    test('Creation', () {
      expect(ImmutableTask(description: 'test'), isNotNull);
      expect(Task(description: 'Compilar', state: TaskState.toDo), isNotNull);
    });
  });

  group('Equality', () {
    test('Identical objects are equal', () {
      final compra = ImmutableTask(description: 'comprar leche');
      expect(compra, compra);
    });

    test('Equivalent objects must be equal', () {
      expect(ImmutableTask(description: 'description'),
          ImmutableTask(description: 'description'));
    });

    test('Non-equivalent objects are not equal', () {
      expect(
          Task.toDo(description: "learn dart") !=
              Task.done(description: "learn dart"),
          isTrue);
    });
  });
}
