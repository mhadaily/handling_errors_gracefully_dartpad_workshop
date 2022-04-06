import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

typedef AsyncCallBack<T> = Future<T> Function();

main() {
  Future<dynamic> getUserInfo() async {
    return errorHandler(() async {
      final url = Uri.https('https://jsonplaceholder.typicode.com', '/users/1');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return 'Success';
      } else {
        throw UserInfoException(
            'It seems that the server is not reachable at the moment, try '
            'again later, should the issue persist please reach out to the '
            'developer at a@b.com');
      }
    });
  }
}

class Failure {
  Failure(this.message, this.title);

  final String message;
  final String title;
}

Future<dynamic> errorHandler(AsyncCallBack callback) async {
  try {
    return await callback();
  } on TimeoutException catch (e) {
    return Failure(e.message ?? 'Timeout Error!', 'Timeout Error');
  } on FormatException catch (e) {
    return Failure(e.message, 'Formatting Error!');
  } on SocketException catch (e) {
    return Failure(e.message, 'No Connection!');
  } on UserInfoException catch (e) {
    return Failure(e.message, 'User Cannot be found!');
  } catch (e) {
    return Failure('Unknown error ${e.runtimeType}', '${e.runtimeType}');
  }
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
}
