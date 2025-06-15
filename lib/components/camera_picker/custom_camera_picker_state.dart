import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/camera_picker/miniature_widgets.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
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
          alignment: Alignment.bottomRight,
          child: GestureDetector(
            onTap: () {
              _submitSelectedImages(context);
            },
            child: _sendImagesButton(),
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

  void _submitSelectedImages(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    provider.getTranscription(images);
    Navigator.pop(context);
  }

  Widget _sendImagesButton() {
    return Visibility(
      visible: images.isNotEmpty,
      child: Container(
        height: 48,
        width: 48,
        margin: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.check_rounded,
              size: 24,
            ),
            Positioned(
              top: 24,
              left: images.length == 10 ? 26 : 30,
              child: Text(
                '${images.length}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  textStyle: GoogleFonts.inter(
                      fontWeight: FontWeight.w600, color: white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<AssetEntity?> pushToViewer({
    required XFile file,
    required CameraPickerViewType viewType,
  }) async {
    final File imageFile = File(file.path);
    setState(() {
      if (!images.contains(imageFile) && images.length < maxAssets) {
        images.add(imageFile);
      }
    });

    // final result = await CameraPickerViewer.pushToViewer(
    //   context,
    //   pickerConfig: pickerConfig,
    //   viewType: viewType,
    //   previewXFile: file,
    //   createViewerState: () => CustomCameraPickerViewerState(
    //     images: images,
    //     currentIndex: images.indexOf(imageFile),
    //   ),
    // );
    return null;
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
      removeImage: () {
        setState(() {
          images.remove(image);
        });
      },
    );
  }
}
