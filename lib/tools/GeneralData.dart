import 'package:flutter/material.dart';

class GeneralData with ChangeNotifier{
  List _events = [];
  var _lat = 49.76;
  var _lng = 21.13;
  var _zoom = 4;
  var _start = "2022-06-01";
  var _end = "2022-07-04";

  List get getAllEvents => _events;
  List get getCoord => [_lat, _lng, _zoom];
  List get getTimeRange => [_start, _end];

  bool SingleViewOpened = false;

  void toggleSingleView(){
    SingleViewOpened = !SingleViewOpened;
    notifyListeners();
  }

  void updateEvents(data){
    _events.clear();
    _events.addAll(data);
    notifyListeners();
  }
  void updateCoord(lat, lng, zoom){
    _lat = lat;
    _lng = lng;
    _zoom = zoom.toInt();
  }
  void updateTimeRange(start, end){
    _start = start;
    _end = end;
  }
}