import 'package:flutter/material.dart';

class SummaryItemCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final Duration animationDuration;
  final VoidCallback? onTap;

  const SummaryItemCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.animationDuration = const Duration(milliseconds: 400),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.9, end: 1.0),
      duration: animationDuration,
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) {
        return Opacity(
          opacity: scale,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: color.withValues(alpha: 0.15),
        highlightColor: color.withValues(alpha: 0.08),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
