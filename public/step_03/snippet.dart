import 'dart:async';
import 'package:http/http.dart' as http;

// Your turn: create UserInfoException class, throw that exception on an
// appropriate place and catch using `on` keyword

class UserService {
  Future<String> getUserInfo() async {
    final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
    final response = await http.get(url);
    return 'DONE';
    // Throw your custom exceptions and catch using `on` keyword
  }
}

void main() async {
  final userService = UserService();
  final result = await userService.getUserInfo();
  print(result);
}
