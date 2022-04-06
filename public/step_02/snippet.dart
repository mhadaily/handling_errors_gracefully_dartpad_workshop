import 'dart:async';
import 'package:http/http.dart' as http;

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() {
  Future<String> getUserInfo() async {
    try {
      final url = Uri.https('https://jsonplaceholder.typicode.com', '/users/1');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return 'Success';
      } else {
        throw Exception('Failed to get user details');
      }
    } on TimeoutException catch (e) {
      /// Thrown when a scheduled timeout happens while waiting for an async result.
      return e.message ?? 'Timeout Error!';
    } on FormatException catch (e) {
      // Exception thrown when a string or some other data does not have an expected format and cannot be parsed or processed.
      return e.message;
    } catch (e) {
      return 'Unknown error ${e.runtimeType}';
    }
  }
}
