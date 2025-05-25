import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/network_image_with_fallback.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/utils/image_helper.dart';
import 'package:histocr_app/utils/routes.dart';

class LastTranscriptsItem extends StatelessWidget {
  final Document document;
  final bool isOnHomeScreen;

  const LastTranscriptsItem(
      {super.key, this.isOnHomeScreen = true, required this.document});

  String _getTimeAgo() {
    final now = DateTime.now();
    final updatedAt = document.updatedAt!;
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 1) {
      return 'Agora mesmo';
    } else if (difference.inMinutes < 60) {
      final min = difference.inMinutes;
      return 'Há $min ${min == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      final hr = difference.inHours;
      return 'Há $hr ${hr == 1 ? 'hora' : 'horas'}';
    } else if (difference.inDays < 30) {
      final days = difference.inDays;
      return 'Há $days ${days == 1 ? 'dia' : 'dias'}';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return 'Há $months ${months == 1 ? 'mês' : 'meses'}';
    } else {
      final years = (difference.inDays / 365).floor();
      return 'Há $years ${years == 1 ? 'ano' : 'anos'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.documentDetail,
        arguments: document,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isOnHomeScreen ? 84 : 100,
            height: isOnHomeScreen ? 84 : 100,
            child: NetworkImageWithFallback(
              path: getImageUrl(document.uploadedFilePaths.first),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  document.transcription,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: isOnHomeScreen ? 2 : 3,
                ),
                const SizedBox(height: 4),
                Visibility(
                  visible: !isOnHomeScreen,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _getTimeAgo(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
