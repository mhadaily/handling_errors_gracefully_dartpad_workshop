import 'dart:async';
import 'package:flutter/material.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

void main() {
  ErrorWidget.builder = (errorDetails) {
    return ErrorScreen();
  };

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // await myErrorsHandler.initialize();

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
        // myErrorsHandler.onError(error, stack);
        // exit(1); // you may exit the app
      }
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Text('Hello'),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: [
        const Text('CUSTOM ERROR PAGE'),
        ElevatedButton(
          onPressed: () {},
          child: const Text("RETRY"),
        ),
      ])),
    );
  }
}
