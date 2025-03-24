import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:histocr_app/utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      if (mounted) {
        Navigator.of(context).pushNamed(Routes.home);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer login: $error'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'HistOCR',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                ),
              ),
              // const SizedBox(height: 16),
              // const TextField(
              //   decoration: InputDecoration(
              //     labelText: 'Username',
              //   ),
              // ),
              // const SizedBox(height: 8),
              // const TextField(
              //   obscureText: true,
              //   decoration: InputDecoration(
              //     labelText: 'Password',
              //   ),
              // ),
              // const SizedBox(height: 16),
              // SizedBox(
              //   width: double.infinity,
              //   child: FilledButton(
              //     onPressed: () {},
              //     child: const Text(
              //       'Login',
              //       style: TextStyle(fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _handleSignIn(),
                  icon: const ImageIcon(
                    size: 16,
                    AssetImage("assets/google-logo.png"),
                  ),
                  label: const Text(
                    'Login com Google',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
