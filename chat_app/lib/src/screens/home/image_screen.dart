import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:photo_view/photo_view.dart';

class ImageScreen extends StatelessWidget {
  ImageScreen({Key? key, required this.image}) : super(key: key);
  String image;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            // title: Text('Main Screen'),
          ),
          body: PhotoView(
            imageProvider: NetworkImage(
              image,
              // scale: 5,
            ),
          ),
        ),
      ],
    );
  }
}
