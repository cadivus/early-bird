import 'package:early_bird/layout/app_layout.dart';
import 'package:early_bird/screens/sleep_detection_screen.dart';
import 'package:early_bird/settings/settings_data.dart';
import 'package:early_bird/settings/settings_persistence_tool.dart';
import 'package:early_bird/utils/sleep_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_number_picker.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int sleepDetectionTimeMs;
  late int accelerometerDifference;

  @override
  void initState() {
    super.initState();

    // Load default values
    SleepDetector sleepDetector = SleepDetector();
    sleepDetectionTimeMs = sleepDetector.sleepDetectionTimeMs;
    accelerometerDifference = sleepDetector.accelerometerDifference;
  }

  void persistSetting() {
    SettingsPersistenceTool.persist(SettingsData(
      accelerometerDifference: accelerometerDifference,
      sleepDetectionTimeMs: sleepDetectionTimeMs,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      showSettingsButton: false,
      showOnBack: const SleepDetectionScreen(),
      title: 'Settings',
      body: FutureBuilder<SettingsData>(
        future: SettingsPersistenceTool.load(),
        builder: (context, AsyncSnapshot<SettingsData> snapshot) {
          if (!snapshot.hasData) {
            return const _LoadingIndicator();
          }

          if (snapshot.data!.accelerometerDifference != null) {
            accelerometerDifference = snapshot.data!.accelerometerDifference!;
          }

          if (snapshot.data!.sleepDetectionTimeMs != null) {
            sleepDetectionTimeMs = snapshot.data!.sleepDetectionTimeMs!;
          }

          return SettingsList(
            sections: [
              SettingsSection(
                title: const Text('Sleep detection settings'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: const Icon(Icons.timelapse),
                    title: const Text('Sleep detection time (s)'),
                    value: Text((sleepDetectionTimeMs ~/ 1000).toString()),
                    onPressed: (BuildContext context) async {
                      showMaterialNumberPicker(
                        context: context,
                        title: 'Pick sleep detection time (s)',
                        maxNumber: 500,
                        minNumber: 0,
                        selectedNumber: (sleepDetectionTimeMs ~/ 1000),
                        onChanged: (value) {
                          setState(() {
                            sleepDetectionTimeMs = value * 1000;
                          });
                          persistSetting();
                        },
                      );
                    },
                  ),
                  SettingsTile.navigation(
                    leading: const Icon(Icons.directions_walk),
                    title: const Text('Movement threshold'),
                    value: Text(accelerometerDifference.toString()),
                    onPressed: (BuildContext context) async {
                      showMaterialNumberPicker(
                        context: context,
                        title: 'Pick movement threshold',
                        maxNumber: 250,
                        minNumber: 0,
                        selectedNumber: accelerometerDifference,
                        onChanged: (value) {
                          setState(() {
                            accelerometerDifference = value;
                          });
                          persistSetting();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        }
      ),
    );
  }
}
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          height: 30,
          width: 30,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
