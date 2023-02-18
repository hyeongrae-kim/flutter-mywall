// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieConfigModel _$MovieConfigModelFromJson(Map<String, dynamic> json) =>
    MovieConfigModel(
      images:
          MovieImagesInfoModel.fromJson(json['images'] as Map<String, dynamic>),
      change_keys: (json['change_keys'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MovieConfigModelToJson(MovieConfigModel instance) =>
    <String, dynamic>{
      'images': instance.images,
      'change_keys': instance.change_keys,
    };

MovieImagesInfoModel _$MovieImagesInfoModelFromJson(
        Map<String, dynamic> json) =>
    MovieImagesInfoModel(
      base_url: json['base_url'] as String,
      secure_base_url: json['secure_base_url'] as String,
      backdrop_sizes: (json['backdrop_sizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      logo_sizes: (json['logo_sizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      poster_sizes: (json['poster_sizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      profile_sizes: (json['profile_sizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      still_sizes: (json['still_sizes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MovieImagesInfoModelToJson(
        MovieImagesInfoModel instance) =>
    <String, dynamic>{
      'base_url': instance.base_url,
      'secure_base_url': instance.secure_base_url,
      'backdrop_sizes': instance.backdrop_sizes,
      'logo_sizes': instance.logo_sizes,
      'poster_sizes': instance.poster_sizes,
      'profile_sizes': instance.profile_sizes,
      'still_sizes': instance.still_sizes,
    };
