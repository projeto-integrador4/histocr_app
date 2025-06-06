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
    ChatMessage.messagefromType(PredefinedMessageType.firstMessage)
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
      final document = await DocumentService.getTranscription(request);
      documentsProvider.addNewDocument(document!);
      _addResponseMessages(document);
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

  void updateDocumentRating(
      {required Document document, required int rating}) async {
    try {
      await documentsProvider.updateDocumentRating(
          document: document, rating: rating);
      _updateDocumentRatingInChat(document, rating);
    } catch (e) {
      _addMessage(
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
      _addMessage(
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
      _addMessage(
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

  void _addResponseMessages(Document document) {
    final responseMessages = [
      ChatMessage(
        document: document,
        type: PredefinedMessageType.transcription,
      ),
      ChatMessage.messagefromType(PredefinedMessageType.rating,
          document: document),
      ChatMessage.messagefromType(PredefinedMessageType.correction,
          document: document),
      ChatMessage.messagefromType(PredefinedMessageType.editName,
          document: document),
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
