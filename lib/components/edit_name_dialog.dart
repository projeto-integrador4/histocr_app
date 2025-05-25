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
        FilledButton(
          onPressed: () {
            onNameChanged?.call(nameController.text);
            Navigator.pop(context);
          },
          style: FilledButton.styleFrom(backgroundColor: secondaryColor),
          child: Text(
            "Salvar",
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
