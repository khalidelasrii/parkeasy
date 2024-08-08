import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';


class SingOutUseCase {
  final AuthRepository _authRepository;
    SingOutUseCase(this._authRepository);
  Future<Either<AuthException, Unit>> call() async {
    return await _authRepository.signOut();
  }
}