import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<String> uploadMedia(filename, typeOfMedia) async {
  var request = http.MultipartRequest('POST', Uri.parse("https://safe-area.com.ua/api/upload_media"));
  request.files.add(await http.MultipartFile.fromPath('file', filename));
  request.fields['extension'] = typeOfMedia; //video
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);
  // print(response.body.runtimeType);
  return response.body;
}

Future<String> getEvents(String lat, String lng, String zoom, String start, String end, String keys) async {
  final param = {
    'lat': lat,
    'lon': lng,
    'zoom': zoom,
    'start': start,
    'end': end
  };
  if(keys.length != 0){
    param['types'] = keys;
  }
  var url = Uri.https('safe-area.com.ua', '/api/get_events', param);
  var response = await http.get(url);
  return response.body;
}

void deleteMedia(id) async {
    final url = Uri.parse("https://safe-area.com.ua/api/delete_media/" + id.toString());
    final request = http.Request("DELETE", url);
    await request.send();
}

Future<int> createEvent(lat, lng, typeOfSituation, mediaIds, description) async {
  var url = Uri.parse("https://safe-area.com.ua/api/create_event");
  Map data = {
    'lat': lat,
    'lon': lng,
    'description': description,
    'media_ids': mediaIds,
    'type_of_situation': typeOfSituation
  };
  var body = json.encode(data);
  var response = await http.post(url,
      headers: {"Content-Type": "application/json"},
      body: body
  );
  // print("${response.statusCode}");
  // print("${response.body}");
  return response.statusCode;
}