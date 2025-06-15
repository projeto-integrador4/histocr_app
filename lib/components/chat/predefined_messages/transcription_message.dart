import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';

class TranscriptionMessage extends StatelessWidget {
  final String transcription;

  const TranscriptionMessage({
    super.key,
    required this.transcription,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transcription),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(//TODO adicionar indicador de copiado
                onTap: () => Clipboard.setData(
                  ClipboardData(text: transcription),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.copy_rounded,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Copiar",
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                  ],
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     //TODO google docs
              //   },
              //   child: Row(
              //     children: [
              //       const Icon(
              //         Icons.description_rounded,
              //         size: 16,
              //       ),
              //       const SizedBox(width: 4),
              //       Text(
              //         "Google Docs",
              //         style: GoogleFonts.inter(fontSize: 12),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}