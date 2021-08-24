import 'package:flutter/material.dart';

void _showToast(BuildContext context) {
  final scaffold = Scaffold.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: const Text('Updating..'),
    ),
  );
}
