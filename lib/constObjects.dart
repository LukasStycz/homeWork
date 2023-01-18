import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimens.dart';

class ConstObjects {
  static const CircularProgressIndicator circularProgressIndicator =
      CircularProgressIndicator();
  static const SizedBox sizedBoxTwentyHeight = SizedBox(height: AppDimens.heightOrWidthMini);
  static const BorderRadius listAndTilesBorderRadius =
      BorderRadius.all(Radius.circular(AppDimens.insetsBig));
  static const BorderRadius listBackgroundBorderRadius =
  BorderRadius.only(topLeft: Radius.circular(AppDimens.insetsBig),topRight: Radius.circular(AppDimens.insetsBig));
  static const BoxShadow listBackgroundBoxShadow = BoxShadow(blurRadius: AppDimens.insetsBig);
  static const TextStyle listTextStyle = TextStyle(
    fontSize: AppDimens.fontBig,
    color: AppColors.scaffoldIconAndTextColor,
  );
  static const EdgeInsets listContainerMargin = EdgeInsets.only(
    left: AppDimens.insetsSmall,
    right: AppDimens.insetsSmall,
    top: AppDimens.insetsSmall,
  );
  static const EdgeInsets paddingTopTwelve = EdgeInsets.only(top: AppDimens.insetsMedium);
  static const String title = 'Homework App';
  static const int tabLength = 3;

}
