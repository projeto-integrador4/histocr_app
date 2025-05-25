import 'dart:io';

import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/models/image_transcription_request.dart';
import 'package:histocr_app/models/transcription_request.dart';
import 'package:histocr_app/providers/base_provider.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatProvider extends BaseProvider {
  List<ChatMessage> messages = [
    ChatMessage.messagefromType(PredefinedMessageType.firstMessage)
  ];
  Document? document;
  bool didAddDocument = false;

  // --- Public API ---

  @override
  void setLoading(bool status) {
    if (status) {
      _addTypingMessage();
    } else {
      _removeTypingMessage();
    }
    super.setLoading(status);
  }

  void clear() {
    messages.clear();
    document = null;
    didAddDocument = false;
    _addMessage(
        ChatMessage.messagefromType(PredefinedMessageType.firstMessage));
    notifyListeners();
  }

  void getTranscription(List<File> images) async {
    if (images.isEmpty) return;
    _addUserMessages(images);

    try {
      setLoading(true);

      final request = await _buildFunctionRequest(images: images);
      final response = await supabase.functions.invoke(
        'gemini',
        body: request.toJson(),
      );

      document = Document.fromTranscriptionResponseJson(response.data);
      didAddDocument = true;
      _addResponseMessages();
    } catch (e) {
      _addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao processar a imagem, tente novamente.',
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  void updateRating(int rating) async {
    try {
      if (document?.id == null) return;
      await supabase
          .from('documents')
          .update({'rating': rating}).eq('id', document!.id);
      document!.rating = rating;
      notifyListeners();
    } catch (e) {
      _addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar a sua avaliação, tente novamente.',
        ),
      );
    }
  }

  void updateDocumentName(String name) async {
    if (document?.id == null) return;
    try {
      await supabase
          .from('documents')
          .update({'document_name': name}).eq('id', document!.id);
      document!.name = name;
      notifyListeners();
    } catch (e) {
      _addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar o nome do seu documento, tente novamente.',
        ),
      );
    }
  }

  void sendCorrection(String text) async {
    try {
      if (document?.id == null) return;
      await supabase
          .from('documents')
          .update({'corrected_text': text}).eq('id', document!.id);
      document!.correctedText = text;
      notifyListeners();
    } catch (e) {
      _addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar a sua correção, tente novamente.',
        ),
      );
    }
  }

  Future<void> addPermissionTip() async {
    if (messages.any(
        (message) => message.type == PredefinedMessageType.permissionTip)) {
      return;
    }
    _addMessage(ChatMessage.messagefromType(
      PredefinedMessageType.permissionTip,
    ));
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }

  // --- Private helpers ---

  void _addMessage(ChatMessage message) {
    messages.insert(0, message);
    notifyListeners();
  }

  void _addUserMessages(List<File> images) {
    final userMessages = images
        .map((image) => ChatMessage(image: image, isUserMessage: true))
        .toList();
    userMessages.forEach(_addMessage);
  }

  void _addResponseMessages() {
    final responseMessages = [
      ChatMessage(
        textContent: document?.originalText,
        type: PredefinedMessageType.transcription,
      ),
      ChatMessage.messagefromType(PredefinedMessageType.rating),
      ChatMessage.messagefromType(PredefinedMessageType.correction),
      ChatMessage.messagefromType(PredefinedMessageType.editName),
    ];
    responseMessages.forEach(_addMessage);
  }

  void _addTypingMessage() {
    messages.insert(
      0,
      ChatMessage.messagefromType(PredefinedMessageType.typing),
    );
  }

  void _removeTypingMessage() {
    messages.removeWhere(
      (message) => message.type == PredefinedMessageType.typing,
    );
  }

  Future<TranscriptionRequest> _buildFunctionRequest({
    required List<File> images,
  }) async {
    final imageTranscriptionRequests = await Future.wait(
      images.map((image) => ImageTranscriptionRequest.fromFile(image)),
    );

    return TranscriptionRequest(
      images: imageTranscriptionRequests,
    );
  }
}
