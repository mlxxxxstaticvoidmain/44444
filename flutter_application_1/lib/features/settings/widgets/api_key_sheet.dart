import 'package:flutter/material.dart';

import '../../../core/theme/app_text.dart';
import 'api_key_form.dart';

Future<void> showApiKeySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: const _ApiKeySheet(),
      );
    },
  );
}

class _ApiKeySheet extends StatelessWidget {
  const _ApiKeySheet();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Подключите API Ninjas',
            style: AppText.display(30, scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            'Упражнения приходят из API Ninjas. Создайте бесплатный аккаунт, скопируйте ключ и вставьте его здесь — он останется на устройстве.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          ApiKeyForm(
            autofocus: true,
            onSaved: (saved) {
              if (saved) Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Позже'),
            ),
          ),
        ],
      ),
    );
  }
}
