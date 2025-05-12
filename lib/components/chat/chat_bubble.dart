import 'package:flutter/material.dart';
import 'package:histocr_app/theme/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final Widget child;
  final bool isUserMessage;

  const ChatBubble(
      {super.key, required this.child, required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: isUserMessage ? secondaryColor : white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isUserMessage ? const Radius.circular(15) : Radius.zero,
            bottomRight:
                isUserMessage ? Radius.zero : const Radius.circular(15),
          ),
        ),
        child: child,
      ),
    );
  }
}
