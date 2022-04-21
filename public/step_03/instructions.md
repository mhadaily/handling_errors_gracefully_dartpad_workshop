# Create Custom Exception

There are many times that you would like to throw your own exception in the application. For example, when user authentication fails.

To define a customized exception class you can implement the `Exception` interface:

```dart
class UserInfoException implements Exception {
  const UserInfoException(this.message);
  final String message;
}
```

You may even go further and add more properties to the `class`:

```dart
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
```

Now that you have defined you custom exception, you can catch it using `on` keyword as you have seen in the previous step:

```dart
  Future<String> getUserInfo() async {
    try {
      final url = Uri.https(DOMAIN, '/userinfo');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return 'Success';
      } else {
         throw UserInfoException('Failed to get user details');
      }
    } on UserInfoException catch (e) {
      return e.message; // message that you have defined
    } catch (e) {
      return 'Unknown error ${e.runtimeType}';
    }
  }
```

In the next step, you will make your own object to return a proper type in case of `Exception`.
