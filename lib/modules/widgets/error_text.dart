import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final dynamic error;
  final StackTrace? stackTrace;

  const ErrorText(
    this.error, {
    super.key,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SelectableText(error.toString() + (stackTrace != null ? '\n\n$stackTrace' : '')),
    );
  }
}
