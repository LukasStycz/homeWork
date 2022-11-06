part of 'lessonplan_cubit.dart';

@immutable
abstract class LessonPlanState {
  const LessonPlanState();
}

class LessonPlanInitial extends LessonPlanState {
  const LessonPlanInitial();
}

class LessonPlanMonday extends LessonPlanState {
  final List<List<Color>> cardColorList;
  final List<String> currentDayPlan;
  final List<int> lessonHours;

  const LessonPlanMonday(
       this.cardColorList,this.currentDayPlan,this.lessonHours );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonPlanMonday &&
          runtimeType == other.runtimeType &&
          cardColorList == other.cardColorList &&
          currentDayPlan == other.currentDayPlan &&
          lessonHours == other.lessonHours;

  @override
  int get hashCode =>
      cardColorList.hashCode ^ currentDayPlan.hashCode ^ lessonHours.hashCode;
}
