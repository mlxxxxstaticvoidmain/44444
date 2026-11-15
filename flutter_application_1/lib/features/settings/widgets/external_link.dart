import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExternal(BuildContext context, String url) async {
  try {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.platformDefault,
    );
    if (!launched && context.mounted) {
      _showError(context);
    }
  } catch (_) {
    if (context.mounted) _showError(context);
  }
}

void _showError(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      const SnackBar(
        content: Text('Не удалось открыть браузер. Ссылка: api-ninjas.com'),
      ),
    );
}
