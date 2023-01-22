import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/colors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constObjects.dart';
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
  int _whichTileIsActiveForUndoSetNewPlan =
      _initialValueOfWhichDayIsActiveForUndoSetNewPlan;
  List<String> _lessonPlanListForUndoSetNewPlan =
      _initialValueOfLessonPlanListForUndoSetNewPlan;


  static const bool tilesAreNotClickable = false;
  static const bool tilesAreClickable = true;
  static const bool _initialValueIsTilesClickable = true;
  static const int _initialValueWhichDayIsActive = 5;
  static const int _initialValueOfWhichDayIsActiveForUndoSetNewPlan = 100;
  static const List<String> _initialValueOfLessonPlanListForUndoSetNewPlan = [];
  static final NumberFormat _hourFormat = NumberFormat("00");
  static const int _currentListItem = 0;
  static const int _listLength = 7;

  Future<void> _loadDays(
    bool isTilesClickable,
    int whichTileIsActive,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentDayPlan =
        prefs.getStringList(ConstObjects.lessonPlanKeys[whichTileIsActive]) ??
            ConstObjects.defaultLessonPlan;
    final List<CardColors> cardColorList =
        _loadCardColorList(whichTileIsActive);
    emit(LessonPlan(
      localizations,
      lessonPlanDaysAndHours,
      cardColorList,
      currentDayPlan,
      whichTileIsActive,
      isTilesClickable,
    ));
  }

  void _loadHours(
    bool isTilesClickable,
    int whichTileIsActive,
  ) {
    final List<CardColors> cardColorList =
        _loadCardColorList(whichTileIsActive);
    final  List<String> currentDayPlan = _lessonHours();

    emit(LessonPlan(
      localizations,
      lessonPlanDaysAndHours,
      cardColorList,
      currentDayPlan,
      whichTileIsActive,
      isTilesClickable,
    ));
  }

  void changePlanLayout(
    int whichTileIsActive,
    bool isTilesClickable,
  ) {
    if (whichTileIsActive == ConstObjects.lessonTile) {
      _loadHours(
        isTilesClickable,
        whichTileIsActive,
      );
    } else {
      _loadDays(
        isTilesClickable,
        whichTileIsActive,
      );
    }
  }

  List<CardColors> _loadCardColorList(int whichTileIsActive) {
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
      whichTileIsActive,
      const CardColors(
        tilesBackgroundColor: AppColors.tilesTextAndAppBackgroundColor,
        tilesTextColor: AppColors.scaffoldIconAndTextColor,
      ),
    );
    return cardColorList;
  }

  void saveOrUndoSaveNewPlan(
    bool isTilesClickable,
    List<TextEditingController> controller,
    int whichTileIsActive,
    List<String> currentDayPlan,
  ) {
    if (isTilesClickable) {
      _showTextFieldsForSetNewPlan(whichTileIsActive);
    } else {
      _setNewPlanAnbBackupForUndo(
        currentDayPlan,
        whichTileIsActive,
        controller,
      );
    }
  }

  void _showTextFieldsForSetNewPlan(int whichTileIsActive) {
    changePlanLayout(whichTileIsActive, tilesAreNotClickable);
  }

  void _setNewPlanAnbBackupForUndo(
    List<String> currentDayPlan,
    int whichTileIsActive,
    List<TextEditingController> controller,
  ) {
    _backupPlanForUndo(
      currentDayPlan,
      whichTileIsActive,
    );
    _setNewPlan(
      whichTileIsActive,
      controller,
    );
  }

  void _backupPlanForUndo(
    List<String> currentDayPlan,
    int whichTileIsActive,
  ) {
    _lessonPlanListForUndoSetNewPlan = currentDayPlan;
    _whichTileIsActiveForUndoSetNewPlan = whichTileIsActive;
  }

  Future<void> _setNewPlan(
      int whichTileIsActive,
      List<TextEditingController> controller,
      ) async {
    List<String> newPlan = [];
    for (int i = _currentListItem; i <= _listLength; i++) {
      newPlan.add(controller[i].text);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        ConstObjects.lessonPlanKeys[whichTileIsActive],
        newPlan,
      );
    }
    changePlanLayout(whichTileIsActive, tilesAreClickable);
  }

  Future<void> undoSetNewPlan(
    whichTileIsActive,
    tilesClickableOrNot,
  ) async {
    final bool checkIfUndoIsNeeded = (_lessonPlanListForUndoSetNewPlan !=
            _initialValueOfLessonPlanListForUndoSetNewPlan) &&
        (_whichTileIsActiveForUndoSetNewPlan !=
            _initialValueOfWhichDayIsActiveForUndoSetNewPlan);
    if (checkIfUndoIsNeeded) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        ConstObjects.lessonPlanKeys[_whichTileIsActiveForUndoSetNewPlan],
        _lessonPlanListForUndoSetNewPlan,
      );
      changePlanLayout(
        whichTileIsActive,
        tilesClickableOrNot,
      );
    }
  }
  List<String>_lessonHours() {
  List<String> lessonHoursList =  lessonHours
        .map((LessonHour lessonHour) =>
    "${_hourFormat.format(lessonHour.startTime.hour)}"
        ":${_hourFormat.format(lessonHour.startTime.minute)}"
        "-${_hourFormat.format(lessonHour.endTime.hour)}"
        ":${_hourFormat.format(lessonHour.endTime.minute)}")
        .toList();
  lessonHoursList.removeLast();
  return lessonHoursList;
  }
}
