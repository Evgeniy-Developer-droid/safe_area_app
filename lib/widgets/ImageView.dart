import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  const ImageView({Key? key}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: 250,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: NetworkImage("https://safe-area.com.ua/static/img/video-logo.webp"),
              fit: BoxFit.cover,
            ),
            boxShadow: const [
              BoxShadow(color: Colors.white24, spreadRadius: 2,blurRadius: 5,
                  offset: Offset(0, 0)),
            ]
        )
    );
  }
}
