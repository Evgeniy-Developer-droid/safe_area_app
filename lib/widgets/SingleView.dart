
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/tools/requests.dart';
import 'package:safe_area_app/widgets/ImageView.dart';
import 'package:safe_area_app/widgets/Video.dart';
import 'package:video_player/video_player.dart';

import '../tools/GeneralData.dart';
import 'package:safe_area_app/tools/tools.dart';

class SingleView extends StatefulWidget {
  const SingleView({
    Key? key,
  }) : super(key: key);

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> with SingleTickerProviderStateMixin<SingleView>{
  bool opened = true;
  Map<String, Color> situationColor = {
    'murder': Colors.red,
    'accident': Colors.blueAccent,
    'fight': Colors.amberAccent,
    'theft': Colors.cyanAccent,
    'shooting': Colors.green,
    'other': Colors.white,
  };
  Map data = {};

  void getData(id){
    getEvent(id)
        .then((value){
        final body = json.decode(value);
        // print(body);
        setState((){
          data = body;
        });
    });
  }

  @override
  void initState(){
    super.initState();
    getData(context.read<GeneralData>().viewEventId);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var images = [];
    var videos = [];
    if(data['media'] != null){
      images = data['media'].where((e) => e['extension'] == 'image').toList();
      videos = data['media'].where((e) => e['extension'] == 'video').toList();
    }
    // print(data);
    // print(context.read<GeneralData>().viewEventId);

    return SafeArea(
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.black,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(onPressed: (){
                    context.read<GeneralData>().toggleSingleView();
                  }, child: Icon(Icons.close, color: Colors.white,)),
                  Text(data['type_of_situation'] != null ? data['type_of_situation'] : "", style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: situationColor[data['type_of_situation']] ?? Colors.red
                  )
                  ),
                  Row(
                    children: [
                      const Icon(Icons.visibility, color: Color(0xFF0B8F00),),
                      const SizedBox(width: 10,),
                      Text(data['viewed'] != null ? data['viewed'].toString() : "0")
                    ],
                  )
                ],
              ),
            ),
            if(data.keys.isEmpty)...[
              Container(
                height: 100,
                child: JumpingDotsProgressIndicator(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
              ),
            ] else ...[
              if(images.isNotEmpty)...[
                Container(
                  height: 210,
                  padding: EdgeInsets.all(5),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for(var i in images)GestureDetector(
                        onTap: (){
                          context.read<GeneralData>().changeImgFullScreen("https://safe-area.com.ua${i['file']}");
                        },
                        child: ImageView(url: "https://safe-area.com.ua${i['file']}",),
                      )
                    ],
                  ),
                )
              ],
              if(videos.isNotEmpty)...[
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for(var j in videos)Video(
                        videoPlayerController: VideoPlayerController.network("https://safe-area.com.ua${j['file']}"),
                        looping: true,
                      ),
                    ],
                  ),
                ),
              ],
              Container(
                child: Text(
                  data['description'] ?? "",
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}