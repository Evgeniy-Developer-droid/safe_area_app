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

void deleteMedia(id) async {
    final url = Uri.parse("https://safe-area.com.ua/api/delete_media/" + id.toString());
    final request = http.Request("DELETE", url);
    await request.send();
}