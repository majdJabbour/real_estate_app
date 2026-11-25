import 'package:json_annotation/json_annotation.dart';

part 'favorite_mutation_dto.g.dart';

@JsonSerializable(createToJson: false)
final class FavoriteMutationDto {
  const FavoriteMutationDto({
    required this.propertyId,
    required this.isFavorite,
  });

  factory FavoriteMutationDto.fromJson(Map<String, Object?> json) =>
      _$FavoriteMutationDtoFromJson(json);

  final String propertyId;
  final bool isFavorite;
}
