import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static Future<FirebaseUser> get user async => await _auth.currentUser();

  static Future<String> login(String email, String pass)  async {
    final authResult= await _auth.signInWithEmailAndPassword(email: email, password: pass);
    return authResult.user.uid;
  }

  static Future<String> register(String email, String pass)  async {
    final authResult= await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    return authResult.user.uid;
  }

  static Future<bool> isEmailVerified() async {
    final user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  static Future sendVerificationEmail() async {
    final user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  static Future<void> logout() async {
    return _auth.signOut();
  }
}