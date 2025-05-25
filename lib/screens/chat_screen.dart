import 'dart:io';

import 'package:flutter/material.dart';
import 'package:histocr_app/components/assets_picker/custom_asset_picker_builder.dart';
import 'package:histocr_app/components/camera_picker/custom_camera_picker_state.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';
import 'package:histocr_app/components/chat/predefined_messages_widgets.dart';
import 'package:histocr_app/components/chat/send_picture_button.dart';
import 'package:histocr_app/components/chat/typing_indicator_message.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/permission_helper.dart' as permission_helper;
import 'package:histocr_app/utils/portuguese_text_delegates.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final permission = await permission_helper.checkPermission();
      if (permission == PermissionState.authorized) {
        _pickImagesFromGallery();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          final provider = Provider.of<ChatProvider>(context, listen: false);
          provider.clear();
        }
      },
      child: ScaffoldWithReturnButton(
        popResult: Provider.of<ChatProvider>(context).didAddDocument,
        child: Consumer<ChatProvider>(
          builder: (context, provider, child) => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  child: ListView.builder(
                    //TODO animatedList
                    itemCount: provider.messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final message = provider.messages[index];
                      return _buildMessage(message, context);
                    },
                  ),
                ),
              ),
              Container(
                color: primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    SendPictureButton(
                      label: 'Tirar foto',
                      icon: Icons.camera_alt_rounded,
                      onPressed: () => _pickImagesFromCamera(),
                    ),
                    const SizedBox(height: 4),
                    SendPictureButton(
                      label: 'Escolher da galeria',
                      icon: Icons.photo_library_rounded,
                      onPressed: () => _handleOpenGallery(provider),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOpenGallery(ChatProvider provider) async {
    final permission = await permission_helper.checkPermission();
    if (permission == PermissionState.denied) {
      await provider.addPermissionTip();
      await permission_helper.requestPermission();

      // Check again after requesting
      final newPermission = await permission_helper.checkPermission();
      if (newPermission == PermissionState.denied) {
        // Still denied, show dialog to open settings
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => _buildSystemSettingsDialog(),
        );
      }
    } else {
      _pickImagesFromGallery();
    }
  }

  void _pickImagesFromGallery() async {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    final images = <File>[];

    List<AssetEntity>? result = await _openAssetPicker();

    if (!mounted) return; // Guard context usage

    if (result != null) {
      for (final asset in result) {
        final file = await asset.file;
        if (file != null) {
          images.add(file);
        }
      }
    }
    provider.getTranscription(images);
  }

  Future<List<AssetEntity>?> _openAssetPicker() async {
    try {
      return await AssetPicker.pickAssetsWithDelegate(
        context,
        delegate: CustomAssetPickerBuilderDelegate(
          textDelegate: PortugueseAssetPickerTextDelegate(),
          themeColor: secondaryColor,
          pathNameBuilder: (AssetPathEntity path) => switch (path) {
            final p when p.isAll => 'Recentes',
            _ => path.name,
          },
          provider: DefaultAssetPickerProvider(maxAssets: 10),
          initialPermission: PermissionState.authorized,
        ),
      );
    } on StateError {
      Provider.of<ChatProvider>(context, listen: false).addPermissionTip();
      return null;
    }
  }

  void _pickImagesFromCamera() async {
    await CameraPicker.pickFromCamera(
      context,
      createPickerState: () => CustomCameraPickerState(maxAssets: 10),
      pickerConfig: CameraPickerConfig(
        textDelegate: PortugueseCameraPickerTextDelegate(),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message, BuildContext context) {
    return message.type != null
        ? _buildPredefinedMessage(message, context)
        : _buildUserMessage(message);
  }

  Widget _buildUserMessage(ChatMessage message) {
    return ChatBubble(
      isUserMessage: message.isUserMessage,
      child: message.image == null
          ? Text(message.textContent ?? '')
          : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(message.image!),
            ),
    );
  }

  Widget _buildPredefinedMessage(ChatMessage message, BuildContext context) {
    final type = message.type!;
    final provider = Provider.of<ChatProvider>(context);
    return switch (type) {
      PredefinedMessageType.rating => RatingMessage(
          rating: provider.document?.rating ?? 0,
          onRatingChanged: (newRating) => provider.updateRating(newRating),
        ),
      PredefinedMessageType.correction => CorrectionMessage(
          document: provider.document!,
          onCorrectionSaved: (newCorrection) =>
              provider.sendCorrection(newCorrection),
        ),
      PredefinedMessageType.editName => EditNameMessage(
          name: provider.document?.name ?? '',
          onNameChanged: (newName) => provider.updateDocumentName(newName),
        ),
      PredefinedMessageType.transcription => TranscriptionMessage(
          transcription: provider.document?.transcription ?? '',
        ),
      PredefinedMessageType.typing => const TypingIndicatorMessage(),
      _ => ChatBubble(child: Text(type.text)),
    };
  }

  Widget _buildSystemSettingsDialog() {
    return AlertDialog(
      title: const Text('Permissão necessária'),
      content: const Text(
        'Você precisa permitir o acesso às fotos nas configurações do sistema.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            PhotoManager.openSetting();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Abrir configurações',
            style: TextStyle(
              color: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
