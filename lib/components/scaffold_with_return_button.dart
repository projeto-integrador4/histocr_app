import 'package:flutter/material.dart';

class ScaffoldWithReturnButton extends StatelessWidget {
  final Widget child;
  final Widget? title;
  final bool? popResult;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBarBottom;
  
  const ScaffoldWithReturnButton(
      {super.key,
      required this.child,
      this.title,
      this.popResult,
      this.bottomNavigationBar,
      this.appBarBottom});

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
        bottom: appBarBottom,
      ),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
