import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:histocr_app/providers/auth_provider.dart';
import 'package:histocr_app/providers/chat_provider.dart';
import 'package:histocr_app/screens/account_settings_screen.dart';
import 'package:histocr_app/screens/chat_screen.dart';
import 'package:histocr_app/screens/complete_profile_screen.dart';
import 'package:histocr_app/screens/document_details_screen.dart';
import 'package:histocr_app/screens/history_screen.dart';
import 'package:histocr_app/screens/home_screen.dart';
import 'package:histocr_app/screens/login_screen.dart';
import 'package:histocr_app/theme/theme.dart';
import 'package:histocr_app/utils/routes.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final supabase = Supabase.instance.client;
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      title: 'HistOCR',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: colorSchemeLight,
        inputDecorationTheme: textInputDecoration,
        useMaterial3: true,
      ),
      locale: const Locale('pt', 'BR'),
      routes: {
        Routes.home: (context) => const HomeScreen(),
        Routes.login: (context) => const LoginScreen(),
        Routes.completeProfile: (context) => const CompleteProfileScreen(),
        Routes.chat: (context) => const ChatScreen(),
        Routes.history: (context) => const HistoryScreen(),
        Routes.documentDetail: (context) => const DocumentDetailScrreen(),
        Routes.accountSettings: (context) => const AccountSettingsScreen(),
      },
      initialRoute:
          supabase.auth.currentSession == null ? Routes.login : Routes.home,
    );
  }
}
