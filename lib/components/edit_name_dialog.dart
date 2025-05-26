import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/theme/app_colors.dart';

class EditNameDialog extends StatelessWidget {
  final String name;
  final Function(String)? onNameChanged;
  const EditNameDialog({super.key, required this.name, this.onNameChanged});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: name);
    final ValueNotifier<bool> isNotEmpty =
        ValueNotifier(nameController.text.isNotEmpty);

    nameController.addListener(() {
      isNotEmpty.value = nameController.text.isNotEmpty;
    });

    return AlertDialog(
      title: Text(
        'Editar nome',
        style: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      content: TextField(
        controller: nameController,
        decoration: const InputDecoration(
          labelText: "Nome",
        ),
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: isNotEmpty,
          builder: (context, value, child) => FilledButton(
            onPressed: value
                ? () => _handleSaveName(nameController.text, context)
                : null,
            style: FilledButton.styleFrom(backgroundColor: secondaryColor),
            child: Text(
              "Salvar",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  void _handleSaveName(String newName, BuildContext context) {
    onNameChanged?.call(newName);
    Navigator.pop(context);
  }
}
