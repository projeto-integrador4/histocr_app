import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/components/occupation_dropdown.dart';
import 'package:histocr_app/components/screen_width_button.dart';
import 'package:histocr_app/utils/routes.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String? selectedOccupation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const HistocrTitle(),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nos conte um pouco mais sobre você:',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OccupationDropdown(
                    onChanged: (value) => setState(() {
                      selectedOccupation = value;
                    }),
                  ),
                  const SizedBox(height: 8),
                  if (selectedOccupation == "Outro")
                    const TextField(
                      decoration:
                          InputDecoration(hintText: "Escreva sua profissão"),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ScreenWidthButton(
                label: 'Continuar para o aplicativo',
                onPressed: () => Navigator.of(context).pushNamed(Routes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
