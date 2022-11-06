import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lessonplan_state.dart';

class LessonPlanCubit extends Cubit<LessonPlanState> {
  LessonPlanCubit() : super(const LessonPlanInitial()) {
    _loadMonday();
  }

  void _loadMonday() {
    final List<int> lessonHours = [];
    final List<String> currentDayPlan = ["kaka", "popo"];
    final List<List<Color>> cardColorList = [
      [Colors.white, Colors.black26],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
      [Colors.black26, Colors.white],
    ];
    emit(LessonPlanMonday(cardColorList, currentDayPlan, lessonHours));
  }
}
