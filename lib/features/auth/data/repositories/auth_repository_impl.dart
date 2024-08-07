import 'package:dartz/dartz.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_services.dart';
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

      return verificationId != null
          ? Right(verificationId)
          : Left(AuthException("To meny Exeption "));
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

      if (userCredential != null) {
        final bool exist = await _firebaseServices.firebaseFirestorService
            .checkUserExists(userCredential.uid);

        if (exist) {
          UserEntity user = await _firebaseServices.firebaseFirestorService
              .getUserData(userCredential.uid);

          return Right(user);
        } else {
          UserEntity newUser = UserEntity(
            accountStatus: AccountStatus.initial,
            id: userCredential.uid,
            email: userCredential.email,
            phoneNumber: userCredential.phoneNumber,
            name: userCredential.displayName,
          );

          return Right(newUser);
        }
      }
      return Left(AuthException('Error after verification'));
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

      if (userCredential != null) {
        final bool exist = await _firebaseServices.firebaseFirestorService
            .checkUserExists(userCredential.uid);
        if (exist) {
          UserEntity user = await _firebaseServices.firebaseFirestorService
              .getUserData(userCredential.uid);
          return Right(user);
        } else {
          UserEntity newUser = UserEntity(
            accountStatus: AccountStatus.initial,
            id: userCredential.uid,
            email: userCredential.email,
            phoneNumber: userCredential.phoneNumber,
            name: userCredential.displayName,
          );

          return Right(newUser);
        }
      }

      return Left(AuthException('User ID is null after Google sign-in'));
    } on AuthException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
          AuthException('An unexpected error occurred during Google sign-in'));
    }
  }

  @override
  Future<Either<AuthException, Unit>> signOut() async {
    try {
      await _firebaseServices.firebaseAuthService.signOut();
      return right(unit);
    } catch (e) {
      return left(AuthException(e.toString()));
    }
  }

  @override
  Stream<AccountStatus?> getAccountStatusStream() {
    final user = _firebaseServices.firebaseAuthService.getCurrentUser();

    return user != null
        ? _firebaseServices.firebaseFirestorService
            .getAccountStatusStream(user.uid)
        : const Stream.empty();

  }
}
