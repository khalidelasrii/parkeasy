import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';

class GetAccountStatusUseCase {
  final AuthRepository _authRepository;
  GetAccountStatusUseCase(this._authRepository);

  Stream<AccountStatus?> call() {
    return _authRepository.getAccountStatusStream();
  }
}
