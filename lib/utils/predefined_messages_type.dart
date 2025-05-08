enum PredefinedMessageType {
  firstMessage,
  requestAvaliation,
  requestEdit,
  editName
}

extension PredefinedMessageTypeExtension on PredefinedMessageType {
  String get text {
    switch (this) {
      case PredefinedMessageType.firstMessage:
        return "Olá! O que você gostaria de transcrever hoje?";
      case PredefinedMessageType.requestAvaliation:
        return "Você gostaria de nos ajudar avaliando essa transcrição?";
      case PredefinedMessageType.requestEdit:
        return "Você gostaria de corrigir os erros nessa transcrição?";
      case PredefinedMessageType.editName:
        return "Sua transcrição está quase pronta! Você pode editar o nome dela clicando no ícone abaixo:";
    }
  }

  bool get isUserMessage {
    return false; // All predefined messages are not user messages
  }
}