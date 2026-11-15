class ExerciseQuery {
  const ExerciseQuery({
    this.name = '',
    this.muscle,
    this.type,
    this.difficulty,
  });

  final String name;
  final String? muscle;
  final String? type;
  final String? difficulty;

  bool get isEmpty =>
      name.trim().length < 2 &&
      muscle == null &&
      type == null &&
      difficulty == null;

  int get activeFilters {
    var count = 0;
    if (name.trim().length >= 2) count++;
    if (muscle != null) count++;
    if (type != null) count++;
    if (difficulty != null) count++;
    return count;
  }

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};
    final trimmedName = name.trim();

    if (trimmedName.length >= 2) params['name'] = trimmedName;
    if (muscle != null) params['muscle'] = muscle;
    if (type != null) params['type'] = type;
    if (difficulty != null) params['difficulty'] = difficulty;

    return params;
  }

  ExerciseQuery copyWith({
    String? name,
    String? muscle,
    String? type,
    String? difficulty,
    bool clearMuscle = false,
    bool clearType = false,
    bool clearDifficulty = false,
  }) {
    return ExerciseQuery(
      name: name ?? this.name,
      muscle: clearMuscle ? null : (muscle ?? this.muscle),
      type: clearType ? null : (type ?? this.type),
      difficulty: clearDifficulty ? null : (difficulty ?? this.difficulty),
    );
  }
}
