import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/theme/app_colors.dart';

class NetworkImageWithFallback extends StatelessWidget {
  final String path;
  final BoxFit? fit;
  final double? scale;
  const NetworkImageWithFallback({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: path,
        placeholder: (context, url) => const Center(child: LoadingIndicator()),
        errorWidget: (context, url, error) => const Center(
          child: Icon(
            Icons.error,
            color: accentColor,
          ),
        ),
        fit: fit,
        scale: scale ?? 1,
      ),
    );
  }
}
