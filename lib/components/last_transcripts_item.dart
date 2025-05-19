import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/models/document.dart';

class LastTranscriptsItem extends StatelessWidget {
  final Document document;
  final Function()? onTap;
  final bool isOnHomeScreen;

  const LastTranscriptsItem(
      {super.key,
      this.isOnHomeScreen = true,
      this.onTap,
      required this.document});
  
  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(document.updatedAt);
    if (difference.inMinutes < 60) {
      return 'Há ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Há ${difference.inHours} horas';
    } else {
      return 'Há ${difference.inDays} dias';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: isOnHomeScreen ? 84 : 100,
            height: isOnHomeScreen ? 84 : 100,
            child: document.imageUrl != null
                ? CachedNetworkImage(imageUrl: document.imageUrl!)
                : null,
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
                  document.correctedText ?? document.originalText,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
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
