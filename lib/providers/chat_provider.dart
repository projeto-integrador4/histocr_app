import 'dart:io';

import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/models/image_transcription_request.dart';
import 'package:histocr_app/models/transcription_request.dart';
import 'package:histocr_app/providers/base_provider.dart';
import 'package:histocr_app/providers/documents_provider.dart';
import 'package:histocr_app/services/document_service.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatProvider extends BaseProvider {
  DocumentsProvider documentsProvider;

  ChatProvider({required this.documentsProvider});

  List<ChatMessage> messages = [
    ChatMessage.fromType(PredefinedMessageType.firstMessage)
  ];
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
    addMessage(ChatMessage.fromType(PredefinedMessageType.firstMessage));
    notifyListeners();
  }

  void getTranscription(List<File> images) async {
    if (images.isEmpty) return;
    _addUserMessages(images);

    try {
      setLoading(true);

      final request = await _buildFunctionRequest(images: images);
      final document = await DocumentService.getTranscription(request);
      
      if (document!.originalText == "Não foi possível encontrar um texto") {
        addMessage(
          ChatMessage(
            textContent:
                'Não foi possível encontrar um texto na imagem, tente novamente com uma imagem diferente.',
          ),
        );
        return;
      }
      
      documentsProvider.addNewDocument(document);
      _addResponseMessages(document);
    } catch (e) {
      addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao processar a imagem, tente novamente.',
        ),
      );
    } finally {
      setLoading(false);
    }
  }

  void updateDocumentRating(
      {required Document document, required int rating}) async {
    try {
      await documentsProvider.updateDocumentRating(
          document: document, rating: rating);
      _updateDocumentRatingInChat(document, rating);
    } catch (e) {
      addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar a sua avaliação, tente novamente.',
        ),
      );
    }
  }

  void updateDocumentName(
      {required Document document, required String name}) async {
    try {
      await documentsProvider.updateDocumentName(
        name: name,
        document: document,
      );
      _updateDocumentNameInChat(document, name);
    } catch (e) {
      addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar o nome do seu documento, tente novamente.',
        ),
      );
    }
  }

  void sendCorrection(
      {required Document document, required String correction}) async {
    try {
      await documentsProvider.sendCorrection(
        document: document,
        correction: correction,
      );
      _updateDocumentTranscriptionInChat(document, correction);
    } catch (e) {
      addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar a sua correção, tente novamente.',
        ),
      );
    }
  }

  //TODO add popup before asking for permission the first time, instead of just showing the message
  Future<void> addPermissionTip() async {
    if (messages.any(
        (message) => message.type == PredefinedMessageType.permissionTip)) {
      return;
    }
    addMessage(ChatMessage.fromType(
      PredefinedMessageType.permissionTip,
    ));
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }

  void addMessage(ChatMessage message) {
    messages.insert(0, message);
    notifyListeners();
  }

  // --- Private helpers ---

  void _addUserMessages(List<File> images) {
    final userMessages = images
        .map((image) => ChatMessage(image: image, isUserMessage: true))
        .toList();
    userMessages.forEach(addMessage);
  }

  void _addResponseMessages(Document document) {
    final responseMessages = [
      ChatMessage(
        document: document,
        type: PredefinedMessageType.transcription,
        textContent: document.originalText,
      ),
      ChatMessage.fromType(PredefinedMessageType.rating, document: document),
    ];
    responseMessages.forEach(addMessage);
  }

  void _addTypingMessage() {
    messages.insert(
      0,
      ChatMessage.fromType(PredefinedMessageType.typing),
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

  int _findDocumentIndexInChat(String documentId) => messages.indexWhere(
        (message) => message.document?.id == documentId,
      );

  void _updateDocumentTranscriptionInChat(Document document, String text) {
    final index = _findDocumentIndexInChat(document.id);
    if (index != -1) {
      messages[index].document?.correctedText = text;
      notifyListeners();
    }
  }

  void _updateDocumentNameInChat(Document document, String name) {
    final index = _findDocumentIndexInChat(document.id);
    if (index != -1) {
      messages[index].document?.name = name;
      notifyListeners();
    }
  }

  void _updateDocumentRatingInChat(Document document, int rating) {
    final index = _findDocumentIndexInChat(document.id);
    if (index != -1) {
      messages[index].document?.rating = rating;
      notifyListeners();
    }
  }
}
