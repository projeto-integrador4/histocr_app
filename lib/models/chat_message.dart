import 'dart:io';

import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class ChatMessage {
  final String? textContent;
  final File? image;
  final Document? document;
  final bool isUserMessage;
  final PredefinedMessageType? type;
  final int? rating;

  ChatMessage( 
      {this.document,
      this.textContent,
      this.image,
      this.isUserMessage = false,
      this.rating,
      this.type})
      : assert(
          (textContent != null || image != null || type != null || rating != null),
          'Either text, image, rating or type must be provided.',
        );

  factory ChatMessage.fromType(PredefinedMessageType type,
          {Document? document, String? textContent}) =>
      ChatMessage(type: type, document: document, textContent: textContent);
}
