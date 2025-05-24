import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';
import 'package:histocr_app/components/star_review.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/image_helper.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class RatingMessage extends StatelessWidget {
  final Function(int)? onRatingChanged;
  final int rating;

  const RatingMessage({
    super.key,
    this.onRatingChanged,
    this.rating = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: Column(
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
      ),
    );
  }
}

class CorrectionMessage extends StatelessWidget {
  final Document document;
  final Function(String)? onCorrectionSaved;
  late final TextEditingController transcriptionTextEditingController;

  CorrectionMessage({
    super.key,
    required this.document,
    this.onCorrectionSaved,
  }) : transcriptionTextEditingController = TextEditingController(
            text: document.correctedText ?? document.originalText);

  Widget _buildModalBottomSheet(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: SingleChildScrollView(
          clipBehavior: Clip.antiAlias,
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
                imageUrl: getImageUrl(document.uploadedFilePaths[0]),
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  size: 36,
                ),
                scale: 0.4,
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
                  onCorrectionSaved?.call(
                    transcriptionTextEditingController.text,
                  );
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: Column(
        children: [
          Text(PredefinedMessageType.correction.text),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => showModalBottomSheet(
                clipBehavior: Clip.antiAlias,
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
      ),
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
    return ChatBubble(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(transcription),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
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

class EditNameMessage extends StatelessWidget {
  final String name;
  final Function(String)? onNameChanged;

  const EditNameMessage({
    super.key,
    required this.name,
    this.onNameChanged,
  });

  Widget _buildEditNameDialog(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: name);

    return AlertDialog(
      title: Text(
        'Editar nome',
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: "Nome",
        ),
      ),
      actions: [
        FilledButton(
          onPressed: () {
            onNameChanged?.call(nameController.text);
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(backgroundColor: secondaryColor),
          child: Text(
            "Salvar",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: Column(
        children: [
          Text(PredefinedMessageType.editName.text),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => _buildEditNameDialog(context),
                  );
                },
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
