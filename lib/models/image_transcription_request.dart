import 'dart:convert';
import 'dart:io';

import 'package:histocr_app/utils/image_helper.dart';

class ImageTranscriptionRequest {
  final String fileName;
  final String base64Data;
  final String mimeType;

  ImageTranscriptionRequest({
    required this.fileName,
    required this.base64Data,
    required this.mimeType,
  });

  Map<String, String> toJson() {
    return {
      'filename': fileName,
      'base64Data': base64Data,
      'mimeType': mimeType,
    };
  }
  
  static Future<ImageTranscriptionRequest> fromFile(File image) async {
    final fileName = image.path.split('/').last;
    final uint8List = await compressImage(image);
    final mimeType = 'image/${fileName.split('.').last}';

    return ImageTranscriptionRequest(
      fileName: fileName,
      base64Data: base64Encode(uint8List),
      mimeType: mimeType,
    );
  }
}