import 'package:json_annotation/json_annotation.dart';
part 'movie_images_list_model.g.dart';

@JsonSerializable()
class MovieImagesListModel {
  final int id;
  final List<BackdropInfo> backdrops;
  final List<PosterInfo> posters;

  MovieImagesListModel({
    required this.id,
    required this.backdrops,
    required this.posters,
  });
  
  factory MovieImagesListModel.fromJson(Map<String, dynamic> json)
  => _$MovieImagesListModelFromJson(json);
}

@JsonSerializable()
class BackdropInfo {
  final double aspect_ratio;
  final String file_path;
  final int height;
  final String? iso_639_1;
  final double? vote_averge;
  final int? vote_count;
  final int width;

  BackdropInfo({
    required this.aspect_ratio,
    required this.file_path,
    required this.height,
    required this.iso_639_1,
    required this.vote_averge,
    required this.vote_count,
    required this.width,
  });
  
  factory BackdropInfo.fromJson(Map<String, dynamic> json)
  => _$BackdropInfoFromJson(json);
}

@JsonSerializable()
class PosterInfo {
  final double aspect_ratio;
  final String file_path;
  final int height;
  final String? iso_639_1;
  final double? vote_averge;
  final int? vote_count;
  final int width;

  PosterInfo({
    required this.aspect_ratio,
    required this.file_path,
    required this.height,
    required this.iso_639_1,
    required this.vote_averge,
    required this.vote_count,
    required this.width,
  });
  
  factory PosterInfo.fromJson(Map<String, dynamic> json)
  => _$PosterInfoFromJson(json);
}
