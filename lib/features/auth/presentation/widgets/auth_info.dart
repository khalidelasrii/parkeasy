import 'package:equatable/equatable.dart';

class AuthInfo extends Equatable {
  final String? verificationId;
  final String? phoneNumber;
  const AuthInfo(this.phoneNumber, this.verificationId);

  @override
  List<Object?> get props => [phoneNumber, verificationId];
}
