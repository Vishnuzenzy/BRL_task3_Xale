import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/legacy.dart'; // Riverpod 3.x ke liye

final authProvider = ChangeNotifierProvider<AuthenticationProvider>((ref) {
  return AuthenticationProvider();
});

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  bool _isLoading = false;
  bool _googleInitialized = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AuthenticationProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  // v7 me initialize() ek baar call karna zaroori hai
  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await _googleSignIn.initialize();
    // Android pe idToken null aaye to:
    // await _googleSignIn.initialize(serverClientId: 'TERA_WEB_CLIENT_ID');
    _googleInitialized = true;
  }

  // 1. Google Sign-In (v7)
  Future<String?> signInWithGoogle({bool isLoginScreen = true}) async {
    try {
      _setLoading(true);
      await _ensureGoogleInitialized();

      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      if (isLoginScreen &&
          (userCredential.additionalUserInfo?.isNewUser ?? false)) {
        await userCredential.user?.delete();
        await _googleSignIn.signOut();
        return "Yeh Gmail account registered nahi hai. Kripya pehle Sign Up karein.";
      }

      return null;
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) return null; // user ne cancel kiya
      return e.description ?? 'Google sign-in failed';
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // 2. Email/Password Sign Up
  Future<String?> signUp({required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 3. Email/Password Sign In
  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 4. GitHub Sign In
  Future<String?> signInWithGitHub() async {
    try {
      final githubProvider = GithubAuthProvider();
      await _auth.signInWithProvider(githubProvider);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // 5. Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}