import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

void main() {
  Future<String> getUserInfo() async {
    try {
      final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return 'Success';
      } else {
        throw UserInfoException('Failed to get user details');
      }
    } on TimeoutException catch (e) {
      /// Thrown when a scheduled timeout happens while waiting for an async result.
      return e.message ?? 'Timeout Error!';
    } on FormatException catch (e) {
      // Exception thrown when a string or some other data does not have an expected format and cannot be parsed or processed.
      return e.message;
    } on SocketException catch (e) {
      // The might be no internet! Exception thrown when a socket operation fails.
      return e.message;
    } on UserInfoException catch (e) {
      return e.message; // message that you have defined
    } catch (e) {
      return 'Unknown error ${e.runtimeType}';
    }
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
