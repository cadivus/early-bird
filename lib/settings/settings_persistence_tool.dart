import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' show join;

import 'package:early_bird/settings/settings_data.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPersistenceTool {
  static const _settingsFile = "settings.json";

  /// Stores settings to persistent storage
  static Future<void> persist(SettingsData settingsData) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String settingsFilePath = join(dir.path, _settingsFile).toString();

    String content = settingsData.toJson().toString();

    final file = File(settingsFilePath);
    await file.writeAsString(content);
  }

  /// Loads settings from persistent storage
  static Future<SettingsData> load() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String settingsFilePath = join(dir.path, _settingsFile).toString();

    File file = File(settingsFilePath);
    if (!(await file.exists())) {
      return const SettingsData();
    }

    try {
      Map<String, dynamic> parsedJson = jsonDecode(await file.readAsString());
      return SettingsData.fromJson(parsedJson);
    } catch (e) {
      return const SettingsData();
    }
  }
}
