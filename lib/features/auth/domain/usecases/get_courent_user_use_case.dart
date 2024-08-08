
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';

class GetCourentUserUseCase {
  final AuthRepository _authRepository;
  GetCourentUserUseCase(this._authRepository);

  Future<UserEntity?> call() async {
    return await _authRepository.getCourentUser();
  }
}
