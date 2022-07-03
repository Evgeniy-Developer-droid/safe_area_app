
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SingleView extends StatefulWidget {
  final bool isSingleViewOpened;
  const SingleView({
        Key? key,
        required this.isSingleViewOpened
  }) : super(key: key);

  @override
  State<SingleView> createState() => _SingleViewState();
}

class _SingleViewState extends State<SingleView> with SingleTickerProviderStateMixin<SingleView>{
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
    if(widget.isSingleViewOpened){
      onIconPressed();
    }
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync){
        bool d = isSideBarOpenedAsync.data ?? false;
        return AnimatedPositioned(
            duration: _animationDuration,
            top: d ? 0 : screenHeight,
            bottom: d ? 0 : -screenHeight,
            left: 0,
            right: 0,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      color: Color(0xFF464646),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: (){onIconPressed();},
                            child: Container(
                              margin: EdgeInsets.only(top: 100),
                              width: 100,
                              height: 100,
                              color: Colors.amberAccent,
                            ),
                          ),
                          Container(
                            height: screenHeight - 300,
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
                )
              ],
            ));
      },
    );
  }
}