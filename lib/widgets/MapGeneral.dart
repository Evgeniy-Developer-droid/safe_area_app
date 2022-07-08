import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/tools/requests.dart';
import 'dart:convert';
import '../tools/GeneralData.dart';

class MapGeneral extends StatefulWidget {
  MapGeneral({
    Key? key,
  }) : super(key: key);

  @override
  State<MapGeneral> createState() => MapGeneralState();
}

class MapGeneralState extends State<MapGeneral> {
  Completer<GoogleMapController> _controller = Completer();
  String mapTheme = '';
  Set<Marker> markers = Set();
  Map<String, BitmapDescriptor> markerIcons = {};

  void initMarkers(data){
    final Set<Marker> static_markers = Set();
    for(var item in data){
      print(markerIcons[item['type_of_situation']]);
      static_markers.add(Marker( //add second marker
        markerId: MarkerId(item['lat'].toString()),
        position: LatLng(item['lat'], item['lon']), //position of marker
        infoWindow: InfoWindow( //popup info
          title: 'My Custom Title ',
          snippet: 'My Custom Subtitle',
        ),
        icon: markerIcons[item['type_of_situation']] ?? BitmapDescriptor.defaultMarker //Icon for Marker
      ));
    }
    setState((){
      markers = static_markers;
    });
  }

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(49.76, 21.13),
    zoom: 4,
  );


  @override
  initState() {
    super.initState();
    DefaultAssetBundle.of(context).loadString('assets/dark_theme_map.json').then((value){
      mapTheme = value;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/red.png')
        .then((d) {
      markerIcons["murder"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/blue.png')
        .then((d) {
      markerIcons["accident"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/green.png')
        .then((d) {
      markerIcons["shooting"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/okean.png')
        .then((d) {
      markerIcons["theft"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/white.png')
        .then((d) {
      markerIcons["other"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(12, 12)),
        'assets/yellow.png')
        .then((d) {
      markerIcons["fight"] = d;
    });
  }

  void updateEvents(){
    var coord = context.read<GeneralData>().getCoord;
    var timeRanges = context.read<GeneralData>().getTimeRange;
    // print("from ${coord}");
    // print(markerIcons);
    getEvents(
        coord[0].toString(), coord[1].toString(), coord[2].toInt().toString(),
        timeRanges[0], timeRanges[1])
        .then((value) {
      final data = json.decode(value);
      context.read<GeneralData>().updateEvents(data);
      initMarkers(data);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        markers: markers,
        onCameraMove: (CameraPosition){
          // print("${CameraPosition.zoom} ${CameraPosition.target.latitude} ${CameraPosition.target.longitude}");
          context.read<GeneralData>().updateCoord(CameraPosition.target.latitude,
              CameraPosition.target.longitude, CameraPosition.zoom);
              updateEvents();
        },
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