import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_area_app/tools/requests.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
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
  CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  String mapTheme = '';
  Set<Marker> markers = Set();
  Map<String, BitmapDescriptor> markerIcons = {};
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  void initMarkers(data){
    final Set<Marker> static_markers = Set();
    for(var item in data){
      static_markers.add(Marker( //add second marker
          markerId: MarkerId(item['lat'].toString()),
          position: LatLng(item['lat'], item['lon']),
          onTap:(){
            _customInfoWindowController.addInfoWindow!(
              Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black87
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(item['media']['file'] != null ? "https://safe-area.com.ua${item['media']['file']}" : "https://safe-area.com.ua/static/img/no-image.webp"),
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                    Text(item['desc_short']),
                    ElevatedButton(onPressed: (){context.read<GeneralData>().toggleSingleView();},
                        child: Icon(
                          Icons.expand_more,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              LatLng(item['lat'], item['lon'])
            );
          },
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
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
        'assets/red.png')
        .then((d) {
      markerIcons["murder"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
        'assets/blue.png')
        .then((d) {
      markerIcons["accident"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
        'assets/green.png')
        .then((d) {
      markerIcons["shooting"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
        'assets/okean.png')
        .then((d) {
      markerIcons["theft"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
        'assets/white.png')
        .then((d) {
      markerIcons["other"] = d;
    });
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(24, 24)),
        'assets/yellow.png')
        .then((d) {
      markerIcons["fight"] = d;
    });
  }

  void updateEvents(){
    var coord = context.read<GeneralData>().getCoord;
    var timeRanges = context.read<GeneralData>().dateRange;
    var types = context.read<GeneralData>().typeSituationChecked;
    final String start = formatter.format(timeRanges.start);
    final String end = formatter.format(timeRanges.end);
    types.removeWhere((key, value) => value == false);
    var keys = "";
    for(var key in types.keys){
      keys += "$key|";
    }
    if (keys != null && keys.length > 0) {
      keys = keys.substring(0, keys.length - 1);
    }
    getEvents(
        coord[0].toString(), coord[1].toString(), coord[2].toInt().toString(),
        start, end, keys)
        .then((value) {
      final data = json.decode(value);
      context.read<GeneralData>().updateEvents(data);
      initMarkers(data);
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            markers: markers,
            onCameraMove: (CameraPosition){
              // print("${CameraPosition.zoom} ${CameraPosition.target.latitude} ${CameraPosition.target.longitude}");
              _customInfoWindowController.onCameraMove!();
              context.read<GeneralData>().updateCoord(CameraPosition.target.latitude,
                  CameraPosition.target.longitude, CameraPosition.zoom);
              updateEvents();
            },
            onTap: (position){
              _customInfoWindowController.hideInfoWindow!();
            },
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(mapTheme);
                _customInfoWindowController.googleMapController = controller;
              // controller.mapId = "e2791fb2ba5aee41";
              _controller.complete(controller);
            },
          ),
          CustomInfoWindow(
            height: 200,
              width: 150,
              offset: 35,
              controller: _customInfoWindowController
          ),
          if(context.watch<GeneralData>().updateButtonDisplay)...[
            Positioned(
                bottom: 30,
                left: size.width/2 - 50,
                child: GestureDetector(
                  onTap: (){
                    updateEvents();
                    context.read<GeneralData>().toggleUpdateButtonDisplay();
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white70,
                      boxShadow: [
                        BoxShadow(color: Colors.cyanAccent, spreadRadius: 4,blurRadius: 7,
                            offset: Offset(0, 0)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, color: Colors.black),
                        SizedBox(width: 10),
                        Text("Update", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        ))
                      ],
                    ),
                  ),
                )
            )
          ]
        ],
      ),
    );
  }
}