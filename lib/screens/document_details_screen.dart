import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/edit_name_dialog.dart';
import 'package:histocr_app/components/network_image_with_fallback.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/components/screen_width_button.dart';
import 'package:histocr_app/components/star_review.dart';
import 'package:histocr_app/models/document.dart';
import 'package:histocr_app/providers/documents_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/image_helper.dart';
import 'package:provider/provider.dart';

class DocumentDetailScrreen extends StatefulWidget {
  const DocumentDetailScrreen({super.key});

  @override
  State<DocumentDetailScrreen> createState() => _DocumentDetailScrreenState();
}

class _DocumentDetailScrreenState extends State<DocumentDetailScrreen> {
  
  void _updateDocumentName(
      {required String name, required Document document}) async {
    try {
      await Provider.of<DocumentsProvider>(context, listen: false)
          .updateDocumentName(name: name, document: document);
      document.name = name;
      setState(() {});
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao atualizar o nome do documento'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Document document =
        ModalRoute.of(context)!.settings.arguments as Document;
    return ScaffoldWithReturnButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    document.name,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditNameDialog(
                          name: document.name,
                          onNameChanged: (newName) {
                            _updateDocumentName(
                              name: newName,
                              document: document,
                            );
                          }),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_rounded,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            StarReview(size: 36, rating: document.rating ?? 0),
            const SizedBox(height: 16),
            ImageCarousel(
              uploadedFilePaths: document.uploadedFilePaths,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  child: Text(document.transcription),
                ),
              ),
            ),
            ScreenWidthButton(
              label: "Copiar texto",
              onPressed: () => Clipboard.setData(
                ClipboardData(text: document.transcription),
              ),
            ),
            // const SizedBox(height: 4),
            // ScreenWidthButton(
            //   label: "Compartilhar",
            //   onPressed: () {},
            // ),
          ],
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  final List<String> uploadedFilePaths;

  const ImageCarousel({super.key, required this.uploadedFilePaths});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final CarouselController controller;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    controller = CarouselController();

    // Add a listener to update _currentIndex when the scroll position changes
    controller.addListener(_updateCurrentIndex);
  }

  void _updateCurrentIndex() {
    // Ensure the controller has a position attached (meaning the CarouselView is built)
    if (controller.hasClients && controller.position.hasContentDimensions) {
      final position = controller.position;
      final width = MediaQuery.sizeOf(context).width - 32; //your width
      if (position.hasPixels) {
        final index = (position.pixels / width).round();
        setState(() {
          currentIndex = index;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.removeListener(_updateCurrentIndex);
    controller.dispose();
    super.dispose();
  }

  Widget _buildFullScreenImageCarousel(
    int initialIndex,
  ) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 20) {
          Navigator.of(context).pop();
        }
      },
      child: CarouselView(
        backgroundColor: Colors.transparent,
        itemExtent: double.infinity,
        itemSnapping: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
        ),
        controller: controller,
        children: widget.uploadedFilePaths
            .map((path) => NetworkImageWithFallback(
                  path: getImageUrl(path),
                  fit: BoxFit.fitWidth,
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: CarouselView(
              itemExtent: double.infinity,
              itemSnapping: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              controller: controller,
              onTap: (index) {
                showDialog(
                    context: context,
                    builder: (ctx) => _buildFullScreenImageCarousel(index));
              },
              children: widget.uploadedFilePaths.map((path) {
                return NetworkImageWithFallback(
                  path: getImageUrl(path),
                );
              }).toList()),
        ),
        const SizedBox(height: 8),
        Visibility(
          visible: widget.uploadedFilePaths.length > 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.uploadedFilePaths.length,
              (index) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex == index
                      ? primaryColor
                      : primaryColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
