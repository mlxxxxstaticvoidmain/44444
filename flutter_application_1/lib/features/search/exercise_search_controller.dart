import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/network/api_exception.dart';
import '../../core/utils/debouncer.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/exercise.dart';
import '../../data/models/exercise_query.dart';
import '../../data/repositories/exercise_repository.dart';

class ExerciseSearchController extends ChangeNotifier {
  ExerciseSearchController(this._repository);

  final ExerciseRepository _repository;
  final Debouncer _debouncer = Debouncer(
    const Duration(milliseconds: 420),
  );

  String _name = '';
  String? _muscle;
  String? _type;
  String? _difficulty;

  List<Exercise> _results = const [];
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _errorMessage;
  int? _errorStatus;
  int _requestTicket = 0;

  String get name => _name;
  String? get muscle => _muscle;
  String? get type => _type;
  String? get difficulty => _difficulty;

  List<Exercise> get results => _results;
  bool get isLoading => _isLoading;
  bool get hasLoaded => _hasLoaded;
  String? get errorMessage => _errorMessage;
  int? get errorStatus => _errorStatus;

  ExerciseQuery get query => ExerciseQuery(
        name: _name,
        muscle: _muscle,
        type: _type,
        difficulty: _difficulty,
      );

  int get activeFilters => query.activeFilters;

  bool get hasResults => _results.isNotEmpty;

  String get summary {
    if (!_hasLoaded) return 'Загрузка базы упражнений';
    if (_errorMessage != null) return 'Результаты запроса';
    if (_isLoading) return 'Обновляем результаты';
    return exercisesCount(_results.length);
  }

  Future<void> load() => _search();

  Future<void> refresh() => _search();

  void updateName(String value) {
    if (value == _name) return;
    _name = value;
    _debouncer.run(() => _search());
  }

  void submitName(String value) {
    _name = value;
    _debouncer.cancel();
    _search();
  }

  void selectMuscle(String? value) {
    if (value == _muscle) return;
    _muscle = value;
    _search();
  }

  void selectType(String? value) {
    if (value == _type) return;
    _type = value;
    _search();
  }

  void selectDifficulty(String? value) {
    if (value == _difficulty) return;
    _difficulty = value;
    _search();
  }

  void reset() {
    _debouncer.cancel();
    _name = '';
    _muscle = null;
    _type = null;
    _difficulty = null;
    _search();
  }

  Future<void> _search() async {
    final ticket = ++_requestTicket;
    _isLoading = true;
    _errorMessage = null;
    _errorStatus = null;
    notifyListeners();

    try {
      final items = await _repository.search(query);
      if (ticket != _requestTicket) return;
      _results = items;
      _hasLoaded = true;
    } on ApiException catch (error) {
      if (ticket != _requestTicket) return;
      _results = const [];
      _hasLoaded = true;
      _errorMessage = error.message;
      _errorStatus = error.statusCode;
    } catch (_) {
      if (ticket != _requestTicket) return;
      _results = const [];
      _hasLoaded = true;
      _errorMessage = 'Неизвестная ошибка. Попробуйте ещё раз.';
      _errorStatus = null;
    } finally {
      if (ticket == _requestTicket) {
        _isLoading = false;
        _hasLoaded = true;
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
