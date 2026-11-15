import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/exercise.dart';
import '../../data/repositories/favorites_repository.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._repository)
      : _items = List<Exercise>.from(_repository.load());

  final FavoritesRepository _repository;
  List<Exercise> _items;

  List<Exercise> get items => List.unmodifiable(_items);
  int get count => _items.length;

  bool isFavorite(String id) => _items.any((item) => item.id == id);

  bool toggle(Exercise exercise) {
    final wasFavorite = isFavorite(exercise.id);
    if (wasFavorite) {
      _items = _items.where((item) => item.id != exercise.id).toList();
    } else {
      _items = [exercise, ..._items];
    }
    _persist();
    notifyListeners();
    return !wasFavorite;
  }

  void remove(String id) {
    final next = _items.where((item) => item.id != id).toList();
    if (next.length == _items.length) return;
    _items = next;
    _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _items = [];
    notifyListeners();
    await _repository.clear();
  }

  void _persist() {
    unawaited(_repository.save(_items));
  }
}
