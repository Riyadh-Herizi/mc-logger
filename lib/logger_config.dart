class LogsColors {
  final String color;
  final LogType logType;

  LogsColors({required this.color, required this.logType});
}

class LoggerConfig {
  final double logsMaxSize;
  // Define the properties
  final bool colorAllLine;
  final bool isTesting;
  final bool showTimeConsole;
  final bool showTimeStorage;
  final String timeFormatConsole;
  final String timeFormatStorage;

  // Constructor with default values
  LoggerConfig({
    this.isTesting = false,
    this.logsMaxSize = 10,
    this.colorAllLine = true,
    this.showTimeConsole = true,
    this.showTimeStorage = true,
    this.timeFormatConsole = 'HH:mm',
    this.timeFormatStorage = 'yyyy-MM-dd HH:mm',
  });

  double getMaxSize() {
    return logsMaxSize;
  }
}

enum LogType {
  error,
  info,
  warning,
  debug;

  String get defaultColor {
    switch (this) {
      case LogType.error:
        return '\x1B[31m';
      case LogType.info:
        return '\x1B[36m';
      case LogType.warning:
        return '\x1B[33m';
      case LogType.debug:
        return '\x1B[35m';
    }
  }

  String get getName {
    return name.toUpperCase();
  }
}
