import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<List<String>> sendImageToCustomVision(File imageFile) async {
  const String endpoint =
      'removed';
  const String subscriptionKey = 'removed';

  final List<int> imageData = await imageFile.readAsBytes();

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/octet-stream',
      'Prediction-Key': subscriptionKey,
    },
    body: imageData,
  );

  final returnedJSON = jsonDecode(response.body);

  List<dynamic> dynamicList = returnedJSON['predictions']
      .map((prediction) => prediction['tagName'])
      .take(5)
      .toList();

  List<String> finalTags = dynamicList.cast<String>();

  print(finalTags);
  return finalTags;
}
