import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parkeasy/core/constant/enum.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/entities/user_entity.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/get_courent_user_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/save_user_info_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/signIn_with_google_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/sign_in_with_phone_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/sing_out_use_case.dart';
import 'package:parkeasy/features/autt%20&%20user_profile/domain/usecases/verification_o_t_p_use_case.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignInWithPhoneUseCase signInWithPhoneUseCase;
  final VerificationOTPUseCase verificationOTPEvent;
  final SingOutUseCase singOutUseCase;
  final SaveUserInfoUseCase saveUserInfoUseCase;
  final GetCourentUserUseCase getCurrentUserUseCase;
  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.singOutUseCase,
    required this.signInWithGoogleUseCase,
    required this.signInWithPhoneUseCase,
    required this.verificationOTPEvent,
    required this.saveUserInfoUseCase, // Add this
  }) : super(AuthState.initial()) {
    on<UserLoginPhoneEvent>(_onUserLoginPhone);
    on<VerificationOTPEvent>(_onVerificationOTP);
    on<GoogleSignInEvent>(_onGoogleSignIn);
    on<SingOutEvent>(_onSingOut);
    on<SaveUserInfoEvent>(_onSaveUserInfo);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
  }

  FutureOr<void> _onGetCurrentUser(
      GetCurrentUserEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    try {
      final userOr = await getCurrentUserUseCase();
      if (userOr != null) {
        emit(state.copyWith(status: AppStatus.success, user: userOr));
      } else {
        emit(state.copyWith(status: AppStatus.unknown, user: userOr));
      }
    } catch (e) {
      emit(state.copyWith(status: AppStatus.error, error: e.toString()));
    }
  }

  FutureOr<void> _onSaveUserInfo(
      SaveUserInfoEvent event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(status: AppStatus.loading));
      final userCred = await getCurrentUserUseCase();
      final newUser = userCred!.copyWith(
          name: event.name,
          profileFile: event.image,
          accountStatus: AccountStatus.accepted);
      final result = await saveUserInfoUseCase(newUser);
      result.fold(
        (failure) => emit(state.copyWith(
          status: AppStatus.error,
          error: failure.message,
        )),
        (user) => emit(state.copyWith(
          status: AppStatus.success,
          user: user,
        )),
      );
    } catch (e) {
      emit(state.copyWith(
        status: AppStatus.error,
        error: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  FutureOr<void> _onSingOut(SingOutEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    final out = await singOutUseCase();
    out.fold((exp) {
      emit(state.copyWith(status: AppStatus.error, error: exp.code));
    }, (_) {
      emit(state.copyWith(status: AppStatus.unknown, user: null));
    });
  }

  FutureOr<void> _onGoogleSignIn(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AppStatus.loading));
    final result = await signInWithGoogleUseCase();
    result.fold(
      (failure) => emit(state.copyWith(
        verificationId: null,
        status: AppStatus.error,
        error: failure.message,
      )),
      (user) => emit(state.copyWith(
        verificationId: null,
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

    result.fold((resultExp) {
      emit(state.copyWith(
          status: AppStatus.error,
          error: "otp_verification_error:${resultExp.message}"));
    }, (resultUser) {
      if (resultUser.accountStatus == AccountStatus.initial) {
        emit(state.copyWith(status: AppStatus.infos, user: resultUser));
      } else if (resultUser.accountStatus != AccountStatus.pending) {
        emit(state.copyWith(status: AppStatus.success, user: resultUser));
      } else {
        emit(state.copyWith(status: AppStatus.unknown, user: resultUser));
      }
    });
  }
}
