import 'package:flutter/material.dart';

class SkeletonList extends StatefulWidget {
  const SkeletonList({super.key, this.items = 3});

  final int items;

  @override
  State<SkeletonList> createState() => _SkeletonListState();
}

class _SkeletonListState extends State<SkeletonList>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = 0.35 + (_controller.value * 0.4);

        return Column(
          children: List.generate(widget.items, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Bar(
                        widthFactor: 0.62,
                        height: 15,
                        color: scheme.onSurfaceVariant.withValues(
                          alpha: opacity * 0.55,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Bar(
                        widthFactor: 0.4,
                        height: 10,
                        color: scheme.onSurfaceVariant.withValues(
                          alpha: opacity * 0.4,
                        ),
                      ),
                      const SizedBox(height: 7),
                      _Bar(
                        widthFactor: 0.28,
                        height: 10,
                        color: scheme.onSurfaceVariant.withValues(
                          alpha: opacity * 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: scheme.outlineVariant),
              ],
            );
          }),
        );
      },
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.widthFactor,
    required this.height,
    required this.color,
  });

  final double widthFactor;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
