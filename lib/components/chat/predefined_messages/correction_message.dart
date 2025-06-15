import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';
import 'package:histocr_app/components/network_image_with_fallback.dart';
import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/image_helper.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';
import 'package:provider/provider.dart';

class CorrectionMessage extends StatelessWidget {
  final Document document;
  final Function(String)? onCorrectionSaved;
  late final TextEditingController transcriptionController;

  CorrectionMessage({
    super.key,
    required this.document,
    this.onCorrectionSaved,
  }) : transcriptionController =
            TextEditingController(text: document.transcription);

  _buildModalBottomSheet(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    return ChatBubble(
      child: Column(
        children: [
          Text(PredefinedMessageType.correction.text),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                onPressed: () async => _handleYesSelected(provider, context),
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
                onPressed: () => _handleNoSelected(provider),
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

  void _handleNoSelected(ChatProvider provider) {
    provider.addMessage(
      ChatMessage(textContent: "Não", isUserMessage: true),
    );
    _addEditNameMessage(provider);
  }

  Future<void> _handleYesSelected(
      ChatProvider provider, BuildContext context) async {
    {
      provider.addMessage(ChatMessage(textContent: "Sim", isUserMessage: true));
      await showDialog(
          context: context,
          builder: (context) {
            return CorrectionDialog(
              originalText: document.transcription,
              onCorrectionSaved: onCorrectionSaved,
              imageUrl: getImageUrl(document.uploadedFilePaths[0]),
            );
          });
      provider.addMessage(
          ChatMessage(textContent: "Aqui está seu texto corrigido:"));
      provider.addMessage(ChatMessage.fromType(
          PredefinedMessageType.transcription,
          textContent: document.correctedText));
      _addEditNameMessage(provider);
    }
  }

  void _addEditNameMessage(ChatProvider provider) {
    provider.addMessage(ChatMessage.fromType(
      PredefinedMessageType.editName,
      document: document,
    ));
  }
}

class CorrectionDialog extends StatelessWidget {
  final String originalText;
  final Function(String)? onCorrectionSaved;
  final String imageUrl; // Placeholder for image URL
  const CorrectionDialog(
      {super.key,
      required this.originalText,
      this.onCorrectionSaved,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final TextEditingController transcriptionController =
        TextEditingController(text: originalText);
    final ValueNotifier<bool> isSaveEnabled = ValueNotifier(
        transcriptionController.text.isNotEmpty &&
            transcriptionController.text != originalText);

    transcriptionController.addListener(() {
      isSaveEnabled.value = transcriptionController.text.isNotEmpty &&
          transcriptionController.text != originalText;
    });

    return Dialog.fullscreen(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                NetworkImageWithFallback(
                  path: imageUrl,
                  scale: 0.4,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: transcriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 8),
                ValueListenableBuilder<bool>(
                  valueListenable: isSaveEnabled,
                  builder: (context, value, child) => FilledButton(
                    onPressed: value
                        ? () => _handleSaveCorrection(
                            transcriptionController.text, context)
                        : null,
                    style:
                        FilledButton.styleFrom(backgroundColor: secondaryColor),
                    child: Text(
                      "Enviar",
                      style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSaveCorrection(String correctedText, BuildContext context) async {
    final navigator = Navigator.of(context);
    await onCorrectionSaved?.call(correctedText);
    navigator.pop();
  }
}
