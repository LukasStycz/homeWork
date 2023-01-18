part of 'lessonplan_cubit.dart';

@immutable
abstract class LessonPlanState {
  const LessonPlanState();
}

class LessonPlanInitial extends LessonPlanState {
  const LessonPlanInitial();
}

class LessonPlan extends LessonPlanState {
  final bool lessonPlanOrChangePlan;
  final int whichDayIsActive;
  final List<List<Color>> cardColorList;
  final List<String> currentDayPlan;
  final List<String> lessonPlanDaysAndHours;
  final AppLocalizations localizations;
  const LessonPlan(
      this.localizations,
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
          lessonPlanOrChangePlan == other.lessonPlanOrChangePlan &&
          whichDayIsActive == other.whichDayIsActive &&
          cardColorList == other.cardColorList &&
          currentDayPlan == other.currentDayPlan &&
          lessonPlanDaysAndHours == other.lessonPlanDaysAndHours &&
          localizations == other.localizations;

  @override
  int get hashCode =>
      lessonPlanOrChangePlan.hashCode ^
      whichDayIsActive.hashCode ^
      cardColorList.hashCode ^
      currentDayPlan.hashCode ^
      lessonPlanDaysAndHours.hashCode ^
      localizations.hashCode;
}
