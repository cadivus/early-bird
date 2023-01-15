import 'package:early_bird/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget implements PreferredSizeWidget {
  const AppLayout({
    Key? key,
    required this.body,
    required this.title,
    this.showSettingsButton = true,
    this.showOnBack,
  }) : super(key: key);

  final Widget body;
  final String title;
  final bool showSettingsButton;
  final Widget? showOnBack;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return _ConditionalBack(
      showOnBack: showOnBack,
      child: Scaffold(
        appBar: AppBar(
          leading: showOnBack != null
              ? IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => showOnBack!,
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                )
              : null,
          title: Text(title),
          actions: <Widget>[
            Visibility(
              visible: showSettingsButton,
              child: IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
              ),
            )
          ],
        ),
        body: body,
      ),
    );
  }
}

class _ConditionalBack extends StatelessWidget {
  const _ConditionalBack({
    required this.child,
    this.showOnBack,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Widget? showOnBack;

  Future<bool> onWillPop(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => showOnBack!,
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (showOnBack == null) {
      return child;
    }

    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: child,
    );
  }
}
