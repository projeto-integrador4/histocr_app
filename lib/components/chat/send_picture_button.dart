import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/theme/app_colors.dart';

class SendPictureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const SendPictureButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: secondaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
