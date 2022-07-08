import 'dart:ffi';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_area_app/tools/requests.dart';
import 'package:flutter/material.dart';

class NewEventData with ChangeNotifier{

  //new event
  String _descriptionNewEvent = "";
  List _media_idsNewEvent = [];
  List _allMediaNewEvent = [];
  String _typeOfSituationNewEvent = "other";
  var _latNewEvent = 49.76;
  var _lngNewEvent = 21.13;
  //=============

  //getters new event
  List get getLatLngNewEvent => [_latNewEvent, _lngNewEvent];
  List get getAllMediaNewEvent => _allMediaNewEvent;
  List get getmediaIdsNewEvent => _media_idsNewEvent;
  String get getTypeOfSituationNewEvent => _typeOfSituationNewEvent;
  String get getDescriptionNewEvent => _descriptionNewEvent;
  //=================

  //functions new event
  void changeDescription (value){
    _descriptionNewEvent = value;
    notifyListeners();
  }
  void addMedia(data){
    _media_idsNewEvent.add(data['id']);
    _allMediaNewEvent.add(data);
    notifyListeners();
  }
  void deleteMedia(id){
    _media_idsNewEvent.remove(id);
    _allMediaNewEvent.removeWhere((element) => element['id'] == id);
    notifyListeners();
  }
  void changeTypeOfSituation(value){
    _typeOfSituationNewEvent = value;
    notifyListeners();
  }
  void changeCoord(lat, lng){
    _latNewEvent = lat;
    _lngNewEvent = lng;
    notifyListeners();
  }
  Future<bool> createNewEvent() async {
    int result = await createEvent(
        _latNewEvent,
        _lngNewEvent,
        _typeOfSituationNewEvent,
        _media_idsNewEvent,
        _descriptionNewEvent
    );
    _descriptionNewEvent = "";
    _typeOfSituationNewEvent = "other";
    _media_idsNewEvent = [];
    _allMediaNewEvent = [];
    if(result == 201){
      return true;
    }else{
      return false;
    }
  }
  //=================
}