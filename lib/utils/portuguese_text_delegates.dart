import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PortugueseAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get preview => 'Visualizar';

  @override
  String get select => 'Selecionar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get edit => 'Editar';

  @override
  String get original => 'Original';

  @override
  String get goToSystemSettings => 'Ir para as configurações do sistema';

  @override
  String get viewingLimitedAssetsTip =>
      'O aplicativo só pode acessar alguns álbuns da sua galeria.';

  @override
  String get changeAccessibleLimitedAssets =>
      'Toque para definir quais itens podem ser acessados';

  @override
  String get accessAllTip => 'Você definiu que o aplicativo só pode acessar parte das imagens do dispositivo, '
      'recomendamos permitir o acesso a "todos os recursos".';

  @override
  String get accessLimitedAssets => 'Continuar acessando apenas algumas imagens';

  @override
  String get unableToAccessAll => 'Não é possível acessar todos as imagens';
}

class PortugueseCameraPickerTextDelegate extends CameraPickerTextDelegate {
  @override
  String get confirm => 'Confirmar';

  @override
  String get shootingTips => '';

  @override
  String get loadFailed => 'Erro ao carregar';

  @override
  String get loading => 'Carregando...';

  @override
  String get saving => 'Salvando...';
}
