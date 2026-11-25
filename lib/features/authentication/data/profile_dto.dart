import 'package:json_annotation/json_annotation.dart';

import '../domain/authentication_repository.dart';

part 'profile_dto.g.dart';

@JsonSerializable(createToJson: false)
final class ProfileDto {
  const ProfileDto(this.id, this.email, this.name, this.avatar);

  factory ProfileDto.fromJson(Map<String, Object?> json) =>
      _$ProfileDtoFromJson(json);

  @JsonKey(required: true)
  final String id;
  @JsonKey(required: true)
  final String? email;
  @JsonKey(required: true)
  final String? name;
  @JsonKey(required: true)
  final String? avatar;

  static AuthenticatedUser decode(Object? payload) {
    final ProfileDto dto;
    try {
      dto = ProfileDto.fromJson(payload as Map<String, Object?>);
    } on MissingRequiredKeysException {
      throw const FormatException('Missing profile fields.');
    }
    if (dto.id.trim().isEmpty) {
      throw const FormatException('Invalid profile ID.');
    }
    return AuthenticatedUser(
      id: dto.id,
      email: dto.email,
      name: dto.name,
      avatar: dto.avatar,
    );
  }
}
