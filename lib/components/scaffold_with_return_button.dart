import 'package:flutter/material.dart';

class ScaffoldWithReturnButton extends StatelessWidget {
  final Widget child;
  final Widget? bottomBar;
  const ScaffoldWithReturnButton({super.key, required this.child, this.bottomBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(),
          iconSize: 48,
        ),
      ),
      body: child,
      bottomNavigationBar: bottomBar,
    );
  }
}
