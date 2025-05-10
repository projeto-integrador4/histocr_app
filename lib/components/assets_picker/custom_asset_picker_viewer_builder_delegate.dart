import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CustomAssetPickerViewerBuilderDelegate
    extends DefaultAssetPickerViewerBuilderDelegate {
  CustomAssetPickerViewerBuilderDelegate({
    required super.currentIndex,
    required super.previewAssets,
    required super.themeData,
    super.selectorProvider,
    super.provider,
    super.selectedAssets,
    super.previewThumbnailSize,
    super.specialPickerType,
    super.maxAssets,
    super.shouldReversePreview,
    super.selectPredicate,
    super.shouldAutoplayPreview = false,
  });

  @override
  Widget confirmButton(BuildContext context) {
    return CNP<AssetPickerViewerProvider<AssetEntity>?>.value(
      value: provider,
      child: Consumer<AssetPickerViewerProvider<AssetEntity>?>(
        builder: (_, AssetPickerViewerProvider<AssetEntity>? provider, __) {
          assert(
            isWeChatMoment || provider != null,
            'Viewer provider must not be null '
            'when the special type is not WeChat moment.',
          );
          Future<void> onPressed() async {
            if (isWeChatMoment && hasVideo) {
              Navigator.maybeOf(context)?.pop(<AssetEntity>[currentAsset]);
              return;
            }
            if (provider!.isSelectedNotEmpty) {
              Navigator.maybeOf(context)?.pop(provider.currentlySelectedAssets);
              return;
            }
            if (await onChangingSelected(context, currentAsset, false)) {
              // ignore: use_build_context_synchronously
              Navigator.maybeOf(context)?.pop(
                selectedAssets ?? <AssetEntity>[currentAsset],
              );
            }
          }

          String buildText() {
            if (isWeChatMoment && hasVideo) {
              return textDelegate.confirm;
            }
            if (provider!.isSelectedNotEmpty) {
              return '${textDelegate.confirm}'
                  ' (${provider.currentlySelectedAssets.length}'
                  '/'
                  '${selectorProvider!.maxAssets})';
            }
            return textDelegate.confirm;
          }

          final isButtonEnabled = provider == null ||
              previewAssets.isEmpty ||
              (selectedAssets?.isNotEmpty ?? false);
          return MaterialButton(
            minWidth:
                (isWeChatMoment && hasVideo) || provider!.isSelectedNotEmpty
                    ? 48
                    : 20,
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: secondaryColor,
            disabledColor: secondaryColor.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: isButtonEnabled ? onPressed : null,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              buildText(),
              style: const TextStyle(
                color: textColor,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.fade,
              softWrap: false,
              semanticsLabel: () {
                if (isWeChatMoment && hasVideo) {
                  return semanticsTextDelegate.confirm;
                }
                if (provider!.isSelectedNotEmpty) {
                  return '${semanticsTextDelegate.confirm}'
                      ' (${provider.currentlySelectedAssets.length}'
                      '/'
                      '${selectorProvider!.maxAssets})';
                }
                return semanticsTextDelegate.confirm;
              }(),
            ),
          );
        },
      ),
    );
  }
}
