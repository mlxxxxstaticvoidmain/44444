import 'dart:convert';

import '../../core/storage/preferences_service.dart';
import '../models/workout_entry.dart';

class WorkoutRepository {
  WorkoutRepository(this._preferences);

  final PreferencesService _preferences;

  List<WorkoutEntry> load() {
    final raw = _preferences.readRaw(PreferencesService.workoutKey);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(WorkoutEntry.fromJson)
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  Future<void> save(List<WorkoutEntry> entries) {
    final payload = jsonEncode(entries.map((entry) => entry.toJson()).toList());
    return _preferences.writeRaw(PreferencesService.workoutKey, payload);
  }

  Future<void> clear() {
    return _preferences.removeRaw(PreferencesService.workoutKey);
  }
}
