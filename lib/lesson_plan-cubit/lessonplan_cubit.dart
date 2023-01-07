import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'lessonplan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit(this.localizations) : super(const LessonPlanInitial()) {
    lessonPlanDaysAndHours = [
      localizations.fourthString,
      localizations.fifthString,
      localizations.sixthString,
      localizations.seventhString,
      localizations.eighthString,
      localizations.ninthString,
    ];
    _loadHours(initialValueFirstParameter, initialValueSecondParameter);
  }

  final AppLocalizations localizations;

  List<String> lessonPlanDaysAndHours = [];

  int _whichDayIsActiveForUndoSetNewPlan =
      initialValueOfWhichDayIsActiveForUndoSetNewPlan;
  List<String> _lessonPlanListForUndoSetNewPlan =
      initialValueOfLessonPlanListForUndoSetNewPlan;

  Future<void> _loadDays(bool lessonPlanOrChangePlan, int index) async {
    final int whichDayIsActive = index;
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentDayPlan =
        prefs.getStringList(lessonPlanKeys[whichDayIsActive]) ??
            defaultLessonPlan;
    final List<List<Color>> cardColorList =
        _loadCardColorList(whichDayIsActive);
    emit(LessonPlan(lessonPlanDaysAndHours, cardColorList, currentDayPlan,
        whichDayIsActive, lessonPlanOrChangePlan));
  }

  void _loadHours(bool lessonPlanOrChangePlan, int index) {
    final int whichDayIsActive = index;
    final List<String> currentDayPlan = [
      '${lessonHours[0].toStringAsFixed(2)}-${lessonHours[1].toStringAsFixed(2)}',
      '${lessonHours[2].toStringAsFixed(2)}-${lessonHours[3].toStringAsFixed(2)}',
      '${lessonHours[4].toStringAsFixed(2)}-${lessonHours[5].toStringAsFixed(2)}',
      '${lessonHours[6].toStringAsFixed(2)}-${lessonHours[7].toStringAsFixed(2)}',
      '${lessonHours[8].toStringAsFixed(2)}-${lessonHours[9].toStringAsFixed(2)}',
      '${lessonHours[10].toStringAsFixed(2)}-${lessonHours[11].toStringAsFixed(2)}',
      '${lessonHours[12].toStringAsFixed(2)}-${lessonHours[13].toStringAsFixed(2)}',
      '${lessonHours[14].toStringAsFixed(2)}-${lessonHours[15].toStringAsFixed(2)}',
    ];
    final List<List<Color>> cardColorList =
        _loadCardColorList(whichDayIsActive);

    emit(LessonPlan(lessonPlanDaysAndHours, cardColorList, currentDayPlan,
        whichDayIsActive, lessonPlanOrChangePlan));
  }

  void changePlanLayout(int index, bool lessonPlanOrChangePlan) {
    if (index == 5) {
      _loadHours(lessonPlanOrChangePlan, index);
      print('dzień$index');
    } else {
      _loadDays(lessonPlanOrChangePlan, index);
      print('dzień$index');
    }
  }

  List<List<Color>> _loadCardColorList(int whichDayIsActive) {
    List<List<Color>> cardColorList = [
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
      [Colors.black26, Colors.indigoAccent],
    ];

    cardColorList.insert(whichDayIsActive, [Colors.indigoAccent, Colors.white]);

    return cardColorList;
  }

  bool activationOrDeactivationDaysAndHoursGestureDetector(
    lessonPlanOrChangePlan,
    List<TextEditingController> controller,
    int whichDayIsActive,
    List<String> currentDayPlan,
  ) {
    if (lessonPlanOrChangePlan == true) {
      return false;
    } else {
      _lessonPlanListForUndoSetNewPlan = currentDayPlan;
      _whichDayIsActiveForUndoSetNewPlan = whichDayIsActive;
      List<String> newPlan = [];
      for (int i = 0; i <= 7; i++) {
        newPlan.add(controller[i].text);
        _setNewPlan(
          newPlan,
          whichDayIsActive,
        );
      }
      print(newPlan);
      return true;
    }
  }

  Future<void> undoSetNewPlan() async {
    if ((_lessonPlanListForUndoSetNewPlan !=
            initialValueOfLessonPlanListForUndoSetNewPlan) &&
        (_whichDayIsActiveForUndoSetNewPlan !=
            initialValueOfWhichDayIsActiveForUndoSetNewPlan)) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          lessonPlanKeys[_whichDayIsActiveForUndoSetNewPlan],
          _lessonPlanListForUndoSetNewPlan);
    }
  }

  Future<void> _setNewPlan(
    List<String> newPlan,
    int whichDayIsActive,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(lessonPlanKeys[whichDayIsActive], newPlan);
  }
}

const List<String> lessonPlanKeys = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
];

const List<String> defaultLessonPlan = [
  'a',
  'b',
  'c',
  'd',
  'e',
  'f',
  'g',
  'h',
];

const List<double> lessonHours = [
  8.00,
  8.45,
  8.55,
  9.40,
  9.50,
  10.35,
  10.45,
  11.30,
  11.45,
  12.30,
  12.45,
  13.30,
  13.40,
  14.25,
  14.35,
  15.20,
  15.50,
];

const bool initialValueFirstParameter = true;

const int initialValueSecondParameter = 5;

const int initialValueOfWhichDayIsActiveForUndoSetNewPlan = 100;

const List<String> initialValueOfLessonPlanListForUndoSetNewPlan = [];
