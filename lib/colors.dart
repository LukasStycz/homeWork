import 'package:flutter/material.dart';

class AppColors {
  static const Color scaffoldIconAndTextColor = Colors.white;
  static const Color tilesTextAndAppBackgroundColor = Colors.indigoAccent;
  static const Color listAndTilesBackgroundColor = Colors.black26;
}

class CardColors {
  const CardColors({
    required this.tilesBackgroundColor,
    required this.tilesText,
  });
  final Colors tilesText;
  final Colors tilesBackgroundColor;
}
