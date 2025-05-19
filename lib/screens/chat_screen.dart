import 'dart:io';

import 'package:flutter/material.dart';
import 'package:histocr_app/components/assets_picker/custom_asset_picker_builder.dart';
import 'package:histocr_app/components/camera_picker/custom_camera_picker_state.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';
import 'package:histocr_app/components/chat/predefined_messages_widgets.dart';
import 'package:histocr_app/components/chat/send_picture_button.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/models/chat_message.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/portuguese_text_delegates.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  void _pickImagesFromGallery(BuildContext context) async {
    final provider = Provider.of<ChatProvider>(context, listen: false);
    final images = <File>[];

    final result = await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: CustomAssetPickerBuilderDelegate(
        textDelegate: PortugueseAssetPickerTextDelegate(),
        themeColor: secondaryColor,
        pathNameBuilder: (AssetPathEntity path) => switch (path) {
          final p when p.isAll => 'Recentes',
          _ => path.name,
        },
        provider: DefaultAssetPickerProvider(),
        initialPermission: PermissionState.authorized,
      ),
    );

    if (result != null) {
      for (final asset in result) {
        final file = await asset.file;
        if (file != null) {
          images.add(file);
        }
      }
    }
    provider.addUserMessages(images);
  }

  void _pickImagesFromCamera(BuildContext context) async {
    await CameraPicker.pickFromCamera(
      context,
      createPickerState: () => CustomCameraPickerState(images: []),
      pickerConfig: CameraPickerConfig(
        textDelegate: PortugueseCameraPickerTextDelegate(),
      ),
    );
  }

  Widget _buildMessageContent(ChatMessage message, BuildContext context) {
    return message.type != null
        ? _buildPredefinedMessageCont(message, context)
        : _buildUserMessageContent(message);
  }

  Widget _buildUserMessageContent(ChatMessage message) {
    return message.image == null
        ? Text(message.textContent ?? '')
        : Image.file(message.image!);
  }

  Widget _buildPredefinedMessageCont(
      ChatMessage message, BuildContext context) {
    final type = message.type!;
    final provider = Provider.of<ChatProvider>(context);
    return switch (type) {
      PredefinedMessageType.rating => RatingMessage(
          rating: provider.document?.rating ?? 0,
          onRatingChanged: (newRating) => provider.updateRating(newRating),
        ),
      PredefinedMessageType.correction => CorrectionMessage(
          document: provider.document!,
        ),
      PredefinedMessageType.editName =>
        EditNameMessage(name: provider.document?.name ?? ''),
      PredefinedMessageType.firstMessage => Text(type.text),
      PredefinedMessageType.transcription => TranscriptionMessage(
          transcription: provider.document?.originalText ?? '',
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          final provider = Provider.of<ChatProvider>(context, listen: false);
          provider.clearMessages();
        }
      },
      child: ScaffoldWithReturnButton(
        child: Consumer<ChatProvider>(
          builder: (context, provider, child) => Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                  child: ListView.builder(
                    itemCount: provider.messages.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      final message = provider.messages[index];
                      return ChatBubble(
                        isUserMessage: message.isUserMessage,
                        child: _buildMessageContent(message, context),
                      );
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
                      onPressed: () => _pickImagesFromCamera(context),
                    ),
                    const SizedBox(height: 4),
                    SendPictureButton(
                      //TODO ver ngc da tela em chines dps q autoriza
                      label: 'Escolher da galeria',
                      icon: Icons.photo_library_rounded,
                      onPressed: () => _pickImagesFromGallery(context),
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
}
