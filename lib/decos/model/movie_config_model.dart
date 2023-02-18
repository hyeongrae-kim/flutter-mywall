import 'package:json_annotation/json_annotation.dart';
part 'movie_config_model.g.dart';

@JsonSerializable()
class MovieConfigModel {
  final MovieImagesInfoModel images;
  final List<String> change_keys;

  MovieConfigModel({
    required this.images,
    required this.change_keys,
  });

  factory MovieConfigModel.fromJson(Map<String, dynamic> json)
  => _$MovieConfigModelFromJson(json);
}

@JsonSerializable()
class MovieImagesInfoModel {
  final String base_url;
  final String secure_base_url;
  final List<String> backdrop_sizes;
  final List<String> logo_sizes;
  final List<String> poster_sizes;
  final List<String> profile_sizes;
  final List<String> still_sizes;

  MovieImagesInfoModel({
    required this.base_url,
    required this.secure_base_url,
    required this.backdrop_sizes,
    required this.logo_sizes,
    required this.poster_sizes,
    required this.profile_sizes,
    required this.still_sizes,
  });

  factory MovieImagesInfoModel.fromJson(Map<String, dynamic> json)
  => _$MovieImagesInfoModelFromJson(json);
}
