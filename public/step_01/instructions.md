# Handling errors in Flutter

Errors can occurs at any time in any applications. It's our responsibility to catch them and handle them gracefully and boost our user experience by correctly show an appropriate message accordingly.

Let's first start to understand how Flutter handles errors and why you see red screen from time to time!

All errors caught by Flutter are routed to the `FlutterError.onError` handler. By default, this calls `FlutterError.presentError`, which dumps the error to the device logs and that's why you see the messages in your IDEA or text editor.

You can change the behavior of this handler and add yours, for example, in the code below for production mode, I am reporting to `Zone` as uncaught error!

```dart
main(){
  // This captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) async {
    final dynamic exception = details.exception;
    final StackTrace? stackTrace = details.stack;
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone
      Zone.current.handleUncaughtError(exception, stackTrace!);
    }
  };
  // ... rest of the code
}
```

Typically, there two types of handling errors in Flutter:

1- Error during the build phase:
In this case, the `ErrorWidget.builder` callback is invoked to build the widget that is used instead of the one that failed and this is the reason you see red screen and error message in debug mode and gray screen in production mode. You can customize this page and change the behavior.

```dart
main() {
  ErrorWidget.builder = (errorDetails) {
    return ErrorScreen();
  }
// ... rest of the code

  class ErrorScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('CUSTOM ERROR PAGE'),
              ElevatedButton(
                onPressed: () {},
                child: Text("RETRY"),
              ),
            ]
          )
        ),
      );
    }
  }
}
```

2- Error without a Flutter callback on the call stack:
In this case, error will be handled by `Zone` where it does nothing except to print it out by default!

```dart
main(){
 runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // await Firebase.initializeApp(); e.g

      runApp(MyApp());

    },
    (error, stackTrace) async {
      if (isInDebugMode) {
        // In development mode simply print to console.
        print('Caught Dart Error!');
        print('$error');
        print('$stackTrace');
      } else {
         // In production
        // Report errors to a reporting service such as Sentry or Crashlytics
        exit(1); // you may exit the app
      }
    },
  );
  // ... rest of the code
}
```

Note that if in your app you call `WidgetsFlutterBinding.ensureInitialized()` manually to perform some initialization before calling runApp (e.g. `Firebase.initializeApp()`), you must call `WidgetsFlutterBinding.ensureInitialized()` inside `runZonedGuarded` as I did in the example above!

Now that you know how Flutter handles errors it's time to see how we as Flutter developer can do to gracefully handles errors too!
