import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

final button = FilledButton(
  style: FilledButton.styleFrom(
    backgroundColor: secondaryColor,
    disabledBackgroundColor: secondaryColor.withOpacity(0.5),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),
  onPressed: () {},
  child: const Text(
    'Confirmar',
    style: TextStyle(
      fontSize: 17,
    ),
  ),
);

class CustomButtonAssetPickerViewerBuilderDelegate
    extends DefaultAssetPickerViewerBuilderDelegate {
  CustomButtonAssetPickerViewerBuilderDelegate({
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

Future<List<AssetEntity>?> pushToCustomViewer(
  BuildContext context, {
  required List<AssetEntity> previewAssets,
  required ThemeData themeData,
  int currentIndex = 0,
  // Add any other parameters you need
}) {
  return AssetPickerViewer.pushToViewerWithDelegate<AssetEntity,
      AssetPathEntity>(
    context,
    delegate: CustomButtonAssetPickerViewerBuilderDelegate(
      currentIndex: currentIndex,
      previewAssets: previewAssets,
      themeData: themeData,
    ),
  );
}

class CustomButtonAssetPickerBuilderDelegate
    extends DefaultAssetPickerBuilderDelegate {
  CustomButtonAssetPickerBuilderDelegate({
    required super.provider,
    required super.initialPermission,
    super.gridCount,
    super.pickerTheme,
    super.specialItemPosition,
    super.specialItemBuilder,
    super.loadingIndicatorBuilder,
    super.selectPredicate,
    super.shouldRevertGrid,
    super.limitedPermissionOverlayPredicate,
    super.pathNameBuilder,
    super.assetsChangeCallback,
    super.assetsChangeRefreshPredicate,
    super.themeColor,
    super.textDelegate,
    super.locale,
    super.gridThumbnailSize,
    super.previewThumbnailSize,
    super.specialPickerType,
    super.keepScrollOffset,
    super.shouldAutoplayPreview,
    super.dragToSelect,
  });

  @override
  Widget confirmButton(BuildContext context) {
    return button;
  }

  @override
  Future<void> viewAsset(
    BuildContext context,
    int? index,
    AssetEntity currentAsset,
  ) async {
    final p = context.read<DefaultAssetPickerProvider>();
    // - When we reached the maximum select count and the asset is not selected,
    //   do nothing.
    // - When the special type is WeChat Moment, pictures and videos cannot
    //   be selected at the same time. Video select should be banned if any
    //   pictures are selected.
    if ((!p.selectedAssets.contains(currentAsset) && p.selectedMaximumAssets) ||
        (isWeChatMoment &&
            currentAsset.type == AssetType.video &&
            p.selectedAssets.isNotEmpty)) {
      return;
    }
    final revert = effectiveShouldRevertGrid(context);
    // ignore: no_leading_underscores_for_local_identifiers
    final int _debugFlow; // Only for debug process.
    final List<AssetEntity> current;
    final List<AssetEntity>? selected;
    final int effectiveIndex;
    if (isWeChatMoment) {
      if (currentAsset.type == AssetType.video) {
        current = <AssetEntity>[currentAsset];
        selected = null;
        effectiveIndex = 0;
        _debugFlow = 10;
      } else {
        final List<AssetEntity> list;
        if (index == null) {
          list = p.selectedAssets.reversed.toList(growable: false);
        } else {
          list = p.currentAssets;
        }
        current = list.where((e) => e.type == AssetType.image).toList();
        selected = p.selectedAssets;
        final i = current.indexOf(currentAsset);
        effectiveIndex = revert ? current.length - i - 1 : i;
        _debugFlow = switch ((index == null, revert)) {
          (true, true) => 21,
          (true, false) => 20,
          (false, true) => 31,
          (false, false) => 30,
        };
      }
    } else {
      selected = p.selectedAssets;
      final List<AssetEntity> list;
      if (index == null) {
        if (revert) {
          list = p.selectedAssets.reversed.toList(growable: false);
        } else {
          list = p.selectedAssets;
        }
        effectiveIndex = selected.indexOf(currentAsset);
        current = list;
      } else {
        current = p.currentAssets;
        effectiveIndex = revert ? current.length - index - 1 : index;
      }
      _debugFlow = switch ((index == null, revert)) {
        (true, true) => 41,
        (true, false) => 40,
        (false, true) => 51,
        (false, false) => 50,
      };
    }
    if (current.isEmpty) {
      throw StateError('Previewing empty assets is not allowed. $_debugFlow');
    }
    final List<AssetEntity>? result =
        await AssetPickerViewer.pushToViewerWithDelegate(
      context,
      delegate: CustomButtonAssetPickerViewerBuilderDelegate(
        currentIndex: effectiveIndex,
        previewAssets: current,
        themeData: theme,
        previewThumbnailSize: previewThumbnailSize,
        selectPredicate: selectPredicate,
        selectedAssets: selected,
        selectorProvider: p,
        specialPickerType: specialPickerType,
        maxAssets: p.maxAssets,
        shouldReversePreview: revert,
        shouldAutoplayPreview: shouldAutoplayPreview,
        provider: selected != null
            ? AssetPickerViewerProvider<AssetEntity>(
                selected,
                maxAssets: p.maxAssets,
              )
            : null,
      ),
    );
    if (result != null) {
      // ignore: use_build_context_synchronously
      Navigator.maybeOf(context)?.maybePop(result);
    }
  }
}
