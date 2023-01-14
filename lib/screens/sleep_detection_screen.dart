import 'package:cosinuss_lib/cosinuss_sensor.dart';
import 'package:cosinuss_lib/data_model/cosinuss_data.dart';
import 'package:early_bird/screens/sleep_detection/alarm_screen.dart';
import 'package:early_bird/screens/sleep_detection/connect_screen.dart';
import 'package:early_bird/screens/sleep_detection/toggle_enabled_screen.dart';
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
  CosinussSensor cosinussSensor = CosinussSensor();
  SleepDetector sleepDetector = SleepDetector();

  bool connected = false;
  bool enabled = false;
  bool fellAsleep = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CosinussData>(
      stream: cosinussSensor.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          connected = snapshot.data!.connected;
        }

        if (snapshot.hasData && enabled) {
          bool sleepDetectionResult = sleepDetector.detectSleep(snapshot.data!);
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
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
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
