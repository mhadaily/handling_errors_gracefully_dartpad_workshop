import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

typedef AsyncCallBack<T> = Future<T> Function();

/// Signature of callbacks that have no arguments and return right or left value.
typedef Callback<T> = void Function(T value);

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: UserPage(),
      ),
    );
  }
}

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Either<Failure, User>? data;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    final userService = UserService();
    data = await userService.getUserInfo();
    setState(() {});
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      return data!.fold<Widget>(
        (failure) {
          return Center(child: Text('Error! ${failure.message}'));
        },
        (success) {
          return Center(child: Text('Hello ${success.name}'));
        },
      );
    }

    return const Center(child: CircularProgressIndicator.adaptive());
  }
}

class User {
  const User({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  factory User.fromJson(json) {
    return User(id: json['id'], name: json['name']);
  }
}

// From previous step
class UserService {
  Future<Either<Failure, User>> getUserInfo() async {
    return errorHandler(
      () async {
        final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
        final http.Response response = await http.get(url);
        if (response.statusCode == 200) {
          return User.fromJson(jsonDecode(response.body));
        } else {
          throw const UserInfoException(
            'It seems that the server is not reachable at the moment, try '
            'again later, should the issue persist please reach out to the '
            'developer at a@b.com',
          );
        }
      },
    );
  }
}

class Failure {
  Failure(this.message, this.title);

  final String message;
  final String title;
}

Future<Either<Failure, T>> errorHandler<T>(AsyncCallBack<T> callback) async {
  try {
    return Right(await callback());
  } on TimeoutException catch (e) {
    return Left(
      Failure(e.message ?? 'Timeout Error!', 'Timeout Error'),
    );
  } on FormatException catch (e) {
    return Left(
      Failure(e.message, 'Formatting Error!'),
    );
    // } on SocketException catch (e) {
    //   return Left(
    //     Failure(e.message, 'No Connection!'),
    //   );
  } on UserInfoException catch (e) {
    return Left(
      Failure(e.message, 'User Cannot be found!'),
    );
  } catch (e) {
    return Left(Failure('Unknown error ${e.runtimeType}', '${e.runtimeType}'));
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

  Z fold<Z>(Z Function(L) onLeft, Z Function(R) onRight);

  void either(Callback<L> fnL, Callback<R> fnR) {
    if (isLeft) {
      final Left<L, R> left = this as Left<L, R>;
      return fnL(left.value);
    }

    if (isRight) {
      final Right<L, R> right = this as Right<L, R>;
      return fnR(right.value);
    }
  }
}

// Failure
class Left<L, R> extends Either<L, R> {
  Left(this.value);

  @override
  Z fold<Z>(Z Function(L) onLeft, Z Function(R) onRight) => onLeft(value);

  final L value;
}

// Success
class Right<L, R> extends Either<L, R> {
  Right(this.value);

  @override
  Z fold<Z>(Z Function(L) onLeft, Z Function(R) onRight) => onRight(value);

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
}
