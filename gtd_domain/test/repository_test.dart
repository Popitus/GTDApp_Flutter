import 'dart:math';

import 'package:gtd_domain/src/task_repository.dart';
import 'package:gtd_domain/src/task.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  late Task sampleTask;
  late Task sampleTask2;
  late TaskRepository repo;

  // Se llama antes de todo test
  setUp(() {
    repo = TaskRepository.shared;
    sampleTask = Task.toDo(description: 'Darle una ducha al crio');
    sampleTask2 = Task.done(description: 'Crear paquete de dart');
  });

  // Se llama después de todo test
  tearDown(() {
    // Tenmos que vacíar el repo
    repo.reset();
  });

  group('Creation & Accessors', () {
    test('Empty repo', () {
      expect(TaskRepository.shared, isNotNull);
      expect(TaskRepository.shared.length, 0);
    });
  });

  group('Mutators', () {
    test('Add: adds to the beginning of the repo', () {
      repo.add(sampleTask);
      expect(repo.length, 1);
      expect(repo[0], sampleTask);
    });

    test('Insert: adds at the corresponding index', () {
      expect(() => repo.insert(10, sampleTask2), throwsRangeError);
      expect(() => repo.insert(0, sampleTask2), returnsNormally);

      final newTask = Task.done(description: 'prueba de inserción');
      repo.insert(1, newTask);

      expect(repo[1], newTask);
    });

    test('Remove: removes object if present', () {
      final hanzo =
          Task.toDo(description: 'Comprarle una espada a hatori hanzo');
      final int oldSize = repo.length;
      repo.add(hanzo);
      expect(repo.length, oldSize + 1);
      repo.remove(hanzo);
      expect(repo.length, oldSize);
    });

    test('RemoveAt: removes from the corresponding index', () {
      expect(() => repo.removeAt(42), throwsRangeError);

      repo.add(sampleTask2);
      repo.removeAt(0);
      expect(repo.length, 0);
    });

    test('Move: moves elements between valid indexs', () {
      repo.add(sampleTask);
      repo.add(sampleTask2);

      // mover de un sitio al mismo, no latera
      repo.move(0, 0);
      expect(repo.length, 2);
      expect(repo[0], sampleTask2);
      expect(repo[1], sampleTask);

      // Mover con rangos inexistentes, da erro de rango
      expect(() => repo.move(42, -1), throwsRangeError);

      // mover entre rangos normales funciona
      repo.move(0, 1);
      expect(repo.length, 2);
      expect(repo[1], sampleTask2);
    });
  });
}
