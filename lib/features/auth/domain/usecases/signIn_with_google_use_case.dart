import 'package:dartz/dartz.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<AuthException, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}