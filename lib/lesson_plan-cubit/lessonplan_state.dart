part of 'lessonplan_cubit.dart';

@immutable
abstract class LessonPlanState {
  const LessonPlanState();
}

class LessonPlanInitial extends LessonPlanState {
  const LessonPlanInitial();
}

class LessonPlan extends LessonPlanState {
  final List<List<Color>> cardColorList;
  final List<String> currentDayPlan;


  const LessonPlan(
       this.cardColorList,this.currentDayPlan );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonPlan &&
          runtimeType == other.runtimeType &&
          cardColorList == other.cardColorList &&
          currentDayPlan == other.currentDayPlan;

  @override
  int get hashCode => cardColorList.hashCode ^ currentDayPlan.hashCode;
}
