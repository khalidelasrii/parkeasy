import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';
import 'package:parkeasy/features/auth/domain/repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthState.initial()) {
    on<UserLoginPhoneEvent>(_onUserLoginPhone);
    on<VerificationOTPEvent>(_onVerificationOTP);
    on<GoogleSignInEvent>(_onGoogleSignIn);
  }
  FutureOr<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    final result = await repository.signInWithGoogle();
    result.fold(
      (failure) => emit(state.copyWith(
        status: AppStatus.error,
        error: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: user.accountStatus == AccountStatus.initial
            ? AppStatus.infos
            : AppStatus.success,
        user: user,
      )),
    );
  }

  FutureOr<void> _onUserLoginPhone(
      UserLoginPhoneEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    final result = await repository.signInWithPhone(event.phone);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AppStatus.error,
        error: failure.message,
      )),
      (verificationId) => emit(state.copyWith(
        status: AppStatus.success,
        verificationId: verificationId,
      )),
    );
  }

  FutureOr<void> _onVerificationOTP(
      VerificationOTPEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    final result =
        await repository.verificationOTP(event.sms, event.verificationId);
    result.fold(
      (failure) => emit(state.copyWith(
        status: AppStatus.error,
        error: failure.message,
      )),
      (user) => emit(state.copyWith(
        status: user.accountStatus == AccountStatus.initial
            ? AppStatus.infos
            : AppStatus.success,
        user: user,
      )),
    );
  }
}
