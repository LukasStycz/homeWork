part of 'lessonplan_cubit.dart';

@immutable
abstract class LessonPlanState {
  const LessonPlanState();
}

class LessonPlanInitial extends LessonPlanState {
  const LessonPlanInitial();
}

class LessonPlan extends LessonPlanState {
  final List<String> lessonPlanDaysAndHours;
  final bool lessonPlanOrChangePlan;
  final int whichDayIsActive;
  final List<List<Color>> cardColorList;
  final List<String> currentDayPlan;

  const LessonPlan(
    this.lessonPlanDaysAndHours,
    this.cardColorList,
    this.currentDayPlan,
    this.whichDayIsActive,
    this.lessonPlanOrChangePlan,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonPlan &&
          runtimeType == other.runtimeType &&
          lessonPlanDaysAndHours == other.lessonPlanDaysAndHours &&
          lessonPlanOrChangePlan == other.lessonPlanOrChangePlan &&
          whichDayIsActive == other.whichDayIsActive &&
          cardColorList == other.cardColorList &&
          currentDayPlan == other.currentDayPlan;

  @override
  int get hashCode =>
      lessonPlanDaysAndHours.hashCode ^
      lessonPlanOrChangePlan.hashCode ^
      whichDayIsActive.hashCode ^
      cardColorList.hashCode ^
      currentDayPlan.hashCode;
}
