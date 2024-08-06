import 'dart:async';

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
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw AuthException('Google Sign-In was cancelled by the user');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          e.message ?? 'An error occurred during Google sign-in',
          code: e.code);
    } catch (e) {
      throw AuthException('An unexpected error occurred during Google sign-in');
    }
  }

  Future<String> signInWithPhone(String phoneNumber) async {
    try {
      final verificationIdCompleter = Completer<String>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (e) =>
            throw FirebaseAuthException(code: e.code, message: e.message),
        codeSent: (String verificationId, int? resendToken) {
          verificationIdCompleter.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (_) {},
      );

      return verificationIdCompleter.future;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during phone sign-in',
          code: e.code);
    } catch (e) {
      throw AuthException('An unexpected error occurred during phone sign-in');
    }
  }

  Future<UserCredential> verifyOTP(String sms, String verificationId) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: sms,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
          e.message ?? 'An error occurred during OTP verification',
          code: e.code);
    } catch (e) {
      throw AuthException(
          'An unexpected error occurred during OTP verification');
    }
  }
}
