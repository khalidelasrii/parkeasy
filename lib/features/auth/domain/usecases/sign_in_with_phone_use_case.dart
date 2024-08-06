import 'package:dartz/dartz.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';

class SignInWithPhoneUseCase {
  final AuthRepository _authRepository;

  SignInWithPhoneUseCase(this._authRepository);

  Future<Either<AuthException, String>> call(String phone) async {
    return await _authRepository.signInWithPhone(phone);
  }
}
