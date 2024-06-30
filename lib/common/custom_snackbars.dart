import 'package:flutter/material.dart';

class CustomSnackBars {
  static SnackBar successSnackBar(String message) {
    return SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.green,
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
    );
  }

  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red.shade500,
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
    );
  }

  static SnackBar infoSnackBar(String message) {
    return SnackBar(
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.white,
      content: Text(message,style: const TextStyle(color: Colors.black),),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
    );
  }
}
