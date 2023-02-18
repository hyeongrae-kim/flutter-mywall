import 'package:json_annotation/json_annotation.dart';
part 'movie_list_model.g.dart';

@JsonSerializable()
class MovieListModel {
  final int page;
  final List<MovieModel> results;
  final int total_results;
  final int total_pages;

  MovieListModel({
    required this.page,
    required this.results,
    required this.total_results,
    required this.total_pages,
  });

  factory MovieListModel.fromJson(Map<String, dynamic> json)
  => _$MovieListModelFromJson(json);
}

@JsonSerializable()
class MovieModel {
  final String? poster_path;
  final bool adult;
  final String overview;
  final String release_date;
  final List<int> genre_ids;
  final int id;
  final String original_title;
  final String original_language;
  final String title;
  final String? backdrop_path;
  final double popularity;
  final int vote_count;
  final bool video;
  final double vote_average;

  MovieModel({
    required this.poster_path,
    required this.adult,
    required this.overview,
    required this.release_date,
    required this.genre_ids,
    required this.id,
    required this.original_title,
    required this.original_language,
    required this.title,
    required this.backdrop_path,
    required this.popularity,
    required this.vote_count,
    required this.video,
    required this.vote_average,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json)
  => _$MovieModelFromJson(json);
}
