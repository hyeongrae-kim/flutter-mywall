// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieModel _$MovieModelFromJson(Map<String, dynamic> json) => MovieModel(
      lastBuildDate: json['lastBuildDate'] as String,
      total: json['total'] as int,
      start: json['start'] as int,
      display: json['display'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => MovieDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieModelToJson(MovieModel instance) =>
    <String, dynamic>{
      'lastBuildDate': instance.lastBuildDate,
      'total': instance.total,
      'start': instance.start,
      'display': instance.display,
      'items': instance.items,
    };

MovieDetailModel _$MovieDetailModelFromJson(Map<String, dynamic> json) =>
    MovieDetailModel(
      title: json['title'] as String,
      link: json['link'] as String,
      image: json['image'] as String,
      subtitle: json['subtitle'] as String,
      pubDate: json['pubDate'] as String,
      director: json['director'] as String,
      actor: json['actor'] as String,
      userRating: json['userRating'] as String,
    );

Map<String, dynamic> _$MovieDetailModelToJson(MovieDetailModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'link': instance.link,
      'image': instance.image,
      'subtitle': instance.subtitle,
      'pubDate': instance.pubDate,
      'director': instance.director,
      'actor': instance.actor,
      'userRating': instance.userRating,
    };
