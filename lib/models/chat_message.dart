import 'dart:io';

import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatMessage {
  final String? textContent;
  final File? image;
  final Document? document;
  final bool isUserMessage;
  final PredefinedMessageType? type;

  ChatMessage(
      {this.document, this.textContent, this.image, this.isUserMessage = false, this.type})
      : assert(
          (textContent != null || image != null || type != null),
          'Either text, image or type must be provided.',
        );

  factory ChatMessage.messagefromType(PredefinedMessageType type, {Document? document}) =>
      ChatMessage(type: type, document: document);
}
