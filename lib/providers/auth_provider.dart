import 'package:google_sign_in/google_sign_in.dart';
import 'package:histocr_app/main.dart';
import 'package:histocr_app/providers/base_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends BaseProvider {
  Future<void> login() async {
    setLoading(true);

    try {
      await _nativeGoogleSignIn();
      success = true;
    } catch (e) {
      success = false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> _nativeGoogleSignIn() async {
    const webClientId =
        '575779790837-q5c8h9l5jp501j4q54tgi1rujvqcgb3n.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }
}
