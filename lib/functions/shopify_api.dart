import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart';
import 'dart:typed_data';

String apiKey = '843a68fd4d418ea88f5b09866b1fa814';
String password = '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';
String storeUrl = 'modassilviabenitez.myshopify.com';

Future<Map<String, dynamic>> searchProductsByTags(List<String> tags) async {
  String endpoint = '/admin/api/2023-04/products.json';
  String url =
      'https://$apiKey:$password@$storeUrl$endpoint?tags=${tags.join(',')}';

  http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);

    List<dynamic> products = jsonData['products'];

    // Calculate the number of matching tags for each product
    List<int> tagCounts = products.map((product) {
      List<String> productTags = product['tags'].split(',');
      int count = 0;

      for (String tag in tags) {
        if (productTags.contains(tag)) {
          count++;
        }
      }

      return count;
    }).toList();

    // Find the product with the highest number of matching tags
    int maxCount =
        tagCounts.reduce((value, element) => value > element ? value : element);
    int maxIndex = tagCounts.indexOf(maxCount);
    Map<String, dynamic> closestMatch = products[maxIndex];
    print(closestMatch);
    return closestMatch;
  } else {
    throw Exception('Failed to load products');
  }
}

Future<Uint8List?> getProductImage(int productId) async {
  String endpoint = '/admin/api/2023-04/products/$productId/images.json';
  String url = 'https://$apiKey:$password@$storeUrl$endpoint';

  http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = json.decode(response.body);
    List<dynamic> images = jsonData['images'];

    if (response.statusCode == 200) {
      // ... existing code ...

      if (images.isNotEmpty) {
        String imageUrl = images[0]['src'];
        Uint8List imageData = await http.readBytes(Uri.parse(imageUrl));
        return imageData;
      } else {
        return null;
      }
    } else {
      return null;
    }
  } else {
    throw Exception('Failed to load product images');
  }
}
