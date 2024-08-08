part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UserLoginPhoneEvent extends AuthEvent {
  final String phone;

  const UserLoginPhoneEvent({required this.phone});

  @override
  List<Object> get props => [phone];
}

class VerificationOTPEvent extends AuthEvent {
  final String sms;
  final String verificationId;

  const VerificationOTPEvent(this.sms, this.verificationId);

  @override
  List<Object> get props => [sms, verificationId];
}

class GoogleSignInEvent extends AuthEvent {}

class SingOutEvent extends AuthEvent {}

class SaveUserInfoEvent extends AuthEvent {
  final String name;
  final File? image;
  const SaveUserInfoEvent({required this.name, this.image});
}


class GetCurrentUserEvent extends AuthEvent {}
