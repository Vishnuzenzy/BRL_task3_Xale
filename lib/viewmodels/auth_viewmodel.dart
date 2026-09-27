import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance; 

  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  AuthenticationProvider() {
    _auth.authStateChanges().listen((User? newUser) {
      _user = newUser;
      notifyListeners();
    });
    
    _googleSignIn.initialize();
  }

  // Email/Password Sign Up
  Future<String?> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message ?? "Signup failed";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // Email/Password Sign In
  Future<String?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message ?? "Login failed";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // Google Sign-In 
  Future<String?> signInWithGoogle() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Authenticate identity
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      // 2. Request scopes to get Access Token
      final clientAuth = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);

      // 3. Create Firebase Credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: clientAuth.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      // 4. Sign in to Firebase
      await _auth.signInWithCredential(credential);
      _isLoading = false;
      notifyListeners();
      return null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // GitHub Sign-In
  Future<String?> signInWithGitHub() async {
    try {
      _isLoading = true;
      notifyListeners();

      final GithubAuthProvider githubProvider = GithubAuthProvider();
      // Scopes add kar sakte hain
      githubProvider.addScope('read:user');
      githubProvider.addScope('user:email');

      await _auth.signInWithProvider(githubProvider);

      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message ?? "GitHub Sign-In failed";
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.toString();
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}