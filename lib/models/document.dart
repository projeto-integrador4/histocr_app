class Document {
  final String id;
  final String name;
  final String originalText;
  final String? correctedText;
  int? rating;
  final String? imageUrl;

  Document(
      {required this.id,
      required this.name,
      required this.originalText,
      required this.correctedText,
      required this.rating,
      required this.imageUrl});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'],
      name: json['document_name'],
      originalText: json['original_text'],
      correctedText: json['transcripted_text'],
      rating: json['rating']?.toInt(),
      imageUrl: json['storage_object_path'],
    );
  }
}
