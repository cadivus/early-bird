import 'dart:math';

import 'package:early_bird/layout/app_layout.dart';
import 'package:flutter/material.dart';

typedef ChangeEnabledFunction = void Function(bool enabled);

class ToggleEnabledScreen extends StatelessWidget {
  const ToggleEnabledScreen({
    required this.enabled,
    required this.onEnabledChange,
    Key? key,
  }) : super(key: key);

  final bool enabled;
  final ChangeEnabledFunction onEnabledChange;

  @override
  Widget build(BuildContext context) {
    String title = enabled ? 'Early bird running' : 'Early bird stopped';

    IconData icon = enabled ? Icons.play_arrow : Icons.stop;
    MaterialStateProperty<Color?> color = enabled
        ? MaterialStateProperty.all(Colors.green)
        : MaterialStateProperty.all(Colors.red);

    return AppLayout(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double size = min(constraints.maxHeight, constraints.maxWidth) * 0.5;
        double iconsSize = size * 0.5;

        return Center(
          child: SizedBox(
            height: size,
            width: size,
            child: ElevatedButton(
              onPressed: () {
                onEnabledChange(!enabled);
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const CircleBorder()),
                padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                backgroundColor: color,
              ),
              child: Icon(icon, size: iconsSize),
            ),
          ),
        );
      }),
      title: title,
    );
  }
}
