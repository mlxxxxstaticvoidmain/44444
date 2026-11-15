import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/exercise.dart';
import '../../data/models/workout_entry.dart';
import '../../data/repositories/workout_repository.dart';

class WorkoutController extends ChangeNotifier {
  WorkoutController(this._repository)
      : _entries = List<WorkoutEntry>.from(_repository.load());

  final WorkoutRepository _repository;
  List<WorkoutEntry> _entries;

  List<WorkoutEntry> get entries => List.unmodifiable(_entries);
  int get count => _entries.length;
  bool get isEmpty => _entries.isEmpty;

  int get doneCount =>
      _entries.where((entry) => entry.isDone).length;

  double get progress =>
      _entries.isEmpty ? 0 : doneCount / _entries.length;

  bool contains(String id) =>
      _entries.any((entry) => entry.exercise.id == id);

  bool toggle(Exercise exercise) {
    final exists = contains(exercise.id);
    if (exists) {
      _entries =
          _entries.where((entry) => entry.exercise.id != exercise.id).toList();
    } else {
      _entries = [..._entries, WorkoutEntry(exercise: exercise)];
    }
    _persist();
    notifyListeners();
    return !exists;
  }

  void toggleDone(String id) {
    _entries = _entries
        .map(
          (entry) => entry.exercise.id == id
              ? entry.copyWith(isDone: !entry.isDone)
              : entry,
        )
        .toList();
    _persist();
    notifyListeners();
  }

  void remove(String id) {
    final next =
        _entries.where((entry) => entry.exercise.id != id).toList();
    if (next.length == _entries.length) return;
    _entries = next;
    _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _entries = [];
    notifyListeners();
    await _repository.clear();
  }

  void _persist() {
    unawaited(_repository.save(_entries));
  }
}
