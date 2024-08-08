// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      accountStatus:
          $enumDecodeNullable(_$AccountStatusEnumMap, json['accountStatus']),
      userRole: $enumDecodeNullable(_$UserRoleEnumMap, json['userRole']),
      carPlateNumber: json['carPlateNumber'] as String?,
      parkingSpot: json['parkingSpot'] as String?,
      cardFront: json['cardFront'] as String?,
      cardBack: json['cardBack'] as String?,
      profileUrl: json['profileUrl'] as String?,
    );

Map<String, String?> _$jsonUpdatUserInfo(UserModel instance) {
  return {
    'name': instance.name,
    'accountStatus': _$AccountStatusEnumMap[instance.accountStatus],
    'profileUrl': instance.profileUrl,
  };
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'accountStatus': _$AccountStatusEnumMap[
          instance.accountStatus ?? AccountStatus.initial],
      'userRole': _$UserRoleEnumMap[instance.userRole ?? UserRole.user],
      'carPlateNumber': instance.carPlateNumber,
      'parkingSpot': instance.parkingSpot,
      'cardFront': instance.cardFront,
      'cardBack': instance.cardBack,
      'profileUrl': instance.profileUrl,
    };

const _$AccountStatusEnumMap = {
  AccountStatus.initial: 'initial',
  AccountStatus.pending: 'pending',
  AccountStatus.accepted: 'accepted',
  AccountStatus.blocked: 'blocked',
};

const _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.manager: 'manager',
  UserRole.user: 'user',
};
