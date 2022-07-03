import 'package:flutter/material.dart';
import 'package:safe_area_app/widgets/FilterEvent.dart';
import 'package:safe_area_app/widgets/ListEvent.dart';
import 'package:safe_area_app/widgets/SingleView.dart';

import '../widgets/MapGeneral.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSingleViewOpened = false;

  void openSingleView(){
    setState((){
      isSingleViewOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapGeneral(),
        ListEvent(toggleSingleView: openSingleView,),
        FilterEvent(),
        SingleView(isSingleViewOpened: isSingleViewOpened),
      ],
    );
  }
}
