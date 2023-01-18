import 'package:flutter/material.dart';

import 'colors.dart';

class ConstObjects {
  static const CircularProgressIndicator circularProgressIndicator =
      CircularProgressIndicator();
  static const SizedBox sizedBoxTwentyHeight = SizedBox(height: 20);
  static const SizedBox sizedBoxTwelveHeight = SizedBox(height: 12);
  static const int tabLength = 3;
  static const BorderRadius listListBackgroundAndTilesBorderRadius =
      BorderRadius.all(Radius.circular(12));
  static const BoxShadow listBackgroundBoxShadow = BoxShadow(blurRadius: 12);
  static const TextStyle listTextStyle = TextStyle(
    fontSize: 28,
    color: AppColors.scaffoldIconAndTextColor,
  );
  static const EdgeInsets listContainerMargin = EdgeInsets.only(
    left: 4,
    right: 4,
    top: 4,
  );
}
