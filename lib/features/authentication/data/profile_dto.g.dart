// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['id', 'email', 'name', 'avatar']);
  return ProfileDto(
    json['id'] as String,
    json['email'] as String?,
    json['name'] as String?,
    json['avatar'] as String?,
  );
}
