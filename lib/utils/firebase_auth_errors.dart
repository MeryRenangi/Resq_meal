import 'package:firebase_auth/firebase_auth.dart';

abstract final class FirebaseAuthErrors {
  static String message(Object error) {
    if (error is FirebaseAuthException) {
      return switch (error.code) {
        'invalid-email' => 'The email address is not valid.',
        'user-disabled' => 'This account has been disabled.',
        'user-not-found' => 'No account found with this email.',
        'wrong-password' => 'Incorrect password. Please try again.',
        'email-already-in-use' => 'An account already exists with this email.',
        'weak-password' => 'Password is too weak. Use at least 8 characters.',
        'operation-not-allowed' => 'This sign-in method is not enabled.',
        'too-many-requests' => 'Too many attempts. Please try again later.',
        'network-request-failed' => 'Network error. Check your connection.',
        'invalid-credential' => 'Invalid email or password.',
        _ => error.message ?? 'Authentication failed. Please try again.',
      };
    }
    return error.toString();
  }
}
