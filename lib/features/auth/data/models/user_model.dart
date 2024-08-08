import 'package:parkeasy/features/auth/domain/entities/user_entity.dart';

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
}
