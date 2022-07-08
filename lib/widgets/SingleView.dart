
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:safe_area_app/tools/NewEventData.dart';

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
      child: Container(
        width: size.width,
        height: size.height,
        color: Colors.white38,
        child: Row(
          children: [
            ElevatedButton(
              onPressed: (){
                context.read<GeneralData>().toggleSingleView();
              },
              child: Text("push"),
            )
          ],
        ),
      ),
    );
  }
}