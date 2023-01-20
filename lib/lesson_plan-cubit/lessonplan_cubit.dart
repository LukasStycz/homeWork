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

  Future<void> _loadDays(
    bool isTilesClickable,
    int whichDayIsActive,
  ) async {
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

  void _loadHours(
    bool isTilesClickable,
    int whichDayIsActive,
  ) {
    // currentDayPlan powinno byc zmienna gdzie swyzej zeby sie nie tworzyla nowa zmienna za kazdym razem gdy funkcja loadHours jest wolana
    final List<String> currentDayPlan = [
      '${_hourFormat.format(lessonHours[0].hour)}.${_hourFormat.format(lessonHours[0].minute)}-${_hourFormat.format(lessonHours[1].hour)}.${lessonHours[1].minute}',
      '${_hourFormat.format(lessonHours[2].hour)}.${lessonHours[2].minute}-${_hourFormat.format(lessonHours[3].hour)}.${lessonHours[3].minute}',
      '${_hourFormat.format(lessonHours[4].hour)}.${lessonHours[4].minute}-${lessonHours[5].hour}.${lessonHours[5].minute}',
      '${lessonHours[6].hour}.${lessonHours[6].minute}-${lessonHours[7].hour}.${lessonHours[7].minute}',
      '${lessonHours[8].hour}.${lessonHours[8].minute}-${lessonHours[9].hour}.${lessonHours[9].minute}',
      '${lessonHours[10].hour}.${lessonHours[10].minute}-${lessonHours[11].hour}.${lessonHours[11].minute}',
      '${lessonHours[12].hour}.${lessonHours[12].minute}-${lessonHours[13].hour}.${lessonHours[13].minute}',
      '${lessonHours[14].hour}.${lessonHours[14].minute}-${lessonHours[15].hour}.${lessonHours[15].minute}',
    ];
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

  void changePlanLayout(
    int whichDayIsActive,
    bool isTilesClickable,
  ) {
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

  bool  clickableTilesSwitch(
    isTilesClickable,
    List<TextEditingController> controller,
    int whichDayIsActive,
    List<String> currentDayPlan,
  ) {
    // clickableTiles sugeruje, ze to nie bedzie boolean tylko List<Tiles>
    // poza tym po co w ogóle Ci ta zmienna? Przeciez to jest to samo co isTilesClickable, mozesz ja calkiem wyejbac
    final bool clickableTiles = isTilesClickable == true;
    // zmienne notClickableTiles i redoClickableTiles - bez sensu wyjeb je
    const bool notClickableTiles = false;
    const bool redoClickableTiles = true;
    if (clickableTiles) {
      // uzywaj namedParameters czyli z {}, jak nie wiesz o co chodzi to wpisz w google flutter named parameters
      changePlanLayout(whichDayIsActive,notClickableTiles);
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
      changePlanLayout(whichDayIsActive,redoClickableTiles);
      return redoClickableTiles;
    }
  }

  Future<void> undoSetNewPlan(whichDayIsActive,tilesClickableOrNot,) async {
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
      changePlanLayout(whichDayIsActive,tilesClickableOrNot,);
    }
  }

  Future<void> _setNewPlan(
    List<String> newPlan,
    int whichDayIsActive,
  ) async {
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

const List<TimeOfDay> lessonHours = [
  TimeOfDay(hour: 8, minute: 0),
  TimeOfDay(hour: 8, minute: 45),
  TimeOfDay(hour: 8, minute: 55),
  TimeOfDay(hour: 9, minute: 40),
  TimeOfDay(hour: 9, minute: 50),
  TimeOfDay(hour: 10, minute: 35),
  TimeOfDay(hour: 10, minute: 45),
  TimeOfDay(hour: 11, minute: 30),
  TimeOfDay(hour: 11, minute: 45),
  TimeOfDay(hour: 12, minute: 30),
  TimeOfDay(hour: 12, minute: 45),
  TimeOfDay(hour: 13, minute: 30),
  TimeOfDay(hour: 13, minute: 40),
  TimeOfDay(hour: 14, minute: 25),
  TimeOfDay(hour: 14, minute: 35),
  TimeOfDay(hour: 15, minute: 20),
  TimeOfDay(hour: 15, minute: 50),
];

const bool _initialValueIsTilesClickable = true;
const int _initialValueWhichDayIsActive = 5;
const int _initialValueOfWhichDayIsActiveForUndoSetNewPlan = 100;
const List<String> _initialValueOfLessonPlanListForUndoSetNewPlan = [];
NumberFormat _hourFormat = NumberFormat("00");
const int _currentListItem =0;
const int _listLength =7;