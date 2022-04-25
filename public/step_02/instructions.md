# Catching exceptions

There is no doubt that `try-catch` blocks make it easy to handle any exception in your Dart and Flutter projects. However, silently ignoring the exception that goes to `catch` block is considered one of the worst ways to handle errors.

Let's now see how you can use a `try-catch` block to handle your errors gracefully, notify your users gently, and report errors accordingly.

## How to use `try-catch`

Let's first look at a typical example, where you have a service that makes an `http` call.

```dart
 Future<String> getUserInfo() async {
    try {
      final url = Uri.https(DOMAIN, '/userinfo');
      final response = await http.get(url);
      if (response.statusCode == HttpStatus.ok) { // Might have to hard-code 200 since HttpStatus comes from dart:io
         return 'Success';
       } else {
         throw Exception('Failed to get user details');
       }
    } catch (e) {
      return 'Unknown error ${e.runtimeType}';
    }
  }
```

The code inside the `try` block above may throw many types of exceptions: `TimeoutException`, `FormatException` etc. The `catch` block handles all of them.

However, this simple example can easily become pretty advanced. In that case, it's better to handle specific exception in different ways.

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

`try-catch` blocks have another keyword named `finally`, which runs a block of code after either the `try` or `catch` is finished. In fact, `finally` is the best time to run any side effects, such as adding or removing items from a cache.

```dart
try {
  getPosts();
} catch (e) { // No specified type, handles all
  print('Something really unknown: $e');
} finally { // Always clean up, even if case of exception
    // do your side effect
}
```

## Your turn

Now it's time to implement try-catch block and use `on` keyword to catch specific exception for `getUserInfo` method.

<!-- I really like the "What's next" sections :) -->
## What next

In the next step, you will learn how you can define and catch a custom `Exception`.
