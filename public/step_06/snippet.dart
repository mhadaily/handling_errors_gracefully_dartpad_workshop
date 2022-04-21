import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

main() {
  // Your turn: use runZoneGuarded
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
  dynamic data; // your turn: fix this type using `Either`

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

class UserService {
// Your turn: re-implement this method using `Either`, `Left` and `Right` with throwing a `UserInfoException` in an appropriate place.
  Future<dynamic> getUserInfo() async {
    final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
    final http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        'It seems that the server is not reachable at the moment, try '
        'again later, should the issue persist please reach out to the '
        'developer at a@b.com',
      );
    }
  }
}
