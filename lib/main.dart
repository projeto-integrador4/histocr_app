import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/screens/home_screen.dart';
import 'package:histocr_app/screens/login_screen.dart';
import 'package:histocr_app/theme/theme.dart';
import 'package:histocr_app/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HistOCR',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: colorSchemeLight,
        useMaterial3: true,
      ),
      routes: {
         Routes.home: (context) => const HomeScreen(),
         Routes.login: (context) => const LoginScreen(),
      },
      initialRoute: Routes.login,
    );
  }
}
