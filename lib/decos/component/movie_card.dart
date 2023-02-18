import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mywall/decos/model/movie_list_model.dart';

class MovieCard extends StatelessWidget {
  final String original_title;
  final String release_date;
  final String? poster_path;

  const MovieCard({
    required this.original_title,
    required this.release_date,
    required this.poster_path,
    Key? key,
  }) : super(key: key);

  factory MovieCard.fromModel({
    required MovieModel model,
  }) {
    return MovieCard(
      original_title: model.original_title,
      release_date: model.release_date,
      poster_path: model.poster_path,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Intrinsic Height
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'https://image.tmdb.org/t/p/w300/${poster_path!}',
              // poster 가로 세로 비율 1:루트2로 맞추기
              width: (MediaQuery.of(context).size.width / 13) * 4,
              height: (MediaQuery.of(context).size.width / 7) * 2 * sqrt(2),

            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            original_title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            release_date.substring(0, 4),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
