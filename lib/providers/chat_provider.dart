import 'package:histocr_app/providers/base_provider.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatProvider extends BaseProvider {
  List<ChatMessage> messages = [
    ChatMessage.fromType(PredefinedMessageType.firstMessage)
  ];

  void addMessage(ChatMessage message) {
    messages.add(message);
    notifyListeners();
  }
}

class ChatMessage {
  final String? text;
  final bool isUserMessage;

  ChatMessage({this.text, required this.isUserMessage});

  static ChatMessage fromType(PredefinedMessageType type) => ChatMessage(
      text: type.text,
      isUserMessage: type.isUserMessage,
    );
}
