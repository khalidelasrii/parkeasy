import 'package:equatable/equatable.dart';

class AuthInfo extends Equatable {
  final String? verificationId;
  final String? sms;
  const AuthInfo(this.sms, this.verificationId);

  @override
  List<Object?> get props => [sms, verificationId];
}
