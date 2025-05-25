import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:histocr_app/main.dart';

Future<Uint8List> compressAndEncodeImage(File image) async {
  // Apply if image size > 50 MB
  if (image.lengthSync() < 50 * 1024 * 1024) {
    return await image.readAsBytes();
  } else {
    var result = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 50,
    );
    return result!;
  }
}

String getImageUrl(String uploadedPath) {
  return supabase.storage.from('documents').getPublicUrl(uploadedPath);
}
