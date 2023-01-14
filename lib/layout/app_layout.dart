import "package:flutter/material.dart";

class AppLayout extends StatelessWidget implements PreferredSizeWidget {
  const AppLayout({
    Key? key,
    required this.body,
    required this.title,
    this.showBackButton = false,
  }) : super(key: key);

  final Widget body;
  final String title;
  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),
              )
            : null,
        title: Text(title),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              print("Test");
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: body,
    );
  }
}
