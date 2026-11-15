import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';
import '../../../features/search/exercise_search_controller.dart';
import '../settings_controller.dart';
import 'external_link.dart';

class ApiKeyForm extends StatefulWidget {
  const ApiKeyForm({super.key, this.autofocus = false, this.onSaved});

  final bool autofocus;
  final ValueChanged<bool>? onSaved;

  @override
  State<ApiKeyForm> createState() => _ApiKeyFormState();
}

class _ApiKeyFormState extends State<ApiKeyForm> {
  final SettingsController _settings = getIt<SettingsController>();
  final TextEditingController _keyController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final isSaved = await _settings.saveAndCheck(_keyController.text);
    if (!mounted) return;

    if (isSaved) {
      _keyController.clear();
      setState(() {});
      getIt<ExerciseSearchController>().refresh();
    }
    widget.onSaved?.call(isSaved);
  }

  Future<void> _checkSavedKey() async {
    final isValid = await _settings.checkConnection();
    if (isValid) {
      getIt<ExerciseSearchController>().refresh();
    }
  }

  Future<void> _removeKey() async {
    await _settings.removeKey();
    if (!mounted) return;
    _keyController.clear();
    setState(() {});
    getIt<ExerciseSearchController>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        final hasKey = _settings.hasApiKey;
        final busy = _settings.isBusy;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.key_outlined,
                  size: 18,
                  color: scheme.secondary,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Сохранённый ключ',
                        style: TextStyle(
                          fontSize: 11,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _settings.maskedApiKey,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: hasKey
                              ? scheme.onSurface
                              : scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasKey)
                  IconButton(
                    onPressed: busy ? null : _removeKey,
                    tooltip: 'Удалить ключ',
                    icon: Icon(
                      Icons.delete_outline,
                      size: 19,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _keyController,
              autofocus: widget.autofocus,
              enabled: !busy,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.visiblePassword,
              onSubmitted: (_) {
                if (!busy) _save();
              },
              decoration: InputDecoration(
                hintText: hasKey
                    ? 'Вставьте новый ключ, чтобы заменить'
                    : 'Вставьте ключ из api-ninjas.com',
                prefixIcon: const Icon(Icons.password, size: 19),
                suffixIcon: IconButton(
                  tooltip: _obscure ? 'Показать ключ' : 'Скрыть ключ',
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: busy ? null : _save,
                child: busy
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary,
                        ),
                      )
                    : const Text('Сохранить и проверить'),
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () => openExternal(
                    context,
                    'https://api-ninjas.com/register',
                  ),
                  icon: const Icon(Icons.open_in_new, size: 15),
                  label: const Text('Получить ключ'),
                ),
                if (hasKey)
                  TextButton(
                    onPressed: busy ? null : _checkSavedKey,
                    child: const Text('Проверить сохранённый'),
                  ),
              ],
            ),
            if (_settings.message != null) ...[
              const SizedBox(height: 6),
              _StatusMessage(
                message: _settings.message!,
                isError: _settings.messageIsError,
              ),
            ],
            const SizedBox(height: 14),
            Text(
              'Ключ хранится локально и автоматически добавляется в заголовок X-Api-Key каждого запроса через AuthInterceptor.',
              style: TextStyle(
                fontSize: 11,
                height: 1.5,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.message, required this.isError});

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isError
        ? scheme.error
        : (isDark ? AppColors.sageBright : AppColors.sage);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            message,
            style: AppText.microLabel.copyWith(
              color: color,
              fontSize: 11.5,
              letterSpacing: 0,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
