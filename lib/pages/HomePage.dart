import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/tools/GeneralData.dart';
import 'package:safe_area_app/widgets/FilterEvent.dart';
import 'package:safe_area_app/widgets/ListEvent.dart';
import 'package:safe_area_app/widgets/SingleView.dart';

import '../tools/NewEventData.dart';
import '../tools/requests.dart';
import '../widgets/MapGeneral.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GeneralData>(
        create: (context)=>GeneralData(),
      child: Stack(
        children: [
          MapGeneral(),
          ListEvent(),
          FilterEvent(),
          SingleView(),
        ],
      ),
    );
  }
}
