import 'package:flutter_test/flutter_test.dart';
import 'package:meta_logger/logger_config.dart';
import 'package:hive_test/hive_test.dart';
import 'package:meta_logger/r_logger.dart';

void main() {
  // Ensure Flutter bindings are initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await MetaLogger.init(
        customConfig: LoggerConfig(isTesting: true, logsMaxSize: 0.000001));
    // Initialize in-memory Hive storage for testing
    await setUpTestHive();
  });

  tearDown(() async {
    await tearDownTestHive(); // Clean up in-memory Hive storage
  });

  test('Logger should log info message', () async {
    // Initialize logger with default config

    await MetaLogger.i('This is an info log message');

    var logs = await MetaLogger.getLogs();

    expect(logs.isNotEmpty, true);
    expect(logs[0].contains('info'), true);
  });

  test('Logger should log error message', () async {
    await MetaLogger.e('This is an error log message');

    var logs = await MetaLogger.getLogs();

    // Verify that the log was saved and is of type error
    expect(logs.isNotEmpty, true);
    expect(logs[0].contains('error'), true);
  });

  test('Logger should respect log size limit', () async {
    // Initialize logger with a custom log size limit (in MB)

    // Log multiple messages to exceed the limit
    for (int i = 0; i < 200; i++) {
      await MetaLogger.i('This is log message $i');
    }

    // Ensure logs were deleted due to size limit
    var logs = await MetaLogger.getLogs();

    expect(logs.length, 1); // Should be empty after exceeding the limit
  });
}
