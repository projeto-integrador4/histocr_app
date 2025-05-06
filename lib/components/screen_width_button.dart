import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenWidthButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  const ScreenWidthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
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
        child: Text(
          label,
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
