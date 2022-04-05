# Handling errors in Flutter

The Flutter framework catches errors that occur during callbacks triggered by the framework itself, including errors encountered during the build, layout, and paint phases. Errors that don’t occur within Flutter’s callbacks can’t be caught by the framework, but you can handle them by setting up a Zone.

All errors caught by Flutter are routed to the FlutterError.onError handler. By default, this calls FlutterError.presentError, which dumps the error to the device logs. When running from an IDE, the inspector overrides this behavior so that errors can also be routed to the IDE’s console, allowing you to inspect the objects mentioned in the message.

When an error occurs during the build phase, the ErrorWidget.builder callback is invoked to build the widget that is used instead of the one that failed. By default, in debug mode this shows an error message in red, and in release mode this shows a gray background.

When errors occur without a Flutter callback on the call stack, they are handled by the Zone where they occur. By default, a Zone only prints errors and does nothing else.

You can customize these behaviors, typically by setting them to values in your void main() function.

Below each error type handling is explained. At the bottom there’s a code snippet which handles all types of errors. Even though you can just copy-paste the snippet, we recommend you to first get acquainted with each of the error types.
