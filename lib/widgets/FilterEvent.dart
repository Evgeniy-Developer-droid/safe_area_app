
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safe_area_app/tools/GeneralData.dart';
import 'package:safe_area_app/tools/tools.dart';

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
  DateTimeRange dateRange = DateTimeRange(
      start: DateTime(
          DateTime.now().subtract(const Duration(days:1)).year,
          DateTime.now().subtract(const Duration(days:1)).month,
          DateTime.now().subtract(const Duration(days:1)).day
      ),
      end: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day
      )
  );
  Map<String, bool> values = {
    'murder': false,
    'accident': false,
    'fight': false,
    'theft': false,
    'shooting': false,
    'other': false,
  };
  Map<String, Color> situationColor = {
    'murder': Colors.red,
    'accident': Colors.blueAccent,
    'fight': Colors.amberAccent,
    'theft': Colors.cyanAccent,
    'shooting': Colors.green,
    'other': Colors.white,
  };
  Map<String, Color> situationShadows = {
    'murder': Colors.red.withOpacity(0.5),
    'accident':Colors.blueAccent.withOpacity(0.5),
    'fight': Colors.amberAccent.withOpacity(0.5),
    'theft': Colors.cyanAccent.withOpacity(0.5),
    'shooting': Colors.green.withOpacity(0.5),
    'other': Colors.white.withOpacity(0.5),
  };

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
    final start = dateRange.start;
    final end = dateRange.end;
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
                      color: Color(0xFF252525),
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight - 100,
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                          child: Text("${start.year}/${start.month}/${start.day}"),
                                          onPressed: pickDateRange,
                                        )
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                        child: ElevatedButton(
                                          child: Text("${end.year}/${end.month}/${end.day}"),
                                          onPressed: pickDateRange,
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  children: values.keys.map((String key) {
                                    return CheckboxListTile(
                                      title: Wrap(
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          Container(
                                            height: 10,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: situationColor[key],
                                              boxShadow: [
                                                BoxShadow(
                                                  color: situationShadows[key] ?? Colors.white.withOpacity(0.5),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 0), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width:20,
                                          ),
                                          Text(key.toCapitalized())
                                        ],
                                      ),
                                      value: values[key],
                                      onChanged: (bool? value) {
                                        context.read<GeneralData>().updateTypeSituation(key, value);
                                        if(!context.read<GeneralData>().updateButtonDisplay){
                                          context.read<GeneralData>().toggleUpdateButtonDisplay();
                                        }
                                        setState(() {
                                          values[key] = value ?? false;
                                        });
                                      },
                                    );
                                  }).toList(),
                                )
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
                        color: Color(0xFF252525),
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

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100)
    );

    if(newDateRange == null) return; // pressed X
    context.read<GeneralData>().changeDateRange(newDateRange);
    if(!context.read<GeneralData>().updateButtonDisplay){
      context.read<GeneralData>().toggleUpdateButtonDisplay();
    }
    setState(() => dateRange = newDateRange);
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