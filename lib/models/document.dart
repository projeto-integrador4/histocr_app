class Document {
  final String id;
  final String name;
  final String originalText;
  final String? correctedText;
  int? rating;
  final List<String> imageUrls;
  final DateTime? updatedAt;

  Document(
      {required this.id,
      required this.name,
      required this.originalText,
      this.correctedText,
      this.rating,
      required this.imageUrls,
      this.updatedAt});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['document_name'],
      originalText: json['original_text'],
      correctedText: json['transcripted_text'],
      rating: json['rating']?.toInt(),
      imageUrls: json['storage_object_path'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static Document fromTranscriptionResponseJson(json) {
    return Document(
      id: json['documentId'],
      name: json['documentName'],
      originalText: json['transcribedText'],
      imageUrls: (json['uploadedFilePaths'] as List).map((e) => e.toString()).toList(),
    );
  }
}
