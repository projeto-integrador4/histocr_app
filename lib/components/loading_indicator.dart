import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          color: textColor,
        ),
      );
  }
}
