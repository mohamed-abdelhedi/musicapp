import 'dart:io';
import 'package:http/http.dart' as http;

void classify(String audioFilePath, String replaceAll) async {
  String apiUrl = 'http://127.0.0.1:5000/upload';

  // Create a new multipart request
  var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

  // Attach the audio file to the request
  request.files.add(await http.MultipartFile.fromPath('audio', audioFilePath));

  try {
    // Send the request and get the response
    var response = await request.send();

    // Check if the request was successful (HTTP 200 OK)
    if (response.statusCode == 200) {
      // Read the response stream and convert it to a string
      var responseBody = await response.stream.bytesToString();

      // Do something with the response
      print('Response: $responseBody');
    } else {
      print('Request failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}
