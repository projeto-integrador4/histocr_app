import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/providers/auth_provider.dart';
import 'package:histocr_app/theme/app_colors.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const HistocrTitle(),
              const SizedBox(height: 16),
              Consumer<AuthProvider>(
                builder: (BuildContext context, AuthProvider provider,
                        Widget? child) =>
                    SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => provider.login().then((_) {
                      if (provider.success) {
                        navigator.pushNamed(Routes.completeProfile);
                      } else {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao fazer login.'),
                          ),
                        );
                      }
                    }),
                    icon: Visibility(
                      visible: !provider.loading,
                      child: const ImageIcon(
                        size: 16,
                        AssetImage("assets/google-logo.png"),
                      ),
                    ),
                    label: provider.loading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: textColor,
                            ),
                          )
                        : Text(
                            'Login com Google',
                            style:
                                GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
