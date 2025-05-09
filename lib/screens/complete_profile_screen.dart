import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/components/occupation_dropdown.dart';
import 'package:histocr_app/components/screen_width_button.dart';
import 'package:histocr_app/main.dart';
import 'package:histocr_app/utils/routes.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

//TODO ver ngc do teclado quando passa pra outra página dar render overflow
class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController otherOccupationController =
      TextEditingController();
  String? selectedOccupation;
  bool loading = false;

  Future<bool> _updateOccupation() async {
    bool success = true;
    final String? occupation = (selectedOccupation == "Outro" &&
            otherOccupationController.text.isNotEmpty)
        ? otherOccupationController.text.trim()
        : selectedOccupation;

    setState(() {
      loading = true;
    });

    try {
      await supabase.from('users').update({
        'job': occupation,
      }).eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      success = false;
    } finally {
      setState(() {
        loading = false;
      });
    }
    return success;
  }

  @override
  void dispose() {
    super.dispose();
    otherOccupationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    void handleUpdate() {
      if (selectedOccupation == null) {
        navigator.pushReplacementNamed(Routes.home);
        return;
      }

      _updateOccupation().then((success) {
        if (success) {
          navigator.pushReplacementNamed(Routes.home);
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Erro ao atualizar ocupação.'),
            ),
          );
        }
      });
    }

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
                    TextField(
                      decoration: const InputDecoration(
                        hintText: "Escreva sua profissão",
                      ),
                      controller: otherOccupationController,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ScreenWidthButton(
                label: 'Continuar para o aplicativo',
                onPressed: () => handleUpdate(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
