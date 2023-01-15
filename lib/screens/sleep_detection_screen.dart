import 'package:cosinuss_lib/cosinuss_sensor.dart';
import 'package:cosinuss_lib/data_model/cosinuss_data.dart';
import 'package:early_bird/screens/sleep_detection/alarm_screen.dart';
import 'package:early_bird/screens/sleep_detection/connect_screen.dart';
import 'package:early_bird/screens/sleep_detection/toggle_enabled_screen.dart';
import 'package:early_bird/settings/settings_data.dart';
import 'package:early_bird/settings/settings_persistence_tool.dart';
import 'package:early_bird/utils/sleep_detector.dart';
import 'package:flutter/material.dart';

class SleepDetectionScreen extends StatefulWidget {
  const SleepDetectionScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SleepDetectionScreen> createState() => _SleepDetectionScreenState();
}

class _SleepDetectionScreenState extends State<SleepDetectionScreen> {
  late CosinussSensor cosinussSensor;
  late SleepDetector sleepDetector;

  bool connected = false;
  bool enabled = false;
  bool fellAsleep = false;

  @override
  void initState() {
    super.initState();
    cosinussSensor = CosinussSensor();
    sleepDetector = SleepDetector();
    connected = cosinussSensor.isConnected;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SettingsData>(
        future: SettingsPersistenceTool.load(),
        builder: (context, AsyncSnapshot<SettingsData> snapshot) {
          if (!snapshot.hasData) {
            return const _LoadingIndicator();
          }

          if (snapshot.data!.accelerometerDifference != null) {
            sleepDetector.accelerometerDifference =
                snapshot.data!.accelerometerDifference!;
          }

          if (snapshot.data!.sleepDetectionTimeMs != null) {
            sleepDetector.sleepDetectionTimeMs =
                snapshot.data!.sleepDetectionTimeMs!;
          }

          return StreamBuilder<CosinussData>(
            stream: cosinussSensor.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                connected = snapshot.data!.connected;
              }

              if (snapshot.hasData && enabled) {
                bool sleepDetectionResult =
                    sleepDetector.detectSleep(snapshot.data!);
                if (sleepDetectionResult) {
                  fellAsleep = sleepDetectionResult;
                }
              }

              if (!connected) {
                return ConnectScreen(
                  cosinussSensor: cosinussSensor,
                );
              }

              if (fellAsleep) {
                return AlarmScreen(
                  onClick: () {
                    sleepDetector.reset();
                    setState(() {
                      fellAsleep = false;
                    });
                  },
                );
              }

              return ToggleEnabledScreen(
                enabled: enabled,
                onEnabledChange: (newEnabled) {
                  setState(() {
                    enabled = newEnabled;
                  });
                  if (!newEnabled) {
                    sleepDetector.reset();
                  }
                },
              );
            },
          );
        });
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
