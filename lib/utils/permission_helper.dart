import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<PermissionState> permissionCheck({
  PermissionRequestOption requestOption = const PermissionRequestOption(),
}) async {
  final PermissionState ps =
      await PhotoManager.getPermissionState(requestOption: requestOption);

  return ps;
}
