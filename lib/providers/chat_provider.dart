import 'dart:io';

import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/base_provider.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatProvider extends BaseProvider {
  List<ChatMessage> messages = [
    ChatMessage.messagefromType(PredefinedMessageType.firstMessage)
  ];
  Document? document;

  void addMessage(ChatMessage message) {
    messages.insert(0, message);
    notifyListeners();
  }

  void addUserMessages(List<File> images) {
    if (images.isEmpty) return;
    final userMessages = images
        .map((image) => ChatMessage(image: image, isUserMessage: true))
        .toList();
    userMessages.forEach(addMessage);

    getTranscription();
  }

  void addResponseMessages() {
    final responseMessages = [
      ChatMessage(
          textContent: document?.originalText,
          type: PredefinedMessageType.transcription),
      ChatMessage.messagefromType(PredefinedMessageType.rating),
      ChatMessage.messagefromType(PredefinedMessageType.correction),
      ChatMessage.messagefromType(PredefinedMessageType.editName),
    ];
    responseMessages.forEach(addMessage);
  }

  void clearMessages() {
    messages.clear();
    addMessage(ChatMessage.messagefromType(PredefinedMessageType.firstMessage));
    notifyListeners();
  }

  void getTranscription() async {
    try {
      final response =
          await supabase.from('documents').select().limit(1).single();
      document = Document.fromJson(response);
      addResponseMessages();
    } catch (e) {
      addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao fazer a sua transcrição, tente novamente.',
        ),
      );
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
      addMessage(
        ChatMessage(
          textContent:
              'Ocorreu um erro $e ao atualizar a sua avaliação, tente novamente.',
        ),
      );
    }
  }
}
