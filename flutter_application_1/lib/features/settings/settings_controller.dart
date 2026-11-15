import 'package:flutter/foundation.dart';

import '../../core/network/api_exception.dart';
import '../../core/storage/preferences_service.dart';
import '../../data/repositories/exercise_repository.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._preferences, this._repository);

  final PreferencesService _preferences;
  final ExerciseRepository _repository;

  bool _isBusy = false;
  String? _message;
  bool _messageIsError = false;

  String? get apiKey => _preferences.apiKey;
  bool get hasApiKey => apiKey != null;
  bool get isBusy => _isBusy;
  String? get message => _message;
  bool get messageIsError => _messageIsError;

  bool get onboardingSeen => _preferences.onboardingSeen;

  String get maskedApiKey {
    final key = apiKey;
    if (key == null || key.isEmpty) return 'не задан';
    if (key.length <= 4) return '••••';
    return '••••${key.substring(key.length - 4)}';
  }

  Future<void> markOnboardingSeen() => _preferences.markOnboardingSeen();

  Future<bool> saveAndCheck(String rawKey) async {
    final key = rawKey.trim();
    if (key.isEmpty) {
      _setMessage('Введите ключ API Ninjas.', isError: true);
      return false;
    }
    if (key.length < 10) {
      _setMessage(
        'Ключ выглядит слишком коротким. Скопируйте его целиком из личного кабинета API Ninjas.',
        isError: true,
      );
      return false;
    }

    _isBusy = true;
    _message = null;
    notifyListeners();

    await _preferences.setApiKey(key);

    try {
      await _repository.checkApiKey();
      _message = 'Ключ сохранён. API Ninjas отвечает.';
      _messageIsError = false;
      return true;
    } on ApiException catch (error) {
      _message = error.message;
      _messageIsError = true;
      return false;
    } catch (_) {
      _message = 'Не удалось проверить ключ. Попробуйте ещё раз.';
      _messageIsError = true;
      return false;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> checkConnection() async {
    if (!hasApiKey) {
      _setMessage('Сначала сохраните ключ API Ninjas.', isError: true);
      return false;
    }

    _isBusy = true;
    _message = null;
    notifyListeners();

    try {
      await _repository.checkApiKey();
      _setMessage('API Ninjas отвечает, ключ действует.', isError: false);
      return true;
    } on ApiException catch (error) {
      _setMessage(error.message, isError: true);
      return false;
    } catch (_) {
      _setMessage('Не удалось проверить ключ. Попробуйте ещё раз.', isError: true);
      return false;
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  Future<void> removeKey() async {
    await _preferences.setApiKey(null);
    _setMessage('Ключ удалён с этого устройства.', isError: false);
  }

  void _setMessage(String value, {required bool isError}) {
    _message = value;
    _messageIsError = isError;
    notifyListeners();
  }
}
