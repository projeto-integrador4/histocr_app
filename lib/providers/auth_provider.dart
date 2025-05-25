import 'package:google_sign_in/google_sign_in.dart';
import 'package:histocr_app/main.dart';
import 'package:histocr_app/models/occupation.dart';
import 'package:histocr_app/models/user_info.dart';
import 'package:histocr_app/providers/base_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends BaseProvider {
  bool hasJob = false;
  UserInfo? userInfo;
  Occupation? userOccupation;

  Future<void> login() async {
    setLoading(true);
    try {
      await _nativeGoogleSignIn();
      await fetchUserInfo();
      _checkIfUserHasJob();
      success = true;
    } catch (e) {
      success = false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> logout() async {
    setLoading(true);
    try {
      await supabase.auth.signOut();
      userInfo = null;
      hasJob = false;
      success = true;
    } catch (e) {
      success = false;
    } finally {
      setLoading(false);
    }
    return success;
  }

  Future<void> fetchUserInfo() async {
    if (userInfo != null) {
      return;
    }
    setLoading(true);
    try {
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser == null) {
        throw Exception('User not logged in');
      }
      final response = await supabase
          .from('users')
          .select('*, jobs(id, name)')
          .eq('id', supabaseUser.id)
          .limit(1)
          .single();
      userInfo = UserInfo.fromJson(response);
    } catch (e) {
      success = false;
    } finally {
      setLoading(false);
    }
  }

  Future<List<Occupation>> fetchOccupations() async {
    setLoading(true);
    try {
      final response =
          await supabase.from('jobs').select().order('name', ascending: true);

      if (response.isEmpty) {
        return [];
      }

      return List<Occupation>.from(
          response.map((job) => Occupation.fromJson(job)));
    } catch (e) {
      success = false;
      return [];
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

  void _checkIfUserHasJob() {
    hasJob = userInfo?.job != null;
  }

  Future<bool> updateJob(Occupation occupation,
      {String? otherOccupation}) async {
    setLoading(true);
    try {
      success = true;
      final updateData = <String, dynamic>{
        'job_id': occupation.id,
      };

      if (occupation.name == "Outro" && otherOccupation != null) {
        updateData['custom_job_name'] = otherOccupation;
      }

      await supabase
          .from('users')
          .update(updateData)
          .eq('id', supabase.auth.currentUser!.id);
    } catch (e) {
      success = false;
    } finally {
      setLoading(false);
    }
    return success;
  }
}
