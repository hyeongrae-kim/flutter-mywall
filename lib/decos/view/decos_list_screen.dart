import 'package:flutter/material.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/view/background_color_list.dart';
import 'package:mywall/decos/view/background_wall_list.dart';
import 'package:mywall/decos/view/movie_poster_deco_list.dart';
import 'package:mywall/decos/view/photo_select_screen.dart';

class DecorateList extends StatelessWidget {
  const DecorateList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: 'DecoList',
      body: ListView(
        children: [
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return BackgroundColorList();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('Background Color'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return BackgroundWallList();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('Background Wall'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MoviePosterDecoList();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('Movie Posters'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MoviePosterDecoList();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('Music'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return PhotoSelectScreen();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('Photos'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MoviePosterDecoList();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('Text'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return MoviePosterDecoList();
                  },
                ),
              );
            },
            child: ListTile(
              title: Text('URL Buttons'),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}