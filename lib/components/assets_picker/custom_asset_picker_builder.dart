import 'package:flutter/material.dart';
import 'package:histocr_app/components/assets_picker/custom_asset_picker_viewer_builder_delegate.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CustomAssetPickerBuilderDelegate
    extends DefaultAssetPickerBuilderDelegate {
  CustomAssetPickerBuilderDelegate({
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
    return Consumer<DefaultAssetPickerProvider>(
      builder: (_, DefaultAssetPickerProvider p, __) {
        final bool isSelectedNotEmpty = p.isSelectedNotEmpty;
        final bool shouldAllowConfirm =
            isSelectedNotEmpty || p.previousSelectedAssets.isNotEmpty;
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: secondaryColor,
            disabledBackgroundColor: secondaryColor.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          onPressed: shouldAllowConfirm
              ? () {
                  Navigator.maybeOf(context)?.maybePop(p.selectedAssets);
                }
              : null,
          child: const Text(
            'Confirmar',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        );
      },
    );
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
      delegate: CustomAssetPickerViewerBuilderDelegate(
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
