import 'package:flutter/material.dart';

class ScaffoldWithReturnButton extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final bool? popResult;
  const ScaffoldWithReturnButton({super.key, required this.child, this.title, this.popResult});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.keyboard_arrow_left),
          onPressed: () => Navigator.of(context).pop(popResult),
          iconSize: 40,
        ),
        title: title,
      ),
      body: child,
    );
  }
}
