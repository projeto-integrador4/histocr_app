import 'dart:math';

import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

class TypingIndicatorMessage extends StatelessWidget {
  const TypingIndicatorMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:  Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color:  white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.zero,
            bottomRight: Radius.circular(15),
          ),
        ),
        child: TypingIndicator(),
      ),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  final List<Interval> dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1.0),
  ];

  final Color flashingCircleDarkColor = textColor.withOpacity(0.8);
  final Color flashingCircleBrightColor = textColor.withOpacity(0.5);

  TypingIndicator({
    super.key,
  });

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController repeatingController;

  @override
  void initState() {
    super.initState();
    repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    repeatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FlashingCircle(
          index: 0,
          repeatingController: repeatingController,
          dotIntervals: widget.dotIntervals,
          flashingCircleDarkColor: widget.flashingCircleDarkColor,
          flashingCircleBrightColor: widget.flashingCircleBrightColor,
        ),
        FlashingCircle(
          index: 1,
          repeatingController: repeatingController,
          dotIntervals: widget.dotIntervals,
          flashingCircleDarkColor: widget.flashingCircleDarkColor,
          flashingCircleBrightColor: widget.flashingCircleBrightColor,
        ),
        FlashingCircle(
          index: 2,
          repeatingController: repeatingController,
          dotIntervals: widget.dotIntervals,
          flashingCircleDarkColor: widget.flashingCircleDarkColor,
          flashingCircleBrightColor: widget.flashingCircleBrightColor,
        ),
      ],
    );
  }
}

class FlashingCircle extends StatelessWidget {
  const FlashingCircle({
    super.key,
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repeatingController,
      builder: (context, child) {
        final circleFlashPercent = dotIntervals[index].transform(
          repeatingController.value,
        );
        final circleColorPercent = sin(pi * circleFlashPercent);

        return Container(
          width: 12,
          height: 12,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Color.lerp(
              flashingCircleDarkColor,
              flashingCircleBrightColor,
              circleColorPercent,
            ),
          ),
        );
      },
    );
  }
}
