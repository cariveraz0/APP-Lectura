import 'package:flutter/material.dart';

class Utils{
  static showSnackBar({
    required BuildContext context,
    required String title,
    Color? color,
    required Duration duracion
  }) {
    ScaffoldMessenger.of(
      context
    ).showSnackBar(
      SnackBar(
      content: Text(
        title, 
        style: const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold),
        ), backgroundColor: color,
        duration: duracion
      ),
    );
  }
}