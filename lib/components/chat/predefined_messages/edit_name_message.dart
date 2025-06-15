import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/chat/chat_bubble.dart';
import 'package:histocr_app/components/edit_name_dialog.dart';
import 'package:histocr_app/utils/predefined_messages_type.dart';

class EditNameMessage extends StatelessWidget {
  final String name;
  final Function(String)? onNameChanged;

  const EditNameMessage({
    super.key,
    required this.name,
    this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      child: Column(
        children: [
          Text(PredefinedMessageType.editName.text),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => EditNameDialog(
                      name: name,
                      onNameChanged: (newName) {
                        onNameChanged?.call(newName);
                      }),
                ),
                icon: const Icon(Icons.edit_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
