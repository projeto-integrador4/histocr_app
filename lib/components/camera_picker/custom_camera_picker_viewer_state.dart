import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:histocr_app/components/camera_picker/miniature_widgets.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CustomCameraPickerViewerState extends CameraPickerViewerState {
  final List<File> images;
  int currentIndex;

  CustomCameraPickerViewerState({required this.images, this.currentIndex = 0});

  @override
  Widget buildPreview(BuildContext context) {
    if (images.isEmpty) {
      return const SizedBox.shrink();
    }

    return PageView.builder(
      controller: PageController(initialPage: currentIndex),
      onPageChanged: (index) {
        setState(() {
          currentIndex = index; // Update the current index when the user swipes
        });
      },
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Image.file(
          images[index],
          fit: BoxFit.contain, // Adjust the image to fit within the preview
        );
      },
    );
  }

  Widget buildMiniaturePreview(File image, int index) {
    return MiniaturePreview(
      image: image,
      selectImage: () {
        setState(() {
          currentIndex = index;
        });
      },
      removeImage: () {
        setState(() {
          currentIndex -= 1;
          images.remove(image);
        });
      },
    );
  }

  @override
  Widget buildConfirmButton(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: createAssetEntityAndPop,
      child: const Text(
        "Confirmar",
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Future<void> createAssetEntityAndPop() async {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    provider.addUserMessages(images);
    super.createAssetEntityAndPop();
  }

  @override
  Widget buildBackButton(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildForeground(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 12.0,
          end: 12.0,
          bottom: 12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Semantics(
              sortKey: const OrdinalSortKey(0),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: buildBackButton(context),
              ),
            ),
            Semantics(
              sortKey: const OrdinalSortKey(2),
              child: Align(
                alignment: AlignmentDirectional.bottomCenter,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MiniaturePreviewList(
                        itemCount: images.length,
                        itemBuilder: (context, index) =>
                            buildMiniaturePreview(images[index], index),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildBackToCameraButton(context),
                        buildConfirmButton(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackToCameraButton(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: secondaryColor.withOpacity(0.1),
        foregroundColor: white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color: secondaryColor,
            width: 2,
          ),
        ),
      ),
      onPressed: () {
        if (isSavingEntity) {
          return;
        }
        Navigator.of(context).pop();
      },
      child: const Text('Voltar para a câmera'),
    );
  }
}
