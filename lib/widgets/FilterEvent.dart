
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class FilterEvent extends StatefulWidget {
  const FilterEvent({Key? key}) : super(key: key);

  @override
  State<FilterEvent> createState() => _FilterEventState();
}

class _FilterEventState extends State<FilterEvent> with SingleTickerProviderStateMixin<FilterEvent>{
  late AnimationController _animationController;
  final bool isOpenedListView = false;
  final _animationDuration = const Duration(milliseconds: 500);
  late StreamController<bool> isSidebarOpenedStreamController;
  late Stream<bool> isSidebarOpenedStream;
  late StreamSink<bool> isSidebarOpenedSink;

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController.sink;
  }

  @override
  void dispose(){
    _animationController.dispose();
    isSidebarOpenedStreamController.close();
    isSidebarOpenedSink.close();
    super.dispose();
  }

  void onIconPressed(){
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if(isAnimationCompleted){
      isSidebarOpenedSink.add(false);
      _animationController.reverse();
    }else{
      isSidebarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync){
        bool d = isSideBarOpenedAsync.data ?? false;
        return AnimatedPositioned(
            duration: _animationDuration,
            top: 0,
            bottom: 0,
            left: d ? 0 : -screenWidth,
            right: d ? 0 : screenWidth - 40,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      color: Color(0xFF464646),
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight - 100,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                ),
                Align(
                  alignment: Alignment(0, -0.3),
                  child: GestureDetector(
                    onTap: (){
                      onIconPressed();
                    },
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        width: 35,
                        height: 110,
                        color: Color(0xFF464646),
                        alignment: Alignment.center,
                        child: AnimatedIcon(
                          icon: AnimatedIcons.search_ellipsis,
                          progress: _animationController.view,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}