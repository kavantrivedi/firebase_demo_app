import 'package:flutter/material.dart';

class DisplayText extends StatelessWidget {
  final String message;
  const DisplayText({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        fontSize: 16,
      ),
    );
  }
}
