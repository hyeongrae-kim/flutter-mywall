import 'package:flutter/material.dart';
import 'package:mywall/decos/model/movie_model.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String pubDate;
  final String director;
  final String actor;

  const MovieCard({
    required this.title,
    required this.imgUrl,
    required this.pubDate,
    required this.director,
    required this.actor,
    Key? key,
  }) : super(key: key);

  factory MovieCard.fromModel({
    required MovieDetailModel model,
  }) {
    return MovieCard(
      title: model.title,
      imgUrl: model.image,
      pubDate: model.pubDate,
      director: model.director,
      actor: model.actor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: imgUrl=="" ?  null : Row(
          children: [
            Image.network(
              imgUrl,
              height: 200,
              width: 150,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(title != "")
                    Text(title),
                  if(pubDate != "")
                    Text(pubDate),
                  if(director != "")
                    Text(director),
                  if(actor != "")
                    Text(
                      actor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
