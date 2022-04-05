# Errors caught by Flutter

For example, to make your application quit immediately any time an error is caught by Flutter in release mode, you could use the following handler:

Note: The top-level kReleaseMode constant indicates whether the app was compiled in release mode.

```dart
void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kReleaseMode)
      exit(1);
  };
  runApp(MyApp());
}
```

This handler can also be used to report errors to a logging service. For more details, see our cookbook chapter for reporting errors to a service.
