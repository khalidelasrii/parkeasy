part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UserLoginPhoneEvent extends AuthEvent {
  final String phone;

  const UserLoginPhoneEvent(this.phone);

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
