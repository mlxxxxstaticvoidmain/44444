import 'package:flutter/material.dart';

import '../../core/theme/app_text.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: AppText.display(24, scheme.onSurface)),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 1,
              color: scheme.outlineVariant,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class MetaChip extends StatelessWidget {
  const MetaChip(this.label, {super.key, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12.5, color: scheme.onSurfaceVariant),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: AppText.microLabel.copyWith(
              color: scheme.onSurfaceVariant,
              fontSize: 11,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
