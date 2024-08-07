import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';
import 'package:parkeasy/features/auth/domain/usecases/signIn_with_google_use_case.dart';
import 'package:parkeasy/features/auth/domain/usecases/sign_in_with_phone_use_case.dart';
import 'package:parkeasy/features/auth/domain/usecases/sing_out_use_case.dart';
import 'package:parkeasy/features/auth/domain/usecases/verification_o_t_p_use_case.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithPhoneUseCase signInWithPhoneUseCase;
  final VerificationOTPUseCase verificationOTPEvent;
  final SingOutUseCase singOutUseCase;
  AuthBloc(
      {required this.singOutUseCase,
      required this.signInWithGoogleUseCase,
      required this.signInWithPhoneUseCase,
      required this.verificationOTPEvent})
      : super(AuthState.initial()) {
    on<UserLoginPhoneEvent>(_onUserLoginPhone);
    on<VerificationOTPEvent>(_onVerificationOTP);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<SingOutEvent>(_onSingOut);
  }

  FutureOr<void> _onSingOut(SingOutEvent event, Emitter<AuthState> emit) async {
    final out = await singOutUseCase();
    out.fold((exp) {
      emit(state.copyWith(status: AppStatus.error, error: exp.code));
    }, (_) {
      emit(state.copyWith(status: AppStatus.success, user: null));
    });
  }

  FutureOr<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    final result = await signInWithGoogleUseCase();
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

    print("------------------- ${event.phone}");
    final result = await signInWithPhoneUseCase(event.phone);
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
    final result = await verificationOTPEvent(event.sms, event.verificationId);
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
