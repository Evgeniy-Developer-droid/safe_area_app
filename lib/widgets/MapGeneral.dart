import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            context.read<GeneralData>().changeViewEventId(item['id']);
            _customInfoWindowController.addInfoWindow!(
              Container(
                width: 160,
                height: 220,
                padding: EdgeInsets.all(10),
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
                    ElevatedButton(onPressed: (){
                      context.read<GeneralData>().toggleSingleView();
                      },
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

  Future<void> initMarkersImages() async {
    Uint8List markerIcon1 = await getBytesFromAsset('assets/red.png', 70);
    Uint8List markerIcon2 = await getBytesFromAsset('assets/blue.png', 70);
    Uint8List markerIcon3 = await getBytesFromAsset('assets/green.png', 70);
    Uint8List markerIcon4 = await getBytesFromAsset('assets/white.png', 70);
    Uint8List markerIcon5 = await getBytesFromAsset('assets/okean.png', 70);
    Uint8List markerIcon6 = await getBytesFromAsset('assets/yellow.png', 70);
    markerIcons["murder"] = BitmapDescriptor.fromBytes(markerIcon1);
    markerIcons["accident"] = BitmapDescriptor.fromBytes(markerIcon2);
    markerIcons["shooting"] = BitmapDescriptor.fromBytes(markerIcon3);
    markerIcons["other"] = BitmapDescriptor.fromBytes(markerIcon4);
    markerIcons["theft"] = BitmapDescriptor.fromBytes(markerIcon5);
    markerIcons["fight"] = BitmapDescriptor.fromBytes(markerIcon6);
  }


  @override
  initState(){
    super.initState();
    initMarkersImages();
    DefaultAssetBundle.of(context).loadString('assets/dark_theme_map.json').then((value){
      mapTheme = value;
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
              _controller.complete(controller);
            },
          ),
          CustomInfoWindow(
            height: 220,
              width: 160,
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
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}