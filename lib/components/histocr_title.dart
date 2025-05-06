import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/theme/app_colors.dart';

class HistocrTitle extends StatelessWidget {
  const HistocrTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'HistOCR',
      style: GoogleFonts.inter(
        fontSize: 48.0,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );
  }
}
