import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slumber/features/auth/data/models/slumber_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🟢 Sign Up With Email + Password
  Future<User?> signUp(String email, String password, String name, {int age = 0}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final slumberUser = SlumberUser(
          id: user.uid,
          email: email,
          name: name,
          age: age,
          sleepGoalHours: 8,
        );

        await _db.collection("users").doc(user.uid).set(slumberUser.toMap());
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Firebase SignUp Error: ${e.code}");
    }
  }

  /// 🟢 Sign In With Email + Password
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception("Firebase SignIn Error: ${e.code}");
    }
  }

  /// 🟢 Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception("Reset Password Error: ${e.code}");
    }
  }

  /// 🟢 Sign Out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut(); // Optional: signOut from Google too
    } catch (e) {
      throw Exception("Sign Out Error: $e");
    }
  }

  /// 🟢 Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) return null; // المستخدم لغى تسجيل الدخول

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Auth credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // First time login → add user to Firestore
      if (user != null) {
        final doc = await _db.collection("users").doc(user.uid).get();
        if (!doc.exists) {
          final slumberUser = SlumberUser(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            age: 0,
            sleepGoalHours: 8,
          );
          await _db.collection("users").doc(user.uid).set(slumberUser.toMap());
        }
      }
      return user;
    } catch (e) {
      throw Exception("Google Sign-In Error: $e");
    }
  }

  /// 🟢 Current User Getter
  User? get currentUser => _auth.currentUser;
}