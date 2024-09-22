import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:r_logger/logger_config.dart';
import 'package:uuid/uuid.dart';

class PersistLogs {
  factory PersistLogs() => _instance;
  static final PersistLogs _instance = PersistLogs._();
  PersistLogs._();

  static double sizeFallback = 3;

  static const logsBoxName = 'r_logs';
  Uuid uid = const Uuid();

  void write(String msg) async {
    if (!(Hive.isBoxOpen(logsBoxName))) {
      await Hive.openBox(logsBoxName);
    }
    final currentBox = Hive.box(logsBoxName);
    await currentBox.put(uid.v1(), msg);
  }

  static Future<void> initHive({bool? test = false}) async {
    if (!kIsWeb) {
      final appDocumentDirectory = test != null && test
          ? Directory.systemTemp
          : await getApplicationDocumentsDirectory();
      Hive.init(appDocumentDirectory.path);
      await Hive.openBox(logsBoxName);
    }
  }

  // The log size returned is in MB
  static Future<double> getLogCurrentSize() async {
    final logBox = Hive.box(logsBoxName);
    var logs = logBox.values.toList().toString();
    List<int> encodedValue = utf8.encode(logs);
    return encodedValue.length / (1024 * 1024); // Convert to MB
  }

  // Use LoggerConfig to get logsMaxSize value
  Future<bool> isLimitExceeded(LoggerConfig config) async {
    double logsMaxSize = config.getMaxSize();
    double logsSizeInMB = await getLogCurrentSize();
    return logsSizeInMB > (logsMaxSize);
  }

  Future<void> deleteLogs() async {
    final logBox = Hive.box(logsBoxName);
    Iterable<dynamic> keys = logBox.keys;
    await logBox.deleteAll(keys);
  }
}
