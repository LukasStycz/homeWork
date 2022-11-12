part of 'lessonplan_cubit.dart';

@immutable
abstract class LessonPlanState {
  const LessonPlanState();
}

class LessonPlanInitial extends LessonPlanState {
  const LessonPlanInitial();
}

class LessonPlan extends LessonPlanState {
  final int gestureDetectorIndex;
  final List<List<Color>> cardColorList;
  final List<String> currentDayPlan;


  const LessonPlan(
       this.cardColorList,this.currentDayPlan,this.gestureDetectorIndex );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LessonPlan &&
          runtimeType == other.runtimeType &&
          gestureDetectorIndex == other.gestureDetectorIndex &&
          cardColorList == other.cardColorList &&
          currentDayPlan == other.currentDayPlan;

  @override
  int get hashCode =>
      gestureDetectorIndex.hashCode ^
      cardColorList.hashCode ^
      currentDayPlan.hashCode;
}
