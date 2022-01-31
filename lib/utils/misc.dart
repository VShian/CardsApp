import 'package:flutter/material.dart';

void toast(message, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
  ));
}
