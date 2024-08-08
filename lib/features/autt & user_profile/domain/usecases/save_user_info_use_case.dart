import 'package:dartz/dartz.dart';
import 'package:parkeasy/core/exeption/auth_exeption.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/entities/user_entity.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/repositories/auth_repository.dart';

class SaveUserInfoUseCase {
  final AuthRepository _authRepository;
  SaveUserInfoUseCase(this._authRepository);

  Future<Either<AuthException, UserEntity>> call(UserEntity userEntity) async {
    return await _authRepository.saveUserInfoUseCase(userEntity);
  }
}
