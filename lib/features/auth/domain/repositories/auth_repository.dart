import 'package:dartz/dartz.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<AuthException, String>> signInWithPhone(String phone);
  Future<Either<AuthException, UserEntity>> verificationOTP(String sms, String verificationId);
}