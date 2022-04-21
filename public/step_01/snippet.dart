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

  runApp(MyApp());

  // Your Turn: Implement `runApp(MyApp());` using `runZonedGuarded`
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
        child: Column(
          children: [
            const Text('CUSTOM ERROR PAGE'),
            ElevatedButton(
              onPressed: () {},
              child: const Text("RETRY"),
            ),
          ],
        ),
      ),
    );
  }
}
