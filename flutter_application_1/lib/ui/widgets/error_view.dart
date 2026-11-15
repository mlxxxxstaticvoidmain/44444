import 'package:flutter/material.dart';

import '../../core/theme/app_text.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    this.statusCode,
    this.onOpenSettings,
  });

  final String message;
  final int? statusCode;
  final VoidCallback onRetry;
  final VoidCallback? onOpenSettings;

  bool get _needsKey => statusCode == 401 || statusCode == 403;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(
          left: BorderSide(color: scheme.secondary, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _needsKey ? Icons.key_off_outlined : Icons.cloud_off_outlined,
                size: 20,
                color: scheme.secondary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _needsKey ? 'Нужен действующий ключ' : 'Запрос не выполнен',
                  style: AppText.microLabel.copyWith(
                    color: scheme.onSurface,
                    fontSize: 12.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.5,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text('Повторить'),
              ),
              if (_needsKey && onOpenSettings != null)
                OutlinedButton(
                  onPressed: onOpenSettings,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                  ),
                  child: const Text('Указать ключ'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
