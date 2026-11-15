import 'exercise.dart';

class WorkoutEntry {
  const WorkoutEntry({required this.exercise, this.isDone = false});

  final Exercise exercise;
  final bool isDone;

  WorkoutEntry copyWith({bool? isDone}) {
    return WorkoutEntry(exercise: exercise, isDone: isDone ?? this.isDone);
  }

  Map<String, dynamic> toJson() => {
        'exercise': exercise.toJson(),
        'done': isDone,
      };

  factory WorkoutEntry.fromJson(Map<String, dynamic> json) {
    final rawExercise = json['exercise'];
    return WorkoutEntry(
      exercise: Exercise.fromJson(
        rawExercise is Map<String, dynamic> ? rawExercise : const {},
      ),
      isDone: json['done'] == true,
    );
  }
}
