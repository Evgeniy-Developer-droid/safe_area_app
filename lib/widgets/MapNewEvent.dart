import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../tools/NewEventData.dart';

class MapNewEvent extends StatefulWidget {
  const MapNewEvent({Key? key}) : super(key: key);

  @override
  State<MapNewEvent> createState() => _MapNewEventState();
}

class _MapNewEventState extends State<MapNewEvent> {
  Completer<GoogleMapController> _controller = Completer();
  String mapTheme = '';

  final Set<Marker> _markers = {};

  @override
  void initState(){
    super.initState();
    DefaultAssetBundle.of(context).loadString('assets/dark_theme_map.json').then((value){
      mapTheme = value;
    });
  }

  void _onAddMarkerButtonPressed(LatLng latlang) {
    context.read<NewEventData>().changeCoord(latlang.latitude, latlang.longitude);
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId("1234"),
        position: latlang,
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    List initialCoord = context.watch<NewEventData>().getLatLngNewEvent;
    CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(initialCoord[0], initialCoord[1]),
      zoom: 5,
    );
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(mapTheme);
          _controller.complete(controller);
        },
        onTap: (latlang){
          if(_markers.length>=1)
          {
            _markers.clear();
          }

          _onAddMarkerButtonPressed(latlang);
        },
        markers: _markers,
      ),
    );
  }
}
