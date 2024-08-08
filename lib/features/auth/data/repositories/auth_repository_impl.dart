import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_services.dart';
import 'package:parkeasy/features/auth/data/datasources/firebase_storage_service/firebase_storage.dart';
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
      return verificationId != null
          ? Right(verificationId)
          : Left(AuthException("Too many exceptions"));
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

      return await _handleUserCredential(userCredential);
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

      return await _handleUserCredential(userCredential);
    } on AuthException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
          AuthException('An unexpected error occurred during Google sign-in'));
    }
  }

  Future<Either<AuthException, UserEntity>> _handleUserCredential(
      User? userCredential) async {
    if (userCredential == null) {
      return Left(AuthException('User ID is null after sign-in'));
    }

    final exists = await _firebaseServices.firebaseFirestorService
        .checkUserExists(userCredential.uid);

    if (exists) {
      final UserEntity user = await _firebaseServices
          .firebaseFirestorService
          .getUserData(userCredential.uid);
      return Right(user);
    } else {
      final UserEntity newUser = UserEntity(
        accountStatus: AccountStatus.initial,
        id: userCredential.uid,
        email: userCredential.email,
        phoneNumber: userCredential.phoneNumber,
        name: userCredential.displayName,
      );
      await _firebaseServices.firebaseFirestorService
          .createUserData(UserModel.fromUserEntity(newUser));
      return Right(newUser);
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
  Future<Either<AuthException, UserEntity>> saveUserInfoUseCase(
      UserEntity userEntity) async {
    try {
      final url = await _firebaseServices.firebaseStorageService.uploadFile(
          userEntity.profileFile!,
          FirebaseStorageService.profilesFolderName,
          "profiles${userEntity.id}");
      final newUser = userEntity.copyWith(
          profileUrl: url, accountStatus: AccountStatus.accepted);

      return await _upsertUserData(newUser);
    } catch (e) {
      return Left(AuthException(e.toString()));
    }
  }

  Future<Either<AuthException, UserEntity>> _upsertUserData(
      UserEntity userEntity) async {
    final exists = await _firebaseServices.firebaseFirestorService
        .checkUserExists(userEntity.id!);
    if (exists) {
      final user = await _firebaseServices.firebaseFirestorService
          .updateUserInfo(UserModel.fromUserEntity(userEntity));
      return Right(user);
    } else {
      final user = await _firebaseServices.firebaseFirestorService
          .createUserData(UserModel.fromUserEntity(userEntity));
      return Right(user.toUserEntity());
    }
  }

  @override
  Future<UserEntity?> getCourentUser() async {
    try {
      final userCredential =
          _firebaseServices.firebaseAuthService.getCurrentUser();
      if (userCredential != null) {
        final exists = await _firebaseServices.firebaseFirestorService
            .checkUserExists(userCredential.uid);
        if (!exists) {
          return UserEntity(
            accountStatus: AccountStatus.initial,
            id: userCredential.uid,
            email: userCredential.email,
            name: userCredential.displayName,
            phoneNumber: userCredential.phoneNumber,
          );
        }
        return await _firebaseServices.firebaseFirestorService
            .getUserData(userCredential.uid);
      }
      return null;
    } catch (e) {
      throw AuthException('Error fetching current user: $e');
    }
  }
}

// FirebaseStorageService and FirebaseFirestoreService remain unchanged.