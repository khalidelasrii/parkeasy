import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parkeasy/core/constant/enum.dart';
part 'user_entity.g.dart';

@JsonSerializable()
class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final AccountStatus? accountStatus;
  final UserRole? userRole;
  final String? carPlateNumber;
  final String? parkingSpot;
  final String? cardFront;
  final String? cardBack;
  final File? profileFile;
  final String? profileUrl;
  const UserEntity({
    this.profileUrl,
    this.id,
    this.profileFile,
    this.name,
    this.email,
    this.phoneNumber,
    this.accountStatus,
    this.userRole,
    this.carPlateNumber,
    this.parkingSpot,
    this.cardFront,
    this.cardBack,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phoneNumber,
        accountStatus,
        userRole,
        carPlateNumber,
        parkingSpot,
        cardFront,
        cardBack,
      ];

  UserEntity copyWith({
    File? profileFile,
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    AccountStatus? accountStatus,
    UserRole? userRole,
    String? carPlateNumber,
    String? parkingSpot,
    String? cardFront,
    String? cardBack,
    String? profileUrl,
  }) {
    return UserEntity(
      profileUrl: profileUrl ?? this.profileUrl,
      profileFile: profileFile ?? this.profileFile,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountStatus: accountStatus ?? this.accountStatus,
      userRole: userRole ?? this.userRole,
      carPlateNumber: carPlateNumber ?? this.carPlateNumber,
      parkingSpot: parkingSpot ?? this.parkingSpot,
      cardFront: cardFront ?? this.cardFront,
      cardBack: cardBack ?? this.cardBack,
    );
  }

  @override
  String toString() {
    return 'UserEntity(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, accountStatus: $accountStatus, userRole: $userRole, carPlateNumber: $carPlateNumber, parkingSpot: $parkingSpot, cardFront: $cardFront, cardBack: $cardBack)';
  }

  // Méthodes JSON
  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
