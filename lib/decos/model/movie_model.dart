import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@JsonSerializable()
class MovieModel {
  final String lastBuildDate;
  final int total;

  // 검색 시작 위치
  final int start;

  // 한 번에 표시할 검색 결과 개수
  final int display;
  final List<MovieDetailModel> items;

  MovieModel({
    required this.lastBuildDate,
    required this.total,
    required this.start,
    required this.display,
    required this.items,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);
}

@JsonSerializable()
class MovieDetailModel {
  final String title;
  final String link;
  final String image;
  final String subtitle;
  final String pubDate;
  final String director;
  final String actor;
  final String userRating;

  MovieDetailModel({
    required this.title,
    required this.link,
    required this.image,
    required this.subtitle,
    required this.pubDate,
    required this.director,
    required this.actor,
    required this.userRating,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailModelFromJson(json);
}
