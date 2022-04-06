# Catching exceptions

There is no doubt that `try-catch` block makes it easy to handle any exception in our Dart and Flutter projects. However, only using this block and silently ignore the exception that goes to `catch` block can consider one of the worse error handling solution.

Let's now see how we can use `try-catch` block to handle our errors gracefully, notify our users gently and report errors accordingly.

## How to use `try-catch`

Let's first look at a typical example, where you have a service, that has a function which is making a `http` call.

```dart
 Future<String> getUserInfo() async {
    try {
      final url = Uri.https(DOMAIN, '/userinfo');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
         return 'Success';
       } else {
         throw Exception('Failed to get user details');
       }
    } catch (e) {
      return 'Unknown error ${e.runtimeType}';
    }
  }
```

There are different scenarios that this function may throw an exception but generally the block above will catch all the exception with no specification!

This simple example can easily become pretty advanced where it's pretty suitable to handle different exception and properly show different error message.

Let's extend the example above with `on` keyword to `catch` a specific exception:

```dart
  Future<String> getUserInfo() async {
    try {
      final url = Uri.https(DOMAIN, '/userinfo');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) {
        return 'Success';
      } else {
        throw Exception('Failed to get user details');
      }
    } on TimeoutException catch (e) {
      return e.message ?? 'Timeout Error!';
    } on FormatException catch (e) {
      return e.message;
    } on SocketException catch (e) {
      return e.message;
    } on PlatformException catch (e) {
      return e.message ?? 'Something is Wrong! Code: ${e.code}';
    } catch (e) {
      return 'Unknown error ${e.runtimeType}';
    }
  }
```

Notice you can handle exception much better now as you know the specific type and you may return a proper message based on the exact exception. There are several predefined exception which all extends `Exception` class.

### Finally

In `try-catch` block you have another keyword named `finally` where the execution run into it when either `try` or `catch` is finished and in fact is the best time to run any side effect for example to clean up cache or add something to cache.

```dart
try {
  getPosts();
} catch (e) { // No specified type, handles all
  print('Something really unknown: $e');
} finally { // Always clean up, even if case of exception
    // do your side effect
}
```

In the next step, you will learn how you can define a custom `Exception`.
