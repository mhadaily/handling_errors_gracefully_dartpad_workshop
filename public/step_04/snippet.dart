import 'dart:async';
import 'package:http/http.dart' as http;

typedef AsyncCallBack<T> = Future<T> Function();

class Failure {
  Failure(this.message, this.title);

  final String message;
  final String title;
}

class UserInfoException implements Exception {
  const UserInfoException(
    this.message, {
    this.source,
    this.code,
  });

  /// A message describing the error.
  final String message;
  final String? code;
  final String? source;

  @override
  toString() {
    return {
      'message': message,
      'code': code,
      'source': source,
    }.toString();
  }
}

class UserService {
  Future<dynamic> getUserInfo() async {
    // Your turn: Create a hider order error handling function and use it in this method
    final url = Uri.https('https://jsonplaceholder.typicode.com', '/users/1');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw UserInfoException(
        'It seems that the server is not reachable at the moment, try '
        'again later, should the issue persist please reach out to the '
        'developer at a@b.com',
      );
    }
  }
}

main() async {
  final userService = UserService();
  final result = await userService.getUserInfo();
  print(result);
}
