import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';

class TranscriptionMessage extends StatefulWidget {
  final String transcription;

  const TranscriptionMessage({
    super.key,
    required this.transcription,
  });

  @override
  State<TranscriptionMessage> createState() => _TranscriptionMessageState();
}

class _TranscriptionMessageState extends State<TranscriptionMessage> {
  bool _copied = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleCopy() async {
    await Clipboard.setData(
      ClipboardData(text: widget.transcription),
    );
    setState(() {
      _copied = true;
    });
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _copied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.transcription),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: _handleCopy,
                child: Row(
                  children: [
                    Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                      size: 16,
                      color: _copied ? Colors.green : null,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _copied ? "Copiado!" : "Copiar",
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
