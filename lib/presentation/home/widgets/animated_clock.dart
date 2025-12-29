import 'package:flutter/material.dart';

class AnimatedClock extends StatelessWidget {
  final DateTime now;
  final TextStyle? style;
  final String suffix;
  final Duration duration;

  const AnimatedClock({
    super.key,
    required this.now,
    this.style,
    this.suffix = 'WIB',
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  Widget build(BuildContext context) {
    final timeText =
        '${_two(now.hour)}:${_two(now.minute)}:${_two(now.second)}';

    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Text(
        suffix.isNotEmpty ? '$timeText $suffix' : timeText,
        key: ValueKey(timeText),
        style:
            style ??
            const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
      ),
    );
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}
