import 'package:parkeasy/features/autt%20&%20user_profile/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parkeasy/core/constant/enum.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
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
  final String? profileUrl;
  
  const UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.accountStatus,
    this.userRole,
    this.carPlateNumber,
    this.parkingSpot,
    this.cardFront,
    this.cardBack,
    this.profileUrl,
  });

  factory UserModel.fromUserEntity(UserEntity entity) {
    return UserModel(
      profileUrl: entity.profileUrl,
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      accountStatus: entity.accountStatus,
      userRole: entity.userRole,
      carPlateNumber: entity.carPlateNumber,
      parkingSpot: entity.parkingSpot,
      cardFront: entity.cardFront,
      cardBack: entity.cardBack,
    );
  }

  UserEntity toUserEntity() {
    return UserEntity(
      profileUrl: profileUrl,
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      accountStatus: accountStatus,
      userRole: userRole,
      carPlateNumber: carPlateNumber,
      parkingSpot: parkingSpot,
      cardFront: cardFront,
      cardBack: cardBack,
    );
  }

  // Méthodes JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  Map<String, String?> jsonUpdatUserInfo() => _$jsonUpdatUserInfo(this);
}
