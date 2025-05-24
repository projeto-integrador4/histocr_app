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
      originalText: json['original_text'],
      correctedText: json['transcripted_text'],
      rating: json['rating']?.toInt(),
      uploadedFilePaths: json['storage_object_path'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static Document fromTranscriptionResponseJson(json) {
    return Document(
      id: json['documentId'],
      name: json['documentName'],
      originalText: json['transcribedText'],
      uploadedFilePaths:
          (json['uploadedFilePaths'] as List).map((e) => e.toString()).toList(),
    );
  }
}
