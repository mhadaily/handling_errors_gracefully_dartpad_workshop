# Define a custom error widget for build phase errors

To define a customized error widget that displays whenever the builder fails to build a widget, use MaterialApp.builder.

```dart
class MyApp extends StatelessWidget {
...
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ...
      builder: (BuildContext context, Widget widget) {
        Widget error = Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator)
          error = Scaffold(body: Center(child: error));
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) => error;
        return widget;
      },
    );
  }
}
```
