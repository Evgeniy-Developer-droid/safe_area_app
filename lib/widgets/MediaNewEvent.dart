import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:safe_area_app/tools/requests.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../tools/Data.dart';

class MediaNewEvent extends StatefulWidget {
  const MediaNewEvent({Key? key}) : super(key: key);

  @override
  State<MediaNewEvent> createState() => _MediaNewEventState();
}

class _MediaNewEventState extends State<MediaNewEvent> {
  bool _needsScroll = false;
  final ScrollController _controller = ScrollController();
  bool uploading = false;


  void _scrollToLast() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void parseResponse(String value){
    final body = json.decode(value);
    context.read<Data>().addMedia(body);
    _needsScroll = true;
    setState((){
      uploading = false;
    });
  }

  void updateAfterDelete(int id){
    context.read<Data>().deleteMedia(id);
    _needsScroll = true;
  }

  @override
  Widget build(BuildContext context) {
    if(_needsScroll){
      WidgetsBinding.instance.addPostFrameCallback(
              (_) => _scrollToLast());
      _needsScroll = false;
    }
    return SafeArea(
        child: Column(
          children: [
            if(context.watch<Data>().getAllMediaNewEvent.length != 0)...[
              Container(
                height: 150,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  // color: Colors.black54
                ),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  controller: _controller,
                  children: [
                    for(var item in context.watch<Data>().getAllMediaNewEvent) Container(
                      height: 140,
                      width: 140,
                      margin: EdgeInsets.only(right: 5, left: 5),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item['extension'] == 'image' ? item['file'] : "https://safe-area.com.ua/static/img/video-logo.webp"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              deleteMedia(item['id']);
                              updateAfterDelete(item['id']);
                            },
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white38,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ] else...[
              Container(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("No media", style: TextStyle(
                    color: Colors.white38,
                    fontSize: 23
                  ),)],
                ),
              )
            ],
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () async {
                  setState((){
                    uploading = true;
                  });
                  final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png', 'gif', 'jpeg', '3gp', 'mp4', 'webm']
                  );
                  if(result == null){
                    setState((){
                      uploading = false;
                    });
                    return;
                  }
                  final file = result.files.first;
                  final extensions = ['jpg', 'png', 'gif', 'jpeg'];
                  String typeOfMedia = "video";
                  if(extensions.contains(file.extension)){
                    typeOfMedia = "image";
                  }
                  uploadMedia(file.path, typeOfMedia).then((String value) => parseResponse(value));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(uploading)...[
                      JumpingDotsProgressIndicator(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ]else...[
                      Text(
                        'Select media',
                        style: TextStyle(fontSize: 24),
                      )
                    ]
                  ],
                ),
              ),
            )
          ],
        )
    );
  }
}
