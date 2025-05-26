import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/components/histocr_title.dart';
import 'package:histocr_app/components/loading_indicator.dart';
import 'package:histocr_app/main.dart';
import 'package:histocr_app/providers/auth_provider.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    if (supabase.auth.currentUser != null) {
      // If the user is already logged in, redirect to the home screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final navigator = Navigator.of(context);

        navigator.pushReplacementNamed(Routes.completeProfile);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Handles the login logic
    void handleLogin(AuthProvider provider) {
      provider.login().then((_) {
        if (provider.success) {
          if (provider.hasJob) {
            navigator.pushReplacementNamed(Routes.home);
          } else {
            navigator.pushReplacementNamed(Routes.completeProfile);
          }
        } else {
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Erro ao fazer login.'),
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
              // App Title
              const HistocrTitle(),
              const SizedBox(height: 16),

              // Login Button
              Consumer<AuthProvider>(
                builder: (BuildContext context, AuthProvider provider,
                    Widget? child) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => handleLogin(provider),
                      icon: Visibility(
                        visible: !provider.loading,
                        child: const ImageIcon(
                          size: 16,
                          AssetImage("assets/google-logo.png"),
                        ),
                      ),
                      label: provider.loading
                          ? const LoadingIndicator()
                          : Text(
                              'Login com Google',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
