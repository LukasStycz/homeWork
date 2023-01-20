import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/constObjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'homework_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  HomeworkCubit() : super(const HomeworkInitial()) {
    _updateHomeWorks();
  }
  static const int _numberOfLessonsSupportedByApp = 7;
  static const int _noSuchLesson = 500;
  static const String _homeWorkKey = "HOME_WORK";
  static const String _dayOfHomeWorkListLastUpdateKey = "DAY_OF_LIST_UPDATE";
  static const int _firstLesson = 0;
  static const int _minutesInHour = 60;

  Future<void> _updateHomeWorks() async {
    final timeNow = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final int homeWorkListLastUpdateDay =
        prefs.getInt(_dayOfHomeWorkListLastUpdateKey) ?? 0;
    final bool isHomeWorksClearNeeded =
        (homeWorkListLastUpdateDay != timeNow.weekday) &&
            (_isNotWeekend(timeNow.weekday));
    if (isHomeWorksClearNeeded) {
      await prefs.remove(_homeWorkKey);
    }
    final List<String> homeWorks = prefs.getStringList(_homeWorkKey) ?? [];
    emit(HomeworkLoaded(homeWorks));
  }

  Future<void> addNewHomeWork() async {
    final timeNow = DateTime.now();
    final int lessonNumber = _getLessonNumber(
      timeNow.hour,
      timeNow.minute,
    );
    final bool isAddNeeded =
        (lessonNumber != _noSuchLesson) && (_isNotWeekend(timeNow.weekday));
    if (isAddNeeded) {
      final prefs = await SharedPreferences.getInstance();
      final List<String> actualLessonPlan =
          prefs.getStringList(ConstObjects.lessonPlanKeys[timeNow.weekday - 1]) ??
              ConstObjects.defaultLessonPlan;
      final homeWorkName = actualLessonPlan[lessonNumber];
      final List<String> homeWorkList = prefs.getStringList(_homeWorkKey) ?? [];
      await prefs.setInt(_dayOfHomeWorkListLastUpdateKey, timeNow.weekday);
      _checkAndAddToListIfNeeded(homeWorkName, homeWorkList);
      await prefs.setStringList(_homeWorkKey, homeWorkList);
      emit(HomeworkLoaded(homeWorkList));
    }
  }

  int _getLessonNumber(
    int hour,
    int minute,
  ) {
    final int currentTimeInMinutes = hour * _minutesInHour + minute;
    int lesson = _noSuchLesson;
    if (_isSchoolTime(currentTimeInMinutes)) {
      for (int lessonIndex = _firstLesson; lessonIndex <= _numberOfLessonsSupportedByApp; lessonIndex++) {
        if (_currentLesson(lessonIndex, currentTimeInMinutes)) {
          print (lessonIndex);
          lesson = lessonIndex;
        }
      }
    }
    return lesson;
  }

  bool _currentLesson(
    int lesson,
    int currentTimeInMinutes,
  ) {
    final bool currentLesson =
        (currentTimeInMinutes >= _lessonBeginningInMinutes(lesson)) &&
            (currentTimeInMinutes < _lessonEndingInMinutes(lesson));
    return currentLesson;
  }

  bool _isSchoolTime(currentTimeInMinutes) {
    final int schoolBeginningTimeInMinutes =
        lessonHours.first.startTime.hour * _minutesInHour + lessonHours.first.startTime.minute;
    final int endOfDay =
        lessonHours.last.endTime.hour * _minutesInHour + lessonHours.last.endTime.hour;
    final bool isSchoolTime =
        (currentTimeInMinutes >= schoolBeginningTimeInMinutes) &&
            (currentTimeInMinutes < endOfDay);
    return isSchoolTime;
  }

  int _lessonBeginningInMinutes(int lesson) {
    return lessonHours[lesson].startTime.hour *
            _minutesInHour +
        lessonHours[lesson].startTime.minute;
  }

  int _lessonEndingInMinutes(int lesson) {
    return lessonHours[lesson+1].startTime.hour *
        _minutesInHour +
        lessonHours[lesson+1].startTime.minute;
  }

  void _checkAndAddToListIfNeeded(String lessonName, List homeWorkList) {
    if (((homeWorkList.isEmpty) || (lessonName != homeWorkList.last)) &&
        (lessonName != 'none')) {
      homeWorkList.add(lessonName);
    }
  }

  bool _isNotWeekend(int timeNow) {
    return timeNow <= 5;
  }
}
