import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GalleryMode _galleryMode = GalleryMode.image;
  GlobalKey globalKey;
  @override
  void initState() {
    super.initState();
    globalKey = GlobalKey();
  }

  List<Media> _listImagePaths = List();
  String dataImagePath = "";

  Future<void> selectImages() async {
    try {
      _galleryMode = GalleryMode.image;
      _listImagePaths = await ImagePickers.pickerPaths(
        galleryMode: _galleryMode,
        showGif: true,
        selectCount: 5,
        showCamera: true,
        compressSize: 500,
      );
      _listImagePaths.forEach((media) {
        print(media.path.toString());
      });
      setState(() {});
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.white,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Images'),
          ),
          body: Column(
            children: <Widget>[
              GridView.builder(
                  itemCount:
                      _listImagePaths == null ? 0 : _listImagePaths.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 20.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 1.0),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        ImagePickers.previewImagesByMedia(
                            _listImagePaths, index);
                      },
                      child: Image.file(
                        File(
                          _listImagePaths[index].path,
                        ),
                        fit: BoxFit.cover,
                      ),
                    );
                  }),
              RaisedButton(
                onPressed: () {
                  selectImages();
                },
                child: Text("Select Images"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
