import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/theme/app_colors.dart';

class SendPictureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool enabled;

  const SendPictureButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: secondaryColor,
          disabledBackgroundColor: secondaryColor.withOpacity(0.5),
        ),
        child: enabled
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    icon,
                  ),
                ],
              )
            : const Center(
                child: LoadingIndicator(),
              ),
      ),
    );
  }
}
