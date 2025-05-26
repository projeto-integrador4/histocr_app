import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class PortugueseAssetPickerTextDelegate extends AssetPickerTextDelegate {
  @override
  String get languageCode => 'pt';

  @override
  String? get scriptCode => null;

  @override
  String? get countryCode => null;

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
  String get accessAllTip =>
      'Você definiu que o aplicativo só pode acessar parte das imagens do dispositivo, '
      'recomendamos permitir o acesso a "todos os recursos".';

  @override
  String get accessLimitedAssets =>
      'Continuar acessando apenas algumas imagens';

  @override
  String get unableToAccessAll => 'Não é possível acessar todas as imagens';

  @override
  String get emptyList => 'Lista vazia';

  @override
  String get unSupportedAssetType => 'Tipo de recurso não suportado';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get livePhotoIndicator => 'Live';

  @override
  String get loadFailed => 'Falha ao carregar';

  @override
  String get accessiblePathName => 'Recursos acessíveis';

  @override
  String get sTypeAudioLabel => 'Áudio';

  @override
  String get sTypeImageLabel => 'Imagem';

  @override
  String get sTypeVideoLabel => 'Vídeo';

  @override
  String get sTypeOtherLabel => 'Outro recurso';

  @override
  String semanticTypeLabel(AssetType type) {
    return switch (type) {
      AssetType.audio => sTypeAudioLabel,
      AssetType.image => sTypeImageLabel,
      AssetType.video => sTypeVideoLabel,
      AssetType.other => sTypeOtherLabel,
    };
  }

  @override
  String get sActionPlayHint => 'Reproduzir';

  @override
  String get sActionPreviewHint => 'Visualizar';

  @override
  String get sActionSelectHint => 'Selecionar';

  @override
  String get sActionSwitchPathLabel => 'Trocar caminho';

  @override
  String get sActionUseCameraHint => 'Usar câmera';

  @override
  String get sNameDurationLabel => 'Duração';

  @override
  String get sUnitAssetCountLabel => 'Quantidade';

  @override
  AssetPickerTextDelegate get semanticsTextDelegate => this;

  @override
  String durationIndicatorBuilder(Duration duration) {
    const String separator = ':';
    final String minute = duration.inMinutes.toString().padLeft(2, '0');
    final String second = (duration - Duration(minutes: duration.inMinutes))
        .inSeconds
        .toString()
        .padLeft(2, '0');
    return '$minute$separator$second';
  }
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
