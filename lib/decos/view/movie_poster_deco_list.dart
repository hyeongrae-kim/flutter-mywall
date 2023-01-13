import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/component/movie_card.dart';
import 'package:mywall/decos/model/movie_model.dart';

class MoviePosterDecoList extends StatefulWidget {
  const MoviePosterDecoList({Key? key}) : super(key: key);

  @override
  State<MoviePosterDecoList> createState() => _MoviePosterDecoListState();
}

class _MoviePosterDecoListState extends State<MoviePosterDecoList> {
  String? searchKeyword;
  List<MovieDetailModel>? movies;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 남은 영역 누르면 포커스 잃도록(키보드를 닫게 하기 위함)
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: DefaultLayout(
        title: 'Movie Posters',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffebebeb),
                    hintText: 'title or director name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(28.0)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  // onSubmitted -> 완료버튼 눌러야 업데이트, onChanged->글자 타이핑 될때마다 업데이트
                  onSubmitted: (String text) async {
                    final resp = await Dio().get(
                      'https://openapi.naver.com/v1/search/movie.json',
                      options: Options(
                        headers: {
                          "X-Naver-Client-Id": "A1INNWBXhoXGH5kAbdby",
                          "X-Naver-Client-Secret": "gzWqn_oF17",
                        },
                      ),
                      queryParameters: {"query": text},
                    );
                    print(resp.data);
                    final result = MovieModel.fromJson(resp.data);

                    setState(() {
                      searchKeyword = text;
                      movies = result.items;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            movies == null
                ? const Expanded(
                    child: Center(
                      child: Text('영화 제목 또는 감독을 검색해보세요!'),
                    ),
                  )
                : Expanded(
                  child: ListView.separated(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        final movie = movies![index];
                        return MovieCard.fromModel(model: movie);
                      },
                      separatorBuilder: (_, index) {

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child:  movies![index].image=="" ? null : const Divider(thickness: 1),
                        );
                      },
                      itemCount: movies!.length,
                    ),
                ),
          ],
        ),
      ),
    );
  }
}
