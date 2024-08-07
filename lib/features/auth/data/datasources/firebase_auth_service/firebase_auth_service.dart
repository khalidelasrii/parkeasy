import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Future<Unit> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    return unit;
  }

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<User?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Google Sign-In was cancelled by the user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          e.message ?? 'An error occurred during Google sign-in',
          code: e.code);
    } catch (e) {
      throw AuthException('An unexpected error occurred during Google sign-in');
    }
  }

  Future<String?> signInWithPhone(String phoneNumber) async {
    final completer = Completer<String?>();
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _firebaseAuth.signInWithCredential(credential);
            completer.complete(null);
          } catch (e) {
            completer
                .completeError(AuthException('Credential verification failed'));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          completer.completeError(
              AuthException(e.message ?? 'Phone number verification failed'));
        },
        codeSent: (String verificationId, int? resendToken) {
          completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
      );
    } catch (e) {
      completer.completeError(AuthException('An unexpected error occurred'));
    }
    return completer.future;
  }

  Future<User?> verifyOTP(String sms, String verificationId) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: sms,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'OTP verification failed');
    } catch (e) {
      throw AuthException(
          'An unexpected error occurred during OTP verification');
    }
  }
}
