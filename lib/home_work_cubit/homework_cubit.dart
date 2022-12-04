import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/lesson_plan-cubit/lessonplan_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'homework_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  HomeworkCubit() : super(const HomeworkInitial()) {
    _updateHomeWorks();
  }

  Future<void> _updateHomeWorks() async {
    final timeNow = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final int dayOfHomeWorkListLastUpdate =
        prefs.getInt(dayOfHomeWorkListLastUpdateKey) ?? 0;
    if ((dayOfHomeWorkListLastUpdate != timeNow.weekday) &&
        (isNotWeekend(timeNow.weekday))) {
      await prefs.remove(homeWorkKey);
      final List<String> homeWorks = prefs.getStringList(homeWorkKey) ?? [];
      emit(HomeworkLoaded(homeWorks));
      print("dzieje sie że lista się czyści");
    } else {
      final List<String> homeWorks = prefs.getStringList(homeWorkKey) ?? [];
      emit(HomeworkLoaded(homeWorks));
      print('dzieje się że lista porzechodzi dalej');
    }
  }

  Future<void> addNewHomeWorkIfNeeded() async {
    final timeNow = DateTime.now();
    final int lessonNumber = _getLessonNumber(
      timeNow.hour,
      timeNow.minute,
    );
    if ((lessonNumber != noSuchLesson) && (isNotWeekend(timeNow.weekday))) {
      final prefs = await SharedPreferences.getInstance();
      final List<String> actualLessonPlan =
          prefs.getStringList(lessonPlanKeys[timeNow.weekday - 1]) ??
              defaultLessonPlan;
      final homeWorkName = actualLessonPlan[lessonNumber - 1];
      final List<String> homeWorkList = prefs.getStringList(homeWorkKey) ?? [];
      await prefs.setInt(dayOfHomeWorkListLastUpdateKey, timeNow.weekday);
      _checkAndAddToListIfNeeded(homeWorkName, homeWorkList);
      await prefs.setStringList(homeWorkKey, homeWorkList);
      emit(HomeworkLoaded(homeWorkList));
      print(homeWorkList);
    }
  }

  int _getLessonNumber(
    int hour,
    int minute,
  ) {
    int lesson = noSuchLesson;
    final double timeConversionToCompareWithLessonHours =
        hour * 60 + minute * 60 / 100;

    if ((timeConversionToCompareWithLessonHours >= lessonHours.first * 60) &&
        (timeConversionToCompareWithLessonHours < lessonHours.last * 60)) {
      for (int i = 1; i <= 8; i++) {
        if ((timeConversionToCompareWithLessonHours >=
                lessonHours[i * 2 - 2] * 60) &&
            (timeConversionToCompareWithLessonHours <
                lessonHours[i * 2] * 60)) {
          lesson = i;
        }
      }
    }
    return lesson;
  }

  void _checkAndAddToListIfNeeded(String lessonName, List homeWorkList) {
    if (((homeWorkList.isEmpty) || (lessonName != homeWorkList.last)) &&
        (lessonName != 'none')) {
      homeWorkList.add(lessonName);
    }
  }
}

bool isNotWeekend(int timeNow) {
  return timeNow <= 5;
}

const int noSuchLesson = 500;
const String homeWorkKey = "HOME_WORK";
const String dayOfHomeWorkListLastUpdateKey = "DAY_OF_LIST_UPDATE";
