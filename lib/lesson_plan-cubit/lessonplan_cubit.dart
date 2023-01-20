import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'lessonplan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit(this.localizations) : super(const LessonPlanInitial()) {
    lessonPlanDaysAndHours = [
      localizations.monday,
      localizations.tuesday,
      localizations.wednesday,
      localizations.thursday,
      localizations.friday,
      localizations.lessons,
    ];
    _loadHours(
      _initialValueIsTilesClickable,
      _initialValueWhichDayIsActive,
    );
  }

  final AppLocalizations localizations;
  List<String> lessonPlanDaysAndHours = [];
  int _whichDayIsActiveForUndoSetNewPlan =
      _initialValueOfWhichDayIsActiveForUndoSetNewPlan;
  List<String> _lessonPlanListForUndoSetNewPlan =
      _initialValueOfLessonPlanListForUndoSetNewPlan;

  Future<void> _loadDays(bool isTilesClickable,
      int whichDayIsActive,) async {
    // tak teraz mysle,to sharedPreferences moglbys stworzyc gdzies wyzej i przekazywac w constructorze do cubita, zeby za kazdym razem nie robic await
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentDayPlan =
        prefs.getStringList(lessonPlanKeys[whichDayIsActive]) ??
            defaultLessonPlan;
    final List<CardColors> cardColorList = _loadCardColorList(whichDayIsActive);
    emit(LessonPlan(
      localizations,
      lessonPlanDaysAndHours,
      cardColorList,
      currentDayPlan,
      whichDayIsActive,
      isTilesClickable,
    ));
  }

  void _loadHours(bool isTilesClickable,
      int whichDayIsActive,) {

    final List<String> currentDayPlan = lessonHours.map((
        LessonHour lessonHour) =>
    "${lessonHour.startTime.hour}:${lessonHour.startTime.minute}-${lessonHour
        .endTime.hour}:${lessonHour.endTime.minute}"
    ).toList();

    final List<CardColors> cardColorList = _loadCardColorList(whichDayIsActive);
    emit(LessonPlan(
      localizations,
      lessonPlanDaysAndHours,
      cardColorList,
      currentDayPlan,
      whichDayIsActive,
      isTilesClickable,
    ));
  }

  void changePlanLayout(int whichDayIsActive,
      bool isTilesClickable,) {
    if (whichDayIsActive == 5) {
      _loadHours(
        isTilesClickable,
        whichDayIsActive,
      );
      print('dzień$whichDayIsActive');
    } else {
      _loadDays(
        isTilesClickable,
        whichDayIsActive,
      );
      print('dzień$whichDayIsActive');
    }
  }

  List<CardColors> _loadCardColorList(int whichDayIsActive) {
    List<CardColors> cardColorList = [
      const CardColors(
          tilesBackgroundColor: AppColors.listAndTilesBackgroundColor,
          tilesTextColor: AppColors.tilesTextAndAppBackgroundColor),
      const CardColors(
          tilesBackgroundColor: AppColors.listAndTilesBackgroundColor,
          tilesTextColor: AppColors.tilesTextAndAppBackgroundColor),
      const CardColors(
          tilesBackgroundColor: AppColors.listAndTilesBackgroundColor,
          tilesTextColor: AppColors.tilesTextAndAppBackgroundColor),
      const CardColors(
          tilesBackgroundColor: AppColors.listAndTilesBackgroundColor,
          tilesTextColor: AppColors.tilesTextAndAppBackgroundColor),
      const CardColors(
          tilesBackgroundColor: AppColors.listAndTilesBackgroundColor,
          tilesTextColor: AppColors.tilesTextAndAppBackgroundColor),
      const CardColors(
          tilesBackgroundColor: AppColors.listAndTilesBackgroundColor,
          tilesTextColor: AppColors.tilesTextAndAppBackgroundColor),
    ];
    cardColorList.insert(
      whichDayIsActive,
      const CardColors(
        tilesBackgroundColor: AppColors.tilesTextAndAppBackgroundColor,
        tilesTextColor: AppColors.scaffoldIconAndTextColor,
      ),
    );
    return cardColorList;
  }

  bool clickableTilesSwitch(isTilesClickable,
      List<TextEditingController> controller,
      int whichDayIsActive,
      List<String> currentDayPlan,) {
    // clickableTiles sugeruje, ze to nie bedzie boolean tylko List<Tiles>
    // poza tym po co w ogóle Ci ta zmienna? Przeciez to jest to samo co isTilesClickable, mozesz ja calkiem wyejbac
    final bool clickableTiles = isTilesClickable == true;
    // zmienne notClickableTiles i redoClickableTiles - bez sensu wyjeb je
    const bool notClickableTiles = false;
    const bool redoClickableTiles = true;
    if (clickableTiles) {
      // uzywaj namedParameters czyli z {}, jak nie wiesz o co chodzi to wpisz w google flutter named parameters
      changePlanLayout(whichDayIsActive, notClickableTiles);
      return notClickableTiles;
    } else {
      _lessonPlanListForUndoSetNewPlan = currentDayPlan;
      _whichDayIsActiveForUndoSetNewPlan = whichDayIsActive;
      List<String> newPlan = [];
      for (int i = _currentListItem; i <= _listLength; i++) {
        newPlan.add(controller[i].text);
        _setNewPlan(
          newPlan,
          whichDayIsActive,
        );
      }
      print(newPlan);
      changePlanLayout(whichDayIsActive, redoClickableTiles);
      return redoClickableTiles;
    }
  }

  Future<void> undoSetNewPlan(whichDayIsActive,
      tilesClickableOrNot,) async {
    // nie moze byc po prostu isUndoNeeded?
    final bool checkIfUndoIsNeeded = (_lessonPlanListForUndoSetNewPlan !=
        _initialValueOfLessonPlanListForUndoSetNewPlan) &&
        (_whichDayIsActiveForUndoSetNewPlan !=
            _initialValueOfWhichDayIsActiveForUndoSetNewPlan);
    if (checkIfUndoIsNeeded) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        lessonPlanKeys[_whichDayIsActiveForUndoSetNewPlan],
        _lessonPlanListForUndoSetNewPlan,
      );
      changePlanLayout(
        whichDayIsActive,
        tilesClickableOrNot,
      );
    }
  }

  Future<void> _setNewPlan(List<String> newPlan,
      int whichDayIsActive,) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      lessonPlanKeys[whichDayIsActive],
      newPlan,
    );
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
];

const bool _initialValueIsTilesClickable = true;
const int _initialValueWhichDayIsActive = 5;
const int _initialValueOfWhichDayIsActiveForUndoSetNewPlan = 100;
const List<String> _initialValueOfLessonPlanListForUndoSetNewPlan = [];
NumberFormat _hourFormat = NumberFormat("00");
const int _currentListItem = 0;
const int _listLength = 7;
