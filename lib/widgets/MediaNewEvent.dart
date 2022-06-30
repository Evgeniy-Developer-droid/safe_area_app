import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:safe_area_app/tools/requests.dart';

class MediaNewEvent extends StatefulWidget {
  const MediaNewEvent({Key? key}) : super(key: key);

  @override
  State<MediaNewEvent> createState() => _MediaNewEventState();
}

class _MediaNewEventState extends State<MediaNewEvent> {
  bool _needsScroll = false;
  List media_ids = [];
  List allMedia = [];
  final ScrollController _controller = ScrollController();


  void _scrollToLast() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void parseResponse(String value){
    final body = json.decode(value);
    setState((){
      media_ids.add(body['id']);
      allMedia.add(body);
      _needsScroll = true;
    });
  }

  void updateAfterDelete(int id){
    setState((){
      media_ids.remove(id);
      allMedia.removeWhere((element) => element['id'] == id);
      _needsScroll = true;
    });
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

            Container(
              height: 150,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.black54
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                controller: _controller,
                children: [
                  for(var item in allMedia) Container(
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
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50), // NEW
                ),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'png', 'gif', 'jpeg', '3gp', 'mp4', 'webm']
                  );
                  if(result == null) return;
                  final file = result.files.first;
                  final extensions = ['jpg', 'png', 'gif', 'jpeg'];
                  String typeOfMedia = "video";
                  if(extensions.contains(file.extension)){
                    typeOfMedia = "image";
                  }
                  uploadMedia(file.path, typeOfMedia).then((String value) => parseResponse(value));
                },
                child: const Text(
                  'Select media',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            )
          ],
        )
    );
  }
}
