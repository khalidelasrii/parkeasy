import 'package:dartz/dartz.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_services.dart';
import 'package:parkeasy/features/auth/data/models/user_model.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseServices _firebaseServices;

  AuthRepositoryImpl({required FirebaseServices firebaseServices})
      : _firebaseServices = firebaseServices;

  @override
  Future<Either<AuthException, String>> signInWithPhone(String phone) async {
    try {
      final verificationId =
          await _firebaseServices.firebaseAuthService.signInWithPhone(phone);
      return Right(verificationId);
    } on AuthException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthException('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<AuthException, UserEntity>> verificationOTP(
      String sms, String verificationId) async {
    try {
      final userCredential = await _firebaseServices.firebaseAuthService
          .verifyOTP(sms, verificationId);
      final uid = userCredential.user?.uid;
      if (uid == null) {
        return Left(AuthException('User ID is null after verification'));
      }

      UserEntity? user =
          await _firebaseServices.firebaseFirestorService.getUserData(uid);
      if (user == null) {
        // Create new user if not exists
        user =
            UserEntity(id: uid, phoneNumber: userCredential.user?.phoneNumber);
        await _firebaseServices.firebaseFirestorService
            .createUserData(UserModel.fromUserEntity(user));
      }

      return Right(user);
    } on AuthException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(AuthException(
          'An unexpected error occurred during OTP verification'));
    }
  }

  @override
  Future<Either<AuthException, UserEntity>> signInWithGoogle() async {
    try {
      final userCredential =
          await _firebaseServices.firebaseAuthService.signInWithGoogle();
      final uid = userCredential.user?.uid;
      if (uid == null) {
        return Left(AuthException('User ID is null after Google sign-in'));
      }

      UserEntity? user =
          await _firebaseServices.firebaseFirestorService.getUserData(uid);
      if (user == null) {
        // Create new user if not exists
        user = UserEntity(
          id: uid,
          email: userCredential.user?.email,
          name: userCredential.user?.displayName,
        );
        await _firebaseServices.firebaseFirestorService
            .createUserData(UserModel.fromUserEntity(user));
      }

      return Right(user);
    } on AuthException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
          AuthException('An unexpected error occurred during Google sign-in'));
    }
  }
}
