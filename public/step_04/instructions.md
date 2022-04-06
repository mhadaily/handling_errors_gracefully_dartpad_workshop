# Define a custom Failure class

In the previous step, we were returning `String` in case of `Exception`, now we are going to improve our implementation. To have a better and robust code we can create a `Failure` class and return that in case of any `Exception`;

```dart
class Failure{
  Failure(this.message, this.title);

  final String message;
  final String title;
}
```

Now wen can also refine our previous implementation

```dart
  Future<dynamic> getUserInfo() async {
    try {
      final url = Uri.https('https://jsonplaceholder.typicode.com/users/1');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return 'Success';
      } else {
         throw UserInfoException('It seems that the server is not reachable at the moment, try '
            'again later, should the issue persist please reach out to the '
            'developer at a@b.com');
      }
    } on TimeoutException catch (e) {
      return Failure(e.message ?? 'Timeout Error!', 'Timeout Error');
    } on FormatException catch (e) {
      return Failure(e.message, 'Formatting Error!');
    } on SocketException catch (e) {
      return Failure(e.message, 'No Connection!');
    } on PlatformException catch (e) {
      return Failure( e.message ?? 'Something is Wrong! Code: ${e.code}', 'Error ${e.code}!');
    } on UserInfoException catch (e) {
       return Failure(e.message, 'User Cannot be found!');
    } catch (e) {
      return Failure('Unknown error ${e.runtimeType}', '${e.runtimeType}');
    }
  }
```

Now this block might be repeated in many other functions especially similar ones. Therefore, you may create a higher order function to make it easier wrapping similar functions with the same block and failures!

Let's first create a `errorHandler` function where it accepts a callback which is going to be our service's method:

```dart
 typedef AsyncCallBack<T> = Future<T> Function();

 Future<dynamic> errorHandler(AsyncCallBack callback) async {
    try {
      return await callback();
    } on TimeoutException catch (e) {
      return Failure(e.message ?? 'Timeout Error!', 'Timeout Error');
    } on FormatException catch (e) {
      return Failure(e.message, 'Formatting Error!');
    } on SocketException catch (e) {
      return Failure(e.message, 'No Connection!');
    } on PlatformException catch (e) {
      return Failure( e.message ?? 'Something is Wrong! Code: ${e.code}', 'Error ${e.code}!');
    } on UserInfoException catch (e) {
       return Failure(e.message, 'User Cannot be found!');
    } catch (e) {
      return Failure('Unknown error ${e.runtimeType}', '${e.runtimeType}');
    }
}
```

Now we can refactor our `getUserInfo` function and simplify by wrapping it with `errorHandler` method:

```dart
  Future<dynamic> getUserInfo() async {
    return errorHandler(
      () async {
        final url = Uri.https('https://jsonplaceholder.typicode.com/users/1');
        final response = await http.get(url);
        if (response.statusCode == HttpStatus.ok) {
          return 'Success';
        } else {
          throw UserInfoException('It seems that the server is not reachable at the moment, try '
              'again later, should the issue persist please reach out to the '
              'developer at a@b.com');
        }
      }
    );
  }
```

In the next step, we will see how we can handle different returning types for this method.
