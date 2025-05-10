import 'dart:io';

import 'package:flutter/material.dart';
import 'package:histocr_app/components/camera_picker/custom_camera_picker_viewer_state.dart';
import 'package:histocr_app/components/camera_picker/miniature_widgets.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CustomCameraPickerState extends CameraPickerState {
  List<File> images = [];
  File get currentImage => images.isNotEmpty ? images.last : File('');

  CustomCameraPickerState({required this.images});

  @override
  Widget buildCameraPreview({
    required BuildContext context,
    required CameraValue cameraValue,
    required BoxConstraints constraints,
  }) {
    // Use the parent class's implementation for the preview
    Widget preview = super.buildCameraPreview(
      context: context,
      cameraValue: cameraValue,
      constraints: constraints,
    );

    return Stack(
      children: [
        preview,
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: MiniaturePreviewList(
              itemCount: images.length,
              itemBuilder: (context, index) =>
                  buildMiniaturePreview(images[index]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Future<AssetEntity?> pushToViewer({
    required XFile file,
    required CameraPickerViewType viewType,
  }) async {
    final File imageFile = File(file.path);
    setState(() {
      if (!images.contains(imageFile)) {
        images.add(imageFile);
      }
    });

    final result = await CameraPickerViewer.pushToViewer(
      context,
      pickerConfig: pickerConfig,
      viewType: viewType,
      previewXFile: file,
      createViewerState: () => CustomCameraPickerViewerState(
        images: images,
        currentIndex: images.indexOf(imageFile),
      ),
    );
    return result;
  }

  Widget buildMiniaturePreview(File image) {
    return MiniaturePreview(
      image: image,
      selectImage: () {
        pushToViewer(
          file: XFile(image.path),
          viewType: CameraPickerViewType.image,
        );
      },
      removeImage: () {
        setState(() {
          images.remove(image);
        });
      },
    );
  }
}
