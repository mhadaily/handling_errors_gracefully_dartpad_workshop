import 'dart:async';
import 'package:http/http.dart' as http;

typedef AsyncCallBack<T> = Future<T> Function();

/// Signature of callbacks that have no arguments and return right or left value.
typedef Callback<T> = void Function(T value);

class Failure {
  Failure(this.message, this.title);

  final String message;
  final String title;

  @override
  toString() {
    return {
      'message': message,
      'title': title,
    }.toString();
  }
}

abstract class Either<L, R> {
  Either() {
    if (!isLeft && !isRight) {
      throw Exception('The ether should be heir Left or Right.');
    }
  }

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;

  void either(Callback<L> fnL, Callback<R> fnR) {
    if (isLeft) {
      final Left<L, R> left = this as Left<L, R>;
      fnL(left.value);
    }

    if (isRight) {
      final Right<L, R> right = this as Right<L, R>;
      fnR(right.value);
    }
  }
}

// Failure
class Left<L, R> extends Either<L, R> {
  Left(this.value);
  final L value;
}

// Success
class Right<L, R> extends Either<L, R> {
  Right(this.value);
  final R value;
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

// your tune: Implement `errorHandler` higher order function utilizing Either and `Left` and `Right`.

class UserService {
  Future<dynamic> getUserInfo() async {
    // use `errorHandler` in this method to catch errors and fix the returning type
    final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
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
