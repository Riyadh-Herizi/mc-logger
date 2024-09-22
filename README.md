# MetaLogger

A simple logging package for Flutter applications that supports persistent logging with size limits.

## Features

- Log messages with different severity levels: error, info, warning, debug.
- Store logs persistently using Hive.
- Configure maximum log size to automatically delete old logs when the limit is exceeded.
- Support for custom configurations, including log formatting and colors.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  meta_logger: ^0.1.0
```
## Usage

### Initialization

Before using  MetaLogger, initialize it with optional custom configuration in your `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:meta_logger/meta_logger.dart';

void main() {
  // Initialize with custom config (optional)
  MetaLogger.init(customConfig: LoggerConfig(logsMaxSize: 5)); 
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('R Logger Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              MetaLogger.i('This is an info log message');
            },
            child: Text('Log Info Message'),
          ),
        ),
      ),
    );
  }
}
```
### Logging Messages

R Logger supports logging at various severity levels. Use the following methods to log messages:

- **Info Logs**: Use for general informational messages.
  ```dart
  MetaLogger.i('This is an info log message');
  ```
  - **Error Logs**: Use for error messages that indicate something went wrong.
  ```dart
  MetaLogger.e('This is an error log message');
  ```
  - **Warning Logs**: Use for warning messages that indicate potential issues.
  ```dart
  MetaLogger.w('This is a warning log message');
  ```
  - **Debug Logs**: Use for debug messages during development.
  ```dart
  MetaLogger.d('This is a debug log message');
  ```

## LoggerConfig

The `LoggerConfig` class manages the configuration settings for the logger. You can customize the following properties:

- **`logsMaxSize`**: The maximum size of logs allowed (in MB). Default is `10`.
- **`colorAllLine`**: Whether to apply color to the entire log line. Default is `true`.
- **`isTesting`**: Indicates if the logger is in testing mode. Default is `false`.
- **`showTimeConsole`**: Specifies if the time should be displayed in the console logs. Default is `true`.
- **`showTimeStorage`**: Specifies if the time should be stored with the log. Default is `true`.
- **`timeFormatConsole`**: The format of the time displayed in the console (default: `HH:mm`).
- **`timeFormatStorage`**: The format of the time stored with the logs (default: `yyyy-MM-dd HH:mm`).


## Conclusion

R Logger is a versatile logging package for Flutter that simplifies the process of logging and managing logs across different platforms. With its customizable configuration options, developers can easily tailor the logging behavior to fit their needs. Whether you're developing for mobile, web, or desktop, R Logger provides a robust solution for persistent logging, helping you keep track of important information and debug your applications effectively. We hope you find this package useful in your projects!
