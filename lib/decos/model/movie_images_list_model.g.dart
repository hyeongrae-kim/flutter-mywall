// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_images_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieImagesListModel _$MovieImagesListModelFromJson(
        Map<String, dynamic> json) =>
    MovieImagesListModel(
      id: json['id'] as int,
      backdrops: (json['backdrops'] as List<dynamic>)
          .map((e) => BackdropInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      posters: (json['posters'] as List<dynamic>)
          .map((e) => PosterInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieImagesListModelToJson(
        MovieImagesListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'backdrops': instance.backdrops,
      'posters': instance.posters,
    };

BackdropInfo _$BackdropInfoFromJson(Map<String, dynamic> json) => BackdropInfo(
      aspect_ratio: (json['aspect_ratio'] as num).toDouble(),
      file_path: json['file_path'] as String,
      height: json['height'] as int,
      iso_639_1: json['iso_639_1'] as String?,
      vote_averge: (json['vote_averge'] as num?)?.toDouble(),
      vote_count: json['vote_count'] as int?,
      width: json['width'] as int,
    );

Map<String, dynamic> _$BackdropInfoToJson(BackdropInfo instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspect_ratio,
      'file_path': instance.file_path,
      'height': instance.height,
      'iso_639_1': instance.iso_639_1,
      'vote_averge': instance.vote_averge,
      'vote_count': instance.vote_count,
      'width': instance.width,
    };

PosterInfo _$PosterInfoFromJson(Map<String, dynamic> json) => PosterInfo(
      aspect_ratio: (json['aspect_ratio'] as num).toDouble(),
      file_path: json['file_path'] as String,
      height: json['height'] as int,
      iso_639_1: json['iso_639_1'] as String?,
      vote_averge: (json['vote_averge'] as num?)?.toDouble(),
      vote_count: json['vote_count'] as int?,
      width: json['width'] as int,
    );

Map<String, dynamic> _$PosterInfoToJson(PosterInfo instance) =>
    <String, dynamic>{
      'aspect_ratio': instance.aspect_ratio,
      'file_path': instance.file_path,
      'height': instance.height,
      'iso_639_1': instance.iso_639_1,
      'vote_averge': instance.vote_averge,
      'vote_count': instance.vote_count,
      'width': instance.width,
    };
