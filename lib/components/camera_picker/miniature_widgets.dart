import 'dart:io';

import 'package:flutter/material.dart';

class MiniaturePreview extends StatelessWidget {
  final void Function()? selectImage;
  final void Function()? removeImage;
  final File image;
  const MiniaturePreview(
      {super.key, this.selectImage, this.removeImage, required this.image});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      width: 84,
      child: Stack(
        children: [
          GestureDetector(
            onTap: selectImage,
            child: Container(
              height: 84,
              width: 84,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: removeImage,
              child: const Padding(
                padding: EdgeInsets.only(top: 4.0, right: 4.0),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiniaturePreviewList extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const MiniaturePreviewList(
      {super.key, required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8), // Add space between items
      ),
    );
  }
}
