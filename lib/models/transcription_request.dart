import 'package:histocr_app/models/image_transcription_request.dart';

class TranscriptionRequest {
  final List<ImageTranscriptionRequest> images;
  final String? organizationId;

  TranscriptionRequest({
    required this.images,
    this.organizationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'images': images.map((image) => image.toJson()).toList(),
      'organizationId': organizationId,
    };
  }
}