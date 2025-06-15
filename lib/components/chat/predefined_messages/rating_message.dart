import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';
import 'package:histocr_app/components/star_review.dart';
import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';
import 'package:provider/provider.dart';

class RatingMessage extends StatelessWidget {
  final Function(int)? onRatingChanged;
  final Document document;

  const RatingMessage({
    super.key,
    this.onRatingChanged,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    return ChatBubble(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(PredefinedMessageType.rating.text),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () async => _handleYesRatingSelected(provider, context),
                style: FilledButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text(
                  "Sim",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () => _handleNoRatingSelected(provider),
                style: FilledButton.styleFrom(
                  backgroundColor: secondaryColor,
                ),
                child: Text(
                  "Não",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _handleNoRatingSelected(ChatProvider provider) {
    provider.addMessage(
      ChatMessage(textContent: "Não", isUserMessage: true),
    );
    _addCorrectionMessage(provider);
  }

  Future<void> _handleYesRatingSelected(
      ChatProvider provider, BuildContext context) async {
    {
      provider.addMessage(
        ChatMessage(textContent: "Sim", isUserMessage: true),
      );
      await showDialog(
          context: context,
          builder: (context) => RatingDialog(
                rating: document.rating ?? 0,
                onRatingChanged: onRatingChanged,
              ));
      provider.addMessage(ChatMessage(
        isUserMessage: true,
        rating: document.rating,
      ));
      _addCorrectionMessage(provider);
    }
  }

  void _addCorrectionMessage(ChatProvider provider) {
    provider.addMessage(ChatMessage.fromType(
      PredefinedMessageType.correction,
      document: document,
    ));
  }
}

class RatingDialog extends StatefulWidget {
  final int? rating;
  final Function(int)? onRatingChanged;
  const RatingDialog(
      {super.key, required this.rating, required this.onRatingChanged});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late int rating;

  @override
  void initState() {
    super.initState();
    rating = widget.rating ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Avalie a transcrição',
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      content: StarReview(
        rating: rating,
        size: 36,
        onRatingChanged: (newRating) => setState(() {
          rating = newRating;
        }),
      ),
      actions: [
        FilledButton(
          onPressed: () => _handleSaveRating(rating, context),
          style: FilledButton.styleFrom(backgroundColor: secondaryColor),
          child: Text(
            "Salvar",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _handleSaveRating(int newRating, BuildContext context) async {
    final navigator = Navigator.of(context);
    await widget.onRatingChanged?.call(newRating);
    navigator.pop();
  }
}
