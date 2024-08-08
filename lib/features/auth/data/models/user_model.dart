import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parkeasy/core/constant/enum.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    super.id,
    super.name,
    super.email,
    super.phoneNumber,
    super.accountStatus,
    super.userRole,
    super.carPlateNumber,
    super.parkingSpot,
    super.cardFront,
    super.cardBack,
    super.profileUrl,
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
