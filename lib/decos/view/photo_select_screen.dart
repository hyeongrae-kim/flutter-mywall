import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mywall/common/layout/default_layout.dart';
import 'package:mywall/decos/model/album.dart';
import 'package:mywall/decos/view/photo_deco_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoSelectScreen extends StatefulWidget {
  const PhotoSelectScreen({Key? key}) : super(key: key);

  @override
  State<PhotoSelectScreen> createState() => _PhotoSelectScreenState();
}

class _PhotoSelectScreenState extends State<PhotoSelectScreen> {
  List<AssetPathEntity>? _paths; // 모든 파일 정보
  List<Album> _albums = []; // 드롭다운 앨범 목록
  List<AssetEntity> _previews = [];
  late List<AssetEntity> _images; // 앨범의 이미지 목록
  int _currentPage = 0; // 현재 페이지
  late Album _currentAlbum; // 드롭다운 선택된 앨범

  bool _isAlbumList = false; // 앨범 목록 보여주는 화면

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 카메라 불러오기
  void _loadCamera() async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    // if (file != null) {
    //   final item = SelectedImage(entity: null, file: file);
    //   onTap(item);
    // }
  }

  // 초기에 권한 확인한기
  Future<void> checkPermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (ps.isAuth) {
      // 권한 수락 -> 앨범 불러오기
      await getAlbum();
    } else {
      // 권한 거절 -> 권한 설정 페이지 이동
      await PhotoManager.openSetting();
    }
  }

  // 모든 파일 정보 불러오기. _albums에 모든 파일 저장
  // AssetPathEntity에서 name => path name(경로명)
  // album -> 사진이 아니라 앨범 전체
  Future<void> getAlbum() async {
    _paths = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );
    for (int i = 0; i < _paths!.length; i++) {
      List<AssetEntity> firstImageList =
          await _paths![i].getAssetListPaged(page: 0, size: 1);
      if (firstImageList.isEmpty) {
        _previews.add(
            const AssetEntity(id: 'Empty', typeInt: 0, width: 0, height: 0));
      } else {
        _previews.add(firstImageList[0]);
      }
    }

    _albums = _paths!.map((e) {
      return Album(
        id: e.id,
        name: e.isAll ? '모든 사진' : e.name,
      );
    }).toList();

    await getPhotos(_albums[0], albumChange: true);
  }

  // ** 앨범의 이미지 목록을 불러오는 함수
  // 사진 선택 페이지에 처음 진입했을 때
  // 드롭다운으로 다른 앨범을 선택하였을 때
  // 스크롤 끝에 도달 하여서 사진 로딩 할 때
  Future<void> getPhotos(
    Album album, {
    bool albumChange = false,
  }) async {
    _currentAlbum = album;
    albumChange ? _currentPage = 0 : _currentPage++;

    final loadImages = await _paths!
        .singleWhere((AssetPathEntity e) => e.id == album.id)
        .getAssetListPaged(
          page: _currentPage,
          size: 20,
        );

    // 앨범마다 첫 페이지의 첫번째 항목에는 카메라 버튼을 넣어줘야 한다.
    // 이를 위한 더미 카메라 세팅
    if (_currentPage == 0) {
      const dummy = AssetEntity(id: 'camera', typeInt: 0, width: 0, height: 0);
      loadImages.insert(0, dummy);
    }

    setState(() {
      if (albumChange) {
        _images = loadImages;
      } else {
        _images.addAll(loadImages);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      // 스크롤 시 이벤트 발생하는 부분
      onNotification: (ScrollNotification scroll) {
        // scroll.metrics.pixels -> 현재 스크롤 위치
        // scroll.metrics.maxScrollExtent -> 스크롤 최대 위치
        // scrollPosition -> 스크롤 끝까지 = 1, 현재위치와 최대위치의 비율로 현재 어느정도 와있는지 알 수 있음
        final scrollPosition =
            scroll.metrics.pixels / scroll.metrics.maxScrollExtent;
        // 스크롤이 70%정도 되었으면 다음 페이지의 이미지 불러오기
        if (scrollPosition > 0.7) getPhotos(_currentAlbum);

        return false;
      },
      child: DefaultLayout(
        title: 'PhotoSelectScreen',
        renderAppBar: AppBar(
          // const Color(0xff2c2c2c)
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              height: 0.5,
            ),
          ),
          title: _albums.isEmpty
              ? null
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isAlbumList = !_isAlbumList;
                    });
                  },
                  child: FittedBox(
                    // 가운데 정렬 해결하기 위해 FittedBox 사용
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentAlbum.name,
                          style: const TextStyle(
                              fontSize: 16.0, color: Colors.black),
                        ),
                        _isAlbumList
                            ? const Icon(
                                Icons.arrow_drop_up,
                                color: Colors.grey,
                                size: 15,
                              )
                            : const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 15,
                              ),
                      ],
                    ),
                  ),
                ),
          leading: IconButton(
            color: Colors.white,
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            iconSize: 16.0,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: _paths == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _isAlbumList
                ? Container(
                    child: ListView.separated(
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            getPhotos(
                                _albums.firstWhere(
                                    (e) => e.name == _albums[index].name),
                                albumChange: true);
                            setState(() {
                              _isAlbumList = !_isAlbumList;
                            });
                          },
                          child: Padding(
                            padding: index == 0
                                ? const EdgeInsets.only(
                                    top: 8.0,
                                    left: 12.0,
                                    right: 12.0,
                                  )
                                : const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                _previews[index].id != 'Empty'
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        child: AssetEntityImage(
                                          _previews[index],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        width: 50,
                                        height: 50,
                                        color: Colors.black,
                                      ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _albums[index].name,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 12.0),
                          child: Divider(
                            thickness: 0.8,
                            color: Colors.black.withOpacity(0.15),
                          ),
                        );
                      },
                      itemCount: _albums.length,
                    ),
                  )
                : GridView(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    children: _images.map((AssetEntity e) {
                      if (e.id == 'camera') {
                        return _cameraButton();
                      } else {
                        return _gridPhotoItem(e, _images.indexOf(e) + 1);
                      }
                    }).toList(),
                  ),
      ),
    );
  }

  Widget _gridPhotoItem(AssetEntity e, int idx) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return PhotoDecoScreen(e: e);
            },
          ),
        );
      },
      child: Padding(
        padding: idx % 3 == 0
            ? const EdgeInsets.only(
                left: 1.0,
                bottom: 2.0,
              )
            : (idx - 1) % 3 == 0
                ? const EdgeInsets.only(
                    right: 1.0,
                    bottom: 2.0,
                  )
                : const EdgeInsets.only(
                    right: 1.0,
                    left: 1.0,
                    bottom: 2.0,
                  ),
        child: AssetEntityImage(
          e,
          isOriginal: false,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _cameraButton() {
    return GestureDetector(
      onTap: () {
        _loadCamera();
      },
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 2.0,
          right: 1.0,
        ),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          child: const Icon(
            CupertinoIcons.camera,
            color: Colors.white,
            size: 40,
          ),
        ),
      ),
    );
  }
}
