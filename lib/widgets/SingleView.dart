
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/widgets/ImageView.dart';
import 'package:safe_area_app/widgets/Video.dart';
import 'package:video_player/video_player.dart';

import '../tools/GeneralData.dart';

class SingleView extends StatefulWidget {
  const SingleView({
    Key? key,
  }) : super(key: key);

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> with SingleTickerProviderStateMixin<SingleView>{
  bool opened = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnimatedPositioned(
      top: context.watch<GeneralData>().SingleViewOpened ? 0 : -size.height,
      bottom: context.watch<GeneralData>().SingleViewOpened ? 0 : size.height,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      child: SafeArea(
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
                    ElevatedButton(onPressed: (){context.read<GeneralData>().toggleSingleView();}, child: Icon(Icons.close, color: Colors.white,)),
                    Text("Murder", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.red
                      )
                    ),
                    Row(
                      children: [
                        Icon(Icons.visibility, color: Colors.white,),
                        SizedBox(width: 10,),
                        Text('3')
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 210,
                padding: EdgeInsets.all(5),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ImageView(),
                    ImageView(),
                    ImageView(),
                  ],
                ),
              ),
              Container(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Video(
                      videoPlayerController: VideoPlayerController.network('https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4'),
                      looping: true,
                    ),
                    Video(
                      videoPlayerController: VideoPlayerController.network('https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4'),
                      looping: true,
                    ),
                    Video(
                      videoPlayerController: VideoPlayerController.network('https://assets.mixkit.co/videos/preview/mixkit-spinning-around-the-earth-29351-large.mp4'),
                      looping: true,
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                  "Lorem Ipsum - это текст-, часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной  для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для  Lorem Ipsum - это текст-, часто используемый в печати и вэб-дизайне. Lorem Ipsum является стандартной  для текстов на латинице с начала XVI века. В то время некий безымянный печатник создал большую коллекцию размеров и форм шрифтов, используя Lorem Ipsum для  распечатки образцов. Lorem Ipsum не только успешно пережил без заметных изменений пять веков, но и перешагнул в электронный дизайн. Его популяризации в новое время послужили публикация листов Letraset с образцами Lorem Ipsum в 60-х годах и, в более недавнее время, программы электронной вёрстки типа Aldus PageMaker, в шаблонах которых используется Lorem Ipsum.",
                  style: TextStyle(
                      fontSize: 17
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}