import 'dart:io';

import 'package:flutter/material.dart';
import 'package:histocr_app/components/camera_picker/custom_camera_picker_viewer_state.dart';
import 'package:histocr_app/components/camera_picker/miniature_widgets.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CustomCameraPickerState extends CameraPickerState {
  List<File> images = [];
  final int maxAssets;
  CustomCameraPickerState({required this.maxAssets});

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
        Align(
          alignment: Alignment.bottomCenter,
          child: Visibility(
            visible: images.length >= maxAssets,
            child: Text("Você pode adicionar até $maxAssets imagens."),
          ),
        )
      ],
    );
  }

  @override
  Future<AssetEntity?> pushToViewer({
    required XFile file,
    required CameraPickerViewType viewType,
  }) async {
    //TODO tá adicionando a imagem na lista quando eu clico no preview 
    final File imageFile = File(file.path);
    setState(() {
      if (!images.contains(imageFile) && images.length < maxAssets) {
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

  @override
  Widget buildCaptureButton(BuildContext context, BoxConstraints constraints) {
    final isDisabled = images.length >= maxAssets;

    return IgnorePointer(
      ignoring: isDisabled,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0, // Visually indicate disabled state
        child: super.buildCaptureButton(context, constraints),
      ),
    );
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
