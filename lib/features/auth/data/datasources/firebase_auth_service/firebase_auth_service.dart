import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<String> signInWithPhone(String phoneNumber) async {
    try {
      final verificationIdCompleter = Completer<String>();

      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (e) => throw FirebaseAuthException(code: e.code, message: e.message),
        codeSent: (String verificationId, int? resendToken) {
          verificationIdCompleter.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (_) {},
      );

      return verificationIdCompleter.future;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during phone sign-in', code: e.code);
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
      throw AuthException(e.message ?? 'An error occurred during OTP verification', code: e.code);
    } catch (e) {
      throw AuthException('An unexpected error occurred during OTP verification');
    }
  }
}