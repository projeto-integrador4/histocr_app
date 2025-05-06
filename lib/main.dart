import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/providers/auth_provider.dart';
import 'package:histocr_app/screens/complete_profile_screen.dart';
import 'package:histocr_app/screens/home_screen.dart';
import 'package:histocr_app/screens/login_screen.dart';
import 'package:histocr_app/theme/theme.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await dotenv.load();
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;

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
        inputDecorationTheme: textInputDecoration,
        useMaterial3: true,
      ),
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.completeProfile: (context) => const CompleteProfileScreen(),
      },
      initialRoute: Routes.login,
    );
  }
}
