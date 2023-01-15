import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({
    required this.onClick,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClick;

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with SingleTickerProviderStateMixin {
  static const animatedRings = 6;

  late AnimationController animationController;
  late Animation animation;

  Timer? vibrateTimer;

  @override
  void dispose() {
    animationController.stop();
    animationController.dispose();
    vibrateTimer?.cancel();
    super.dispose();
  }

  void vibrate() async {
    if (await Vibration.hasVibrator() != true) {
      return;
    }
    if (await Vibration.hasAmplitudeControl() == true) {
      vibrateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        Vibration.vibrate(amplitude: 128);
      });
    } else {
      vibrateTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        Vibration.vibrate();
      });
    }
  }

  @override
  void initState() {
    vibrate();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut,
      ),
    );
    animationController.repeat(
      reverse: true,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double size = min(constraints.maxHeight, constraints.maxWidth) * 0.4;
          double iconsSize = size * 0.5;

          double ringSize = size / (animatedRings * 2);

          return Center(
            child: SizedBox(
              height: size,
              width: size,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: widget.onClick,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return Ink(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          for (int i = 1; i <= animatedRings; i++)
                            BoxShadow(
                              color: Colors.blueGrey.withOpacity(
                                  animationController.value / animatedRings),
                              spreadRadius: animation.value * i * ringSize,
                            )
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.alarm,
                          size: iconsSize,
                          color: Colors.blueGrey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
