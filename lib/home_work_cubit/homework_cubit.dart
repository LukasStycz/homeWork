import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeworkapp/subject.dart';
part 'homework_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  HomeworkCubit() : super(const HomeworkInitial()) {
    _updateHomeWorks();
  }

  Future<void> _updateHomeWorks() async {
    final timeNow = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    final int dayOfListUpdate = prefs.getInt(dayOfListUpdateKey) ?? 0;
    if (dayOfListUpdate != timeNow.weekday) {
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
    if (lessonNumber != noSuchLesson) {
      final homeWorkName = _getHomeWorkName(timeNow.weekday, lessonNumber);
      final prefs = await SharedPreferences.getInstance();
      final List<String> homeWorkList = prefs.getStringList(homeWorkKey) ?? [];
      await prefs.setInt(dayOfListUpdateKey, timeNow.weekday);
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
    final int lesson;

    if (((hour == 8) && (minute >= 0) && (minute <= 55))) {
      lesson = 1;
    } else if (((hour == 8) && (minute > 55) && (minute <= 59)) ||
        ((hour == 9) && (minute >= 0) && (minute <= 50))) {
      lesson = 2;
    } else if (((hour == 9) && (minute > 50) && (minute <= 59)) ||
        ((hour == 10) && (minute >= 0) && (minute <= 45))) {
      lesson = 3;
    } else if (((hour == 10) && (minute > 45) && (minute <= 59)) ||
        ((hour == 11) && (minute >= 0) && (minute <= 45))) {
      lesson = 4;
    } else if (((hour == 11) && (minute > 45) && (minute <= 59)) ||
        ((hour == 12) && (minute >= 0) && (minute <= 45))) {
      lesson = 5;
    } else if (((hour == 12) && (minute > 45) && (minute <= 59)) ||
        ((hour == 13) && (minute >= 0) && (minute <= 40))) {
      lesson = 6;
    } else if (((hour == 13) && (minute > 40) && (minute <= 59)) ||
        ((hour == 14) && (minute >= 0) && (minute <= 35))) {
      lesson = 7;
    } else if (((hour == 14) && (minute > 35) && (minute <= 59)) ||
        ((hour == 15) && (minute >= 0) && (minute <= 30))) {
      lesson = 8;
    } else {
      lesson = 2;
    }
    return lesson;
  }

  String _getHomeWorkName(int dayNow, int lesson) {
    final String name;
    if (dayNow == DateTime.monday) {
      name = monday[lesson - 1].title;
    } else if (dayNow == DateTime.saturday) {
      name = tuesday[lesson - 1].title;
    } else if (dayNow == DateTime.wednesday) {
      name = wednesday[lesson - 1].title;
    } else if (dayNow == DateTime.thursday) {
      name = thursday[lesson - 1].title;
    } else if (dayNow == DateTime.friday) {
      name = friday[lesson - 1].title;
    } else {
      name = 'none';
    }
    return name;
  }
}

void _checkAndAddToListIfNeeded(String lessonName, List homeWorkList) {
  if (((homeWorkList.isEmpty) || (lessonName != homeWorkList.last)) &&
      (lessonName != 'none')) {
    homeWorkList.add(lessonName);
  }
}
const int noSuchLesson=500;
const String homeWorkKey = "HOME_WORK";
const String dayOfListUpdateKey = "DAY_OF_LIST_UPDATE";
