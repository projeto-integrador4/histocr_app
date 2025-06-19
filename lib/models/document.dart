class Document {
  final String id;
  final String? userId;
  final String? organizationId;
  String name;
  final String originalText;
  String? correctedText;
  int? rating;
  final List<String> uploadedFilePaths;
  final DateTime? updatedAt;

  Document(
      {required this.id,
      this.userId,
      this.organizationId,
      required this.name,
      required this.originalText,
      this.correctedText,
      this.rating,
      required this.uploadedFilePaths,
      this.updatedAt});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      userId: json['user_id'],
      organizationId: json['organization_id'],
      name: json['document_name'],
      originalText: json['transcripted_text'],
      correctedText: json['corrected_text'],
      rating: json['rating']?.toInt(),
      uploadedFilePaths: (json['storage_object_path'] as List)
          .map((e) => e.toString())
          .toList(),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  factory Document.fromTranscriptionResponseJson(Map<String, dynamic> json, String? organizationId) {
    return Document(
      id: json['documentId'],
      name: json['documentName'],
      originalText: json['transcribedText'],
      organizationId: organizationId,
      updatedAt: DateTime.now()
          .subtract(Duration(milliseconds: json['totalProcessingTimeMs'])),
      uploadedFilePaths:
          (json['uploadedFilePaths'] as List).map((e) => e.toString()).toList(),
    );
  }

  String get transcription => correctedText ?? originalText;
}
