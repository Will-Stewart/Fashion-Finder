import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Future<List<String>> sendImageToCustomVision(File imageFile) async {
  const String endpoint =
      'https://fashion-finder.cognitiveservices.azure.com/customvision/v3.0/Prediction/444b21d0-fbdf-495d-a42e-33d060a50d87/classify/iterations/Iteration15/image';
  const String subscriptionKey = '1e8bf7ed8e764d0ab6c69e65bd5a51f4';

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
