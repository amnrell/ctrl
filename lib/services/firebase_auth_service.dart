import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication Service
/// Handles user authentication including login, signup, and password reset
class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign in with email and password
  /// Returns the UserCredential on success, throws Exception with user-friendly message on error
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Log Firebase Auth errors for debugging
      print('FirebaseAuthException: Code=${e.code}, Message=${e.message}');
      // Re-throw to preserve exception type for proper handling
      rethrow;
    } catch (e) {
      // Known issue: Sometimes Firebase Android SDK has Pigeon serialization errors
      // but authentication actually succeeds. The UI layer handles this case.
      print('Authentication error: ${e.runtimeType} - $e');

      // Re-throw the original error
      // The UI layer will check if user is actually signed in as a workaround
      throw e;
    }
  }

  /// Create a new account with email and password
  /// Returns the UserCredential on success, throws Exception with user-friendly message on error
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Throw with user-friendly error message
      throw Exception(_handleAuthException(e));
    }
  }

  /// Send password reset email
  /// Returns void on success, throws Exception with user-friendly message on error
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      
    } on FirebaseAuthException catch (e) {
      // Throw with user-friendly error message
      throw Exception(_handleAuthException(e));
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get user-friendly error message from FirebaseAuthException
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak. Please use a stronger password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'user-not-found':
        return 'No account found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'The email address is invalid. Please check and try again.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}
