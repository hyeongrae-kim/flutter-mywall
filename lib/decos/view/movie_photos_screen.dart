import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/model/movie_images_list_model.dart';
import 'package:mywall/user/model/wall_element_model.dart';
import 'package:mywall/user/provider/wall_provider.dart';

class MoviePhotosScreen extends ConsumerWidget {
  final MovieImagesListModel model;
  final TextStyle textStyle = const TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.bold,
  );

  const MoviePhotosScreen({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: 'Select Photos',
      body: SafeArea(
        // bottom: false,
        child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 4.0),
                  Text(
                    'Posters',
                    style: textStyle,
                  ),
                  const SizedBox(height: 8.0),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width/5)*2*sqrt(2),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: model.posters.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: (){
                              ref.read(wallElementListProvider.notifier).append(WallElement(
                                movieUrl: 'https://image.tmdb.org/t/p/original/${model.posters[index].file_path}',
                                showEditButtons: false,
                                elementWidth: MediaQuery.of(context).size.width/(1.5),
                                elementPosition: Offset(
                                  MediaQuery.of(context).size.width / 4,
                                  MediaQuery.of(context).size.height / 4,
                                ),
                              ));
                              Navigator.popUntil(context, ModalRoute.withName('/'));
                            },
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w500/${model.posters[index].file_path}',
                              width: (MediaQuery.of(context).size.width/5)*2,
                              height: (MediaQuery.of(context).size.width/5)*2*sqrt(2),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  Text(
                    'BackDrops',
                    style: textStyle,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: model.backdrops.length,
                      itemBuilder: (BuildContext context, int index){
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: GestureDetector(
                            onTap: (){

                              Navigator.popUntil(context, ModalRoute.withName('/'));
                            },
                            child: Image.network(
                              'https://image.tmdb.org/t/p/w1280/${model.backdrops[index].file_path}',
                              width: MediaQuery.of(context).size.width*0.95,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 4.0),
                ],
              ),
            ),
      ),
    );
  }
}
