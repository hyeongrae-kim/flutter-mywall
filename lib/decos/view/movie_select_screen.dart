import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/component/movie_card.dart';
import 'package:mywall/decos/model/movie_images_list_model.dart';
import 'package:mywall/decos/model/movie_list_model.dart';
import 'package:mywall/decos/view/movie_photos_screen.dart';

class MovieSelectScreen extends StatefulWidget {
  const MovieSelectScreen({Key? key}) : super(key: key);

  @override
  State<MovieSelectScreen> createState() => _MovieSelectScreenState();
}

class _MovieSelectScreenState extends State<MovieSelectScreen> {
  String? searchKeyword;
  List<MovieModel>? movies;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 남은 영역 누르면 포커스 잃도록(키보드를 닫게 하기 위함)
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: DefaultLayout(
        title: 'Search Movies',
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color(0xffebebeb),
                    hintText: 'search movie titles',
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
                      'https://api.themoviedb.org/3/search/movie',
                      queryParameters: {
                        "api_key": "b993c9008004b1408e494698fc232c86",
                        "query": text,
                      },
                    );
                    // print(resp.data);
                    final result = MovieListModel.fromJson(resp.data);
                    setState(() {
                      searchKeyword = text;
                      movies = result.results;
                      // poster_path가 없는 영화들 걸러주기
                      movies = [
                        for (final m in movies!)
                          if (m.poster_path != null) m,
                      ];
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            movies == null
                ? const Expanded(
                    child: Center(
                      child: Text('영화를 검색해보세요!'),
                    ),
                  )
                : movies!.isNotEmpty
                    ? Expanded(
                        child: GridView.builder(
                          itemCount: movies!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, //1 개의 행에 보여줄 item 개수
                            // mainAxisSpacing: 8, //수평 Padding
                            crossAxisSpacing: 1, //수직 Padding
                            childAspectRatio: 5 / 8, //item 의 가로 1, 세로 2 의 비율
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            final movie = movies![index];
                            return InkWell(
                              onTap: () async {
                                print(movie.id);
                                final resp = await Dio().get(
                                  'https://api.themoviedb.org/3/movie/${movie.id}/images',
                                  queryParameters: {
                                    "api_key": "b993c9008004b1408e494698fc232c86",
                                  },
                                );
                                final images = MovieImagesListModel.fromJson(resp.data);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return MoviePhotosScreen(model: images);
                                    },
                                  ),
                                );
                              },
                              child: MovieCard.fromModel(model: movie),
                            );
                          },
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text('검색 결과를 찾지 못했습니다.'),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
