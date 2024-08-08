part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AppStatus status;
  final UserEntity? user;
  final String? verificationId;
  final String? error;
  final String? sms;

  const AuthState({
    this.sms,
    required this.status,
    this.user,
    this.verificationId,
    this.error,
  });

  factory AuthState.initial() => const AuthState(status: AppStatus.unknown);

  AuthState copyWith({
    AppStatus? status,
    UserEntity? user,
    String? verificationId,
    String? error,
    File? profileImage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      verificationId: verificationId ?? this.verificationId,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, user, verificationId, error];
}
