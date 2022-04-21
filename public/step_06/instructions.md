# Building screen based on Success or Failure

Before I continue to the UI implementation, I will create `User` model as follow:

```dart
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
```

Then, I will convert my `json` to Dart object where I call http endpoint:

```dart
Future<Either<Failure, User>> getUserInfo() async {
  return errorHandler(
    () async {
      final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
      final http.Response response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
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
```

Then, I will get user info on `initialState` on my `StatefulWidget`:

```dart
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
    data = await getUserInfo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator.adaptive());
  }
}
```

When the `data` is received it will either `Either<Failure, User>` therefore, I can use `.either` on `data` and pass callbacks to set the data; However, there is a better way to do.

## Fold

`Fold` is a higher order function that apply either the left or right function, returning the result of the applied function! Let's take a look at the definition

```dart

abstract class Either<L, R> {
  Z fold<Z>(Z Function(L) onLeft, Z Function(R) onRight);
}

class Left<L, R> extends Either<L, R> {
  @override
  Z fold<Z>(Z Function(L) onLeft, Z Function(R) onRight) => onLeft(value);
}

class Right<L, R> extends Either<L, R> {
  @override
  Z fold<Z>(Z Function(L) onLeft, Z Function(R) onRight) => onRight(value);
}

```

With this implementation now I am able to directly return a `Widget` corresponding to the value of failure or success.

```dart
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
```

## Your Turn

It's your turn now to go and redo what you have learned here and refactor your app or perhaps reuse these concepts with your favorite state management in your Flutter app.
