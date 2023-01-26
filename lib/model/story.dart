import 'package:flutter/material.dart';

@immutable
class Story {
  final String text;
  final DateTime createdAt;

  const Story({required this.text, required this.createdAt});
}
