import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

// ignore: must_be_immutable
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
