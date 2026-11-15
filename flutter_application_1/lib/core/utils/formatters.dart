String pluralize(
  int count,
  String one,
  String few,
  String many,
) {
  final mod10 = count % 10;
  final mod100 = count % 100;

  if (mod10 == 1 && mod100 != 11) {
    return one;
  }
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) {
    return few;
  }
  return many;
}

String exercisesCount(int count) =>
    '$count ${pluralize(count, 'упражнение', 'упражнения', 'упражнений')}';

String capitalize(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1);
}
