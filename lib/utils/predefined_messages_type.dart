enum PredefinedMessageType {
  firstMessage,
  rating,
  correction,
  editName,
  transcription,
  typing,
  permissionTip
}

extension PredefinedMessageTypeExtension on PredefinedMessageType {
  String get text => switch (this) {
        PredefinedMessageType.firstMessage =>
          "Olá! O que você gostaria de transcrever?",
        PredefinedMessageType.rating =>
          "Você gostaria de nos ajudar avaliando essa transcrição?",
        PredefinedMessageType.correction =>
          "Você gostaria de corrigir os erros nessa transcrição?",
        PredefinedMessageType.editName => "Sua transcrição ficará salva como:",
        PredefinedMessageType.permissionTip =>
          "Para que possamos acessar suas fotos, você vai precisar permitir o acesso a todas as imagens do dispositivo.",
        _ => '',
      };
}
