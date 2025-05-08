import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final Widget child;
  final bool isSentByUser;

  const ChatBubble({super.key, required this.child, required this.isSentByUser});
  
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isSentByUser ? secondaryColor : white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isSentByUser ? const Radius.circular(15) : Radius.zero,
            bottomRight: isSentByUser ? Radius.zero : const Radius.circular(15),
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black26,
          //     blurRadius: 5,
          //   ),
          // ],
        ),
        child: child,
      ),
    );
  }
}