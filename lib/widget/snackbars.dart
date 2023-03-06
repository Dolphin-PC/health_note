import 'package:flutter/material.dart';

class Snackbars {
  static textSnackbar({required String msg}) {
    return SnackBar(
      content: Text(msg),
    );
  }
}
