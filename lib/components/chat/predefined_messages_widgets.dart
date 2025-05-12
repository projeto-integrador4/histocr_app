import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/star_review.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class PredefinedRatingMessage extends StatelessWidget {
  final Function(int)? onRatingChanged;
  final int rating;

  const PredefinedRatingMessage({
    super.key,
    this.onRatingChanged,
    this.rating = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(PredefinedMessageType.rating.text),
        const SizedBox(height: 8),
        StarReview(
          rating: rating,
          size: 36,
          onRatingChanged: onRatingChanged,
        ),
      ],
    );
  }
}

class PredefinedCorrectionMessage extends StatelessWidget {
  final Document document;
  late final TextEditingController transcriptionTextEditingController;

  PredefinedCorrectionMessage({
    super.key,
    required this.document,
  }) : transcriptionTextEditingController =
            TextEditingController(text: document.originalText);

  Widget _buildModalBottomSheet(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.close,
                size: 36,
              ),
            ),
            const SizedBox(height: 8),
            CachedNetworkImage(
              imageUrl: document.imageUrl!,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
                size: 36,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: transcriptionTextEditingController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                //TODO send the correction
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(backgroundColor: secondaryColor),
              child: Text(
                "Enviar",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(PredefinedMessageType.correction.text),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              context: context,
              builder: (context) => _buildModalBottomSheet(context)),
          style: FilledButton.styleFrom(backgroundColor: secondaryColor),
          child: Text(
            "Sim",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class TranscriptionMessage extends StatelessWidget {
  final String transcription;

  const TranscriptionMessage({
    super.key,
    required this.transcription,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(transcription),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                //TODO copy the transcription
              },
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
            InkWell(
              onTap: () {
                //TODO copy the transcription
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.description_rounded,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Google Docs",
                    style: GoogleFonts.inter(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
