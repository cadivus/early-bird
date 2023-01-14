import 'dart:convert';
import 'dart:io';
import 'package:cosinuss_lib/data_model/cosinuss_data.dart';
import 'package:early_bird/utils/sleep_detector.dart';
import 'package:path/path.dart' show dirname, join;
import 'package:flutter_test/flutter_test.dart';

typedef FileLineFunction = void Function(String line);

String getTestFilePath(String filename) =>
    join(dirname(Platform.script.path), 'test/utils/test_data', filename)
        .toString();

void expectNotAsleep(SleepDetector sleepDetector, String line) {
  Map<String, dynamic> data = jsonDecode(line);
  int timestampMs = data['timestamp'];
  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  CosinussData cosinussData = CosinussData.fromJson(data);

  bool result = sleepDetector.detectSleep(cosinussData, timestamp: timestamp);
  expect(result, false);
}

bool expectAsleep(
    SleepDetector sleepDetector, String line, int asleepTimestampMs) {
  Map<String, dynamic> data = jsonDecode(line);
  int timestampMs = data['timestamp'];
  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(timestampMs);
  CosinussData cosinussData = CosinussData.fromJson(data);

  bool result = sleepDetector.detectSleep(cosinussData, timestamp: timestamp);
  expect(result, timestampMs == asleepTimestampMs);
  return result;
}

Future<void> readFile(String path, FileLineFunction forEachLine) async {
  await File(path)
      .openRead()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .forEach(forEachLine);
}

void main() {
  group('Test not asleep', () {
    for (var testEntry in [
      {'title': 'Watch videos', 'file': 'watch_videos.txt'},
      {'title': 'Making breakfast', 'file': 'making_breakfast.txt'},
      {'title': 'Having breakfast', 'file': 'having_breakfast.txt'},
      {'title': 'Coding and having a coffee', 'file': 'coding_and_coffee.txt'},
    ]) {
      test(testEntry['title']!, () async {
        SleepDetector sleepDetector = SleepDetector();

        String path = getTestFilePath(testEntry['file']!);
        await readFile(path, (line) {
          expectNotAsleep(sleepDetector, line);
        });
      });
    }
  });

  group('Test asleep', () {
    for (var testEntry in [
      {
        'title': 'Fell asleep run 1',
        'file': 'fell_asleep/cosinuss_d1_s0.txt',
        'timestamp': 1671762007488 + 216456
      },
      {
        'title': 'Fell asleep run 2',
        'file': 'fell_asleep/cosinuss_d2_s0.txt',
        'timestamp': 1671764656471 + 108295
      }
    ]) {
      test(testEntry['title']!.toString(), () async {
        SleepDetector sleepDetector = SleepDetector();
        String path = getTestFilePath(testEntry['file']!.toString());

        bool fellAsleep = false;
        await readFile(path, (line) {
          if (fellAsleep) {
            return;
          }
          fellAsleep =
              expectAsleep(sleepDetector, line, testEntry['timestamp']! as int);
        });
      });
    }
  });
}
