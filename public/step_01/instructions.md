# Handling errors in Flutter

Errors can occurs at any time in any applications. It's your responsibility to handle them gracefully and boost the user experience by showing helpful messages. Let's first start by understanding how Flutter handles errors and why you see a red screen from time to time!

All errors caught by Flutter are routed to the `FlutterError.onError` function. By default, this calls `FlutterError.presentError`, which dumps the error to the device logs. That's why you see the messages in your IDE or text editor.

However, you can override the `Flutter.onError` function. For example, the code below prints errors to the console in debug mode, and reports errors to the current `Zone` in production mode.

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

**_What is Zone?_**

## Types of Errors

Typically, there two types of handling errors in Flutter.

**_Error during the build phase_**

In this case, the `ErrorWidget.builder` function is invoked to build the widget that is used instead of the one that failed. This is the reason you see red screen and error message in debug mode and gray screen in production mode. You can also override the `ErrorWidget.builder` function to change the behavior.

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

**_Error with a Flutter callback on the call stack_**

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

## Your turn

## What next

Now that you know how Flutter handles errors, it's time to see how you can gracefully handle errors as well!
