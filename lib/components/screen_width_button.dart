import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/loading_indicator.dart';

class ScreenWidthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool loading;

  const ScreenWidthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color,
        ),
        child: loading
            ? const LoadingIndicator()
            : Text(
                label,
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
