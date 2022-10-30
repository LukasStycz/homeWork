import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homeworkapp/subject.dart';
part 'homework_state.dart';

class HomeworkCubit extends Cubit<HomeworkState> {
  HomeworkCubit() : super(const HomeworkInitial()) {
    print('czitus hgwdp');
    _updateHomeWorks();
  }

  Future<void> _updateHomeWorks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
    emit(HomeworkLoaded(homeWorks));
  }

  Future<void> addNewHomeWorkIfNeeded() async {
    final timeNow = DateTime.now();
    final lessonNumber = _getLessonNumber(
      timeNow.hour,
      timeNow.minute,
    );
    if(lessonNumber!=null){
    final homeWorkName = _getHomeWorkName(timeNow.day, lessonNumber);
    print('zawolano czitusa');
    final prefs = await SharedPreferences.getInstance();
    final List<String> homeWorkList = prefs.getStringList("HOME_WORK") ?? [];
    _checkAndAddToListIfNeeded(homeWorkName, homeWorkList);
    await prefs.setStringList("HOME_WORK", homeWorkList);
    final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
    emit(HomeworkLoaded(homeWorks));}
  }

  int? _getLessonNumber(
    int hour,
    int minute,
  ) {
    final int? lesson;

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
      lesson = null;
    }
    return lesson;
  }

  String _getHomeWorkName(int dayNow, int lesson) {
    String? name;
     if (dayNow == DateTime.monday) {
      name = monday[lesson-1].title;
    } else if (dayNow == DateTime.tuesday) {
      name = tuesday[lesson-1].title;
    } else if (dayNow == DateTime.wednesday) {
      name = wednesday[lesson-1].title;
    } else if (dayNow == DateTime.thursday) {
      name = thursday[lesson-1].title;
    } else if (dayNow == DateTime.friday) {
      name = friday[lesson-1].title;
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

class SubjectDecision {
  int dayNow = 0;

  void setWeekday() {
    dayNow = DateTime.now().weekday;
    print('funkcja weekday');
  }
}
