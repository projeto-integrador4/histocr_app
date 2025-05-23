enum PredefinedMessageType {
  firstMessage,
  rating,
  correction,
  editName,
  transcription,
  typing
}

extension PredefinedMessageTypeExtension on PredefinedMessageType {
  String get text {
    switch (this) {
      case PredefinedMessageType.firstMessage:
        return "Olá! O que você gostaria de transcrever?";
      case PredefinedMessageType.rating:
        return "Você gostaria de nos ajudar avaliando essa transcrição?";
      case PredefinedMessageType.correction:
        return "Você gostaria de corrigir os erros nessa transcrição?";
      case PredefinedMessageType.editName:
        return "Sua transcrição ficará salva como:";
      default:
        return '';
    }
  }
}
