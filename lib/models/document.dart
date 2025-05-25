class Document {
  final String id;
  String name;
  final String originalText;
  String? correctedText;
  int? rating;
  final List<String> uploadedFilePaths;
  final DateTime? updatedAt;

  Document(
      {required this.id,
      required this.name,
      required this.originalText,
      this.correctedText,
      this.rating,
      required this.uploadedFilePaths,
      this.updatedAt});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['document_name'],
      originalText: json['transcripted_text'],
      correctedText: json['corrected_text'],
      rating: json['rating']?.toInt(),
      uploadedFilePaths: (json['storage_object_path'] as List).map((e) => e.toString()).toList(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  factory Document.fromTranscriptionResponseJson(json) {
    return Document(
      id: json['documentId'],
      name: json['documentName'],
      originalText: json['transcribedText'],
      uploadedFilePaths:
          (json['uploadedFilePaths'] as List).map((e) => e.toString()).toList(),
    );
  }

  String get transcription => correctedText ?? originalText;
}
