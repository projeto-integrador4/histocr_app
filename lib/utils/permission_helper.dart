import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<void> requestPermission({
  PermissionRequestOption requestOption = const PermissionRequestOption(),
}) async {
  await PhotoManager.requestPermissionExtend(requestOption: requestOption);
}

Future<PermissionState> checkPermission({
  PermissionRequestOption requestOption = const PermissionRequestOption(),
}) async {
  final PermissionState ps =
      await PhotoManager.getPermissionState(requestOption: requestOption);

  return ps;
}
