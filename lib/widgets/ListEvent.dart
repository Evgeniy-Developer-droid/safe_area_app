
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class ListEvent extends StatefulWidget {
  const ListEvent({Key? key}) : super(key: key);

  @override
  State<ListEvent> createState() => _ListEventState();
}

class _ListEventState extends State<ListEvent> with SingleTickerProviderStateMixin<ListEvent>{
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
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync){
        bool d = isSideBarOpenedAsync.data ?? false;
        return AnimatedPositioned(
            duration: _animationDuration,
            top: 0,
            bottom: 0,
            left: d ? 0 : 0,
            right: d ? 0 : screenWidth - 40,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      color: Colors.blue,
                    )
                ),
                Align(
                  alignment: Alignment(0, -0.7),
                  child: GestureDetector(
                    onTap: (){
                      onIconPressed();
                    },
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Colors.blue,
                      alignment: Alignment.center,
                      child: AnimatedIcon(
                        icon: AnimatedIcons.menu_close,
                        progress: _animationController.view,
                        color: Colors.white,
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
