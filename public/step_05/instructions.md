# Either type

In the previous step, we have seen that when we handle errors the error type and the success type might be different. Let's review again:

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

As you can see, the type is `Future<dynamic>` where it should be either `String` in case of `HttpStatus.ok` or `Failure` when `Exception` occurs. To fix this problem, we are going to borrow a concept from Scala programming language named `Either` where we can define `Left` or `Right` parties to `Either` class where `Left` represent the `Failure` and `Right` will be the returning success type;

```dart
/// Signature of callbacks that have no arguments and return right or left value.
typedef Callback<T> = void Function(T value);

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
```

We are now able to return a type that has two expected type! Let's refactor, beginning with `errorHandler` function:

```dart
 typedef AsyncCallBack<T> = Future<T> Function();

 Future<Either<Failure, T>> errorHandler<T>(AsyncCallBack<T> callback) async {
    try {
      return Right(await callback());
    //... rest of the Exceptions
    } catch (e) {
      return Failure('Unknown error ${e.runtimeType}', '${e.runtimeType}');
    }
}
```

Then, wen can now refactor our `getUserInfo` and replace dynamic with `<Either<Failure, String>>` the `String` is success type where it can be anything in this case:

```dart
  Future<<Either<Failure, String>>> getUserInfo() async {
    return errorHandler(
      () async {
        final url = Uri.https('jsonplaceholder.typicode.com', '/users/1');
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

In the next step, we will put all together and render a Flutter screen based on this `Either` type;
