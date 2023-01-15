import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;

import 'package:early_bird/settings/settings_data.dart';
import 'package:path_provider/path_provider.dart';

// Will only be used when running in browser
import 'package:universal_html/html.dart' show window, Storage;

class SettingsPersistenceTool {
  static const _settingsFile = 'settings.json';

  static Future<SettingsData> _loadFlutterWeb() async {
    Storage localStorage = window.localStorage;
    String? jsonString = localStorage[_settingsFile];
    if (jsonString == null) {
      return const SettingsData();
    }
    try {
      Map<String, dynamic> parsedJson = jsonDecode(jsonString);
      return SettingsData.fromJson(parsedJson);
    } catch (e) {
      return const SettingsData();
    }
  }

  static void _persistFlutterWeb(SettingsData settingsData) {
    Storage localStorage = window.localStorage;
    String content = jsonEncode(settingsData.toJson());
    localStorage[_settingsFile] = content;
  }

  /// Stores settings to persistent storage
  static Future<void> persist(SettingsData settingsData) async {
    if (kIsWeb) {
      return _persistFlutterWeb(settingsData);
    }

    Directory dir = await getApplicationDocumentsDirectory();
    String settingsFilePath = join(dir.path, _settingsFile).toString();

    String content = jsonEncode(settingsData.toJson());

    final file = File(settingsFilePath);
    await file.writeAsString(content);
  }

  /// Loads settings from persistent storage
  static Future<SettingsData> load() async {
    if (kIsWeb) {
      return _loadFlutterWeb();
    }

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
