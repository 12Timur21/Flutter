import 'package:http/http.dart' as http;
import 'dart:convert';
import 'User.dart';

Future<String> createRequest() async {
  var response =
      await http.get(Uri.parse('http://jsonplaceholder.typicode.com/posts'));

  if (response.statusCode != 200) {
    throw Exception('Something went wrong...');
  }
  return response.body;
}

Future<void> main() async {
  String jsonString = await createRequest();
  final userMap = jsonDecode(jsonString);
  User user = User.fromJson(userMap[0]);

  print(
      '''
    ID: ${user.id} 
    UserID: ${user.userId}
    Title: ${user.title}
    Body: ${user.body}
  ''');

  print('------------------');

  print(jsonEncode(user));
}
