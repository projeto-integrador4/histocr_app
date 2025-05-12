import 'dart:io';

import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatMessage {
  final String? textContent;
  final File? image;
  final bool isUserMessage;
  final PredefinedMessageType? type;

  ChatMessage(
      {this.textContent, this.image, this.isUserMessage = false, this.type})
      : assert(
          (textContent != null || image != null || type != null),
          'Either text, image or type must be provided.',
        );

  static ChatMessage messagefromType(PredefinedMessageType type) =>
      ChatMessage(type: type);
}
