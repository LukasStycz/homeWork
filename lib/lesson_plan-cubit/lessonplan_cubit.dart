import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lessonplan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit() : super(const LessonPlanInitial()) {
    _loadHours();
  }

  void _loadMonday() {
    const int gestureDetectorIndex=0;
    final List<String> currentDayPlan = ["cos", "poniedziałek"];
    final List<List<Color>> cardColorList = [
      [Colors.white, Colors.black],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
    ];
    emit(LessonPlan(cardColorList, currentDayPlan,gestureDetectorIndex));
  }

  void _loadTuesday() {
    const int gestureDetectorIndex=1;

    final List<String> currentDayPlan = ["cos", "wtorek"];
    final List<List<Color>> cardColorList = [
      [Colors.black26, Colors.white],
      [Colors.white, Colors.black],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
    ];
    emit(LessonPlan(cardColorList, currentDayPlan,gestureDetectorIndex));
  }

  void _loadWendesday() {
    const int gestureDetectorIndex=2;

    final List<String> currentDayPlan = ["cos", "środa"];
    final List<List<Color>> cardColorList = [
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.white, Colors.black],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
    ];
    emit(LessonPlan(cardColorList, currentDayPlan,gestureDetectorIndex));
  }

  void _loadThursday() {
    const int gestureDetectorIndex=3;

    final List<String> currentDayPlan = ["cos", "czwartek"];
    final List<List<Color>> cardColorList = [
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.white, Colors.black],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
    ];
    emit(LessonPlan(cardColorList, currentDayPlan,gestureDetectorIndex));
  }

  void _loadFriday() {
    const int gestureDetectorIndex=4;

    final List<String> currentDayPlan = ["cos", "piątek"];
    final List<List<Color>> cardColorList = [
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.white, Colors.black],
      [Colors.black26, Colors.white],
    ];
    emit(LessonPlan(cardColorList, currentDayPlan,gestureDetectorIndex));
  }
  void _loadHours() {
    const int gestureDetectorIndex=5;

    const List<double> lessonHours = [8.00,8.45,8.55,9.40,9.50,10.35,10.45,11.30,11.45,12.30,12.45,13.30,13.40,14.25,14.35,15.20];
    final List<String> currentDayPlan = ['${lessonHours[0].toStringAsFixed(2)}-${lessonHours[1].toStringAsFixed(2)}',
      '${lessonHours[2].toStringAsFixed(2)}-${lessonHours[3].toStringAsFixed(2)}',
      '${lessonHours[4].toStringAsFixed(2)}-${lessonHours[5].toStringAsFixed(2)}',
      '${lessonHours[6].toStringAsFixed(2)}-${lessonHours[7].toStringAsFixed(2)}',
      '${lessonHours[8].toStringAsFixed(2)}-${lessonHours[9].toStringAsFixed(2)}',
      '${lessonHours[10].toStringAsFixed(2)}-${lessonHours[11].toStringAsFixed(2)}',
      '${lessonHours[12].toStringAsFixed(2)}-${lessonHours[13].toStringAsFixed(2)}',
      '${lessonHours[14].toStringAsFixed(2)}-${lessonHours[15].toStringAsFixed(2)}',
    ];
    final List<List<Color>> cardColorList = [
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.white, Colors.black],
    ];
    emit(LessonPlan(cardColorList, currentDayPlan,gestureDetectorIndex));
  }
  void changePlanLayout(int index) {
    if (index == 1) {
      _loadTuesday();
      print('dzień$index');
    } else if (index == 2) {
      _loadWendesday();
      print('dzień$index');
    } else if (index == 3) {
      _loadThursday();
      print('dzień$index');
    } else if (index == 4) {
      _loadFriday();
      print('dzień$index');
    } else if (index == 5) {
      _loadHours();
      print('dzień$index');
    } else {
      _loadMonday();
      print('dzień$index');
    }
  }

}
