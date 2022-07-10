import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  final bool looping;

  const Video({
    Key? key,
    required this.videoPlayerController,
    required this.looping
  }) : super(key: key);

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late ChewieController _chewieController;

  @override
  void initState(){
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.videoPlayerController,
      aspectRatio: 16/9,
      autoInitialize: true,
      looping: widget.looping,
      errorBuilder: (context, errorMessage){
          return Center(
            child: Text(
              errorMessage,
              style: TextStyle(color: Colors.white),
            ),
          );
      }
    );
  }

  @override
  void dispose(){
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      // padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.white70,
        border: Border.all(color: Color(0x67FFFFFF))
      ),
      child: Chewie(
        controller: _chewieController,
      ),
    );
  }
}
