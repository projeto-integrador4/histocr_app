import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat_bubble.dart';
import 'package:histocr_app/components/scaffold_with_return_button.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/asset_picker_utils/custom_button_asset_picker_builder.dart';
import 'package:histocr_app/utils/asset_picker_utils/portuguese_text_delegate.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  openAssetPicker(BuildContext context) async {
    await AssetPicker.pickAssetsWithDelegate(
      context,
      delegate: CustomButtonAssetPickerBuilderDelegate(
        textDelegate: PortugueseAssetPickerTextDelegate(),
        themeColor: secondaryColor,
        pathNameBuilder: (AssetPathEntity path) => switch (path) {
          final p when p.isAll => 'Recentes',
          // You can apply similar conditions to other common paths.
          _ => path.name,
        },
        provider: DefaultAssetPickerProvider(),
        initialPermission: PermissionState.authorized,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithReturnButton(
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) => Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
                child: ListView.builder(
                  itemCount: chatProvider.messages.length,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    final message = chatProvider.messages[index];
                    return ChatBubble(
                      isSentByUser: message.isUserMessage,
                      child: Text(
                        chatProvider.messages[index].text ?? '',
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SendPictureButton(
                    label: 'Tirar foto',
                    icon: Icons.camera_alt_rounded,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 4),
                  SendPictureButton(
                      label: 'Escolher da galeria',
                      icon: Icons.photo_library_rounded,
                      onPressed: () async {
                        await openAssetPicker(context);
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SendPictureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const SendPictureButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: secondaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}
