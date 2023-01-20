import 'package:flutter/material.dart';
import 'colors.dart';
import 'dimens.dart';

class ConstObjects {
  static const CircularProgressIndicator circularProgressIndicator =
      CircularProgressIndicator();
  static const SizedBox sizedBoxTwentyHeight =
      SizedBox(height: AppDimens.heightOrWidthMini);
  static const BorderRadius listAndTilesBorderRadius =
      BorderRadius.all(Radius.circular(AppDimens.insetsBig));
  static const BorderRadius listBackgroundBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(AppDimens.insetsBig),
      topRight: Radius.circular(AppDimens.insetsBig));
  static const BoxShadow listBackgroundBoxShadow =
      BoxShadow(blurRadius: AppDimens.insetsBig);
  static const TextStyle listTextStyle = TextStyle(
    fontSize: AppDimens.fontBig,
    color: AppColors.scaffoldIconAndTextColor,
  );
  static const EdgeInsets listContainerMargin = EdgeInsets.only(
    left: AppDimens.insetsSmall,
    right: AppDimens.insetsSmall,
    top: AppDimens.insetsSmall,
  );
  static const EdgeInsets paddingTopTwelve =
      EdgeInsets.only(top: AppDimens.insetsMedium);
  static const String title = 'Homework App';
  static const int tabLength = 3;
  static const int lessonTile = 5;
  static const List<String> lessonPlanKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
  ];
  static const List<String> defaultLessonPlan = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
  ];
}

class LessonHour {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const LessonHour({
    required this.startTime,
    required this.endTime,
  });
}

const lessonHours = [
  LessonHour(
    startTime: TimeOfDay(hour: 8, minute: 0),
    endTime: TimeOfDay(hour: 8, minute: 45),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 8, minute: 55),
    endTime: TimeOfDay(hour: 9, minute: 40),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 9, minute: 50),
    endTime: TimeOfDay(hour: 10, minute: 35),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 10, minute: 45),
    endTime: TimeOfDay(hour: 11, minute: 30),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 11, minute: 45),
    endTime: TimeOfDay(hour: 12, minute: 30),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 12, minute: 45),
    endTime: TimeOfDay(hour: 13, minute: 30),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 13, minute: 40),
    endTime: TimeOfDay(hour: 14, minute: 25),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 14, minute: 35),
    endTime: TimeOfDay(hour: 15, minute: 20),
  ),
  LessonHour(
    startTime: TimeOfDay(hour: 23, minute: 59),
    endTime: TimeOfDay(hour: 23, minute: 59),
  ),
];
