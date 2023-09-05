import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;

  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  static show(BuildContext context, {required String errorMessage}) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        errorMessage: errorMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
