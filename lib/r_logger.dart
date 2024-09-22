library r_logger;

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:r_logger/logger_config.dart';
import 'package:r_logger/persist_logs.dart';

// Initialize PersistLogs singleton
PersistLogs persistLogs = PersistLogs();

class RLogger {
  static LoggerConfig config = LoggerConfig();
  static String propagationStopCode = "\x1B[0m";
  // New getLogs method
  static Future<List<dynamic>> getLogs() async {
    await Hive.openBox(PersistLogs.logsBoxName);
    return Hive.box(PersistLogs.logsBoxName).values.toList();
  }

  // Initialize the logger with custom config (optional)
  static Future<void> init({LoggerConfig? customConfig}) async {
    config = customConfig ?? LoggerConfig();

    await PersistLogs.initHive(test: config.isTesting);
  }

  static Future<void> log(String msg, {LogType type = LogType.info}) async {
    String content = '${getColorfulString(type)}: $msg $propagationStopCode';
    debugPrint(content);

    // Check if the log size limit is exceeded and handle it
    bool isLimitExceeded = await persistLogs.isLimitExceeded(config);

    if (isLimitExceeded) {
      await persistLogs.deleteLogs();
    }

    // Format the time for storage
    var time = config.showTimeStorage
        ? '- ${DateFormat(config.timeFormatStorage).format(DateTime.now())}'
        : "";

    // Write log to persistent storage
    persistLogs.write('${type.name} $time : $msg');
  }

  static String getColorfulString(LogType type) {
    var time = config.showTimeConsole
        ? '- ${DateFormat(config.timeFormatConsole).format(DateTime.now())}'
        : "";

    var propagationStop = !config.colorAllLine ? propagationStopCode : "";
    return '${type.defaultColor} ${type.getName} $time $propagationStop';
  }

  static Future<void> e(String message) async =>
      await log(message, type: LogType.error);
  static Future<void> i(String message) async =>
      await log(message, type: LogType.info);
  static Future<void> w(String message) async =>
      await log(message, type: LogType.warning);
  static Future<void> d(String message) async =>
      await log(message, type: LogType.debug);
}
