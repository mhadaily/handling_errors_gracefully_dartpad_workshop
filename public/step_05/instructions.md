# Either type

When you handled errors in the previous step, you saw that the error type and the success type are different. Let's review again:

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

As you can see, the return type is `Future<dynamic>`. In other words, this function could return any type of object at some point in the future. However, you know your function can't return any kind of object. It returns either a `String` if everything works or `Failure` when an `Exception` occurs.

To fix this problem, you are going to borrow a class from the Scala programming language: `Either`. The `Either` class allows you to define `Left` or `Right` properties. In your example, the `Left` property represents the `Failure` and the `Right` property represents the success type.

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

You are now able to return a type that has two expected type! Let's refactor, beginning with `errorHandler` function:

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

Then, you can now refactor your `getUserInfo` and replace dynamic with `<Either<Failure, String>>` the `String` is success type where it can be anything in this case:

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

## Your turn

## What next

In the next step, you will put all together and render a Flutter screen based on this `Either` type;
