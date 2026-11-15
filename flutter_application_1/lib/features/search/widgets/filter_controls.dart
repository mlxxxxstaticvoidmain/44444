import 'package:flutter/material.dart';

class FilterPill extends StatelessWidget {
  const FilterPill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(3),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? scheme.primary : Colors.transparent,
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
            ),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              height: 1.1,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? scheme.onPrimary : scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class FilterSelectButton extends StatelessWidget {
  const FilterSelectButton({
    super.key,
    required this.label,
    required this.value,
    required this.active,
  });

  final String label;
  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(
          color: active ? scheme.onSurface : scheme.outlineVariant,
          width: active ? 1.2 : 1,
        ),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.expand_more,
            size: 15,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
