import 'dart:async';
import 'package:http/http.dart' as http;

class UserService {
  Future<String> getUserInfo() async {
    // Your turn: Use Try-Catch and On Keyword

    final url = Uri.https('https://jsonplaceholder.typicode.com', '/users/1');
    await http.get(url);
    return 'Done';
  }
}

void main() async {
  final userService = UserService();
  final result = await userService.getUserInfo();
  print(result);
}
