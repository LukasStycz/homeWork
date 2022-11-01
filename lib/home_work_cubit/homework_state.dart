part of 'homework_cubit.dart';

abstract class HomeworkState {
  const HomeworkState();
}

class HomeworkInitial extends HomeworkState {
  const HomeworkInitial();
}

class HomeworkLoaded extends HomeworkState{
  final List<String> homeWorks;

  const HomeworkLoaded(this.homeWorks);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeworkLoaded &&
          runtimeType == other.runtimeType &&
          homeWorks == other.homeWorks;

  @override
  int get hashCode => homeWorks.hashCode;
}
