import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapNewEvent extends StatefulWidget {
  const MapNewEvent({Key? key}) : super(key: key);

  @override
  State<MapNewEvent> createState() => _MapNewEventState();
}

class _MapNewEventState extends State<MapNewEvent> {
  Completer<GoogleMapController> _controller = Completer();
  String mapTheme = '';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState(){
    super.initState();
    DefaultAssetBundle.of(context).loadString('assets/dark_theme_map.json').then((value){
      mapTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(mapTheme);
          // controller.mapId = "e2791fb2ba5aee41";
          _controller.complete(controller);
        },
      ),
    );
  }
}
