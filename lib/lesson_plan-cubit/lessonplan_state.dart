part of 'lessonplan_cubit.dart';

@immutable
abstract class LessonPlanState {
  const LessonPlanState();
}

class LessonPlanInitial extends LessonPlanState {
  const LessonPlanInitial();
}

class LessonPlan extends LessonPlanState {
  final bool isTilesClickable;
  final int whichTileIsActive;
  final List<CardColors> cardColorList;
  final List<String> currentDayPlan;
  final List<String> lessonPlanDaysAndHours;
  final AppLocalizations localizations;
  const LessonPlan(
      this.localizations,
    this.lessonPlanDaysAndHours,
    this.cardColorList,
    this.currentDayPlan,
    this.whichTileIsActive,
    this.isTilesClickable,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonPlan &&
          runtimeType == other.runtimeType &&
          isTilesClickable == other.isTilesClickable &&
          whichTileIsActive == other.whichTileIsActive &&
          cardColorList == other.cardColorList &&
          currentDayPlan == other.currentDayPlan &&
          lessonPlanDaysAndHours == other.lessonPlanDaysAndHours &&
          localizations == other.localizations;

  @override
  int get hashCode =>
      isTilesClickable.hashCode ^
      whichTileIsActive.hashCode ^
      cardColorList.hashCode ^
      currentDayPlan.hashCode ^
      lessonPlanDaysAndHours.hashCode ^
      localizations.hashCode;
}
