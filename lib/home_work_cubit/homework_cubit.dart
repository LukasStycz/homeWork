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
    // ogólnie zamiast robić nazwy zmienne DayOf, cosTamOf, to lepiej pisć wyraz na końcu np. homeWorkListLastUpdateDay
    final int dayOfHomeWorkListLastUpdate =
        prefs.getInt(_dayOfHomeWorkListLastUpdateKey) ?? 0;
    // przypisz ifa do zmiennej, bedzie czytelniej
    if ((dayOfHomeWorkListLastUpdate != timeNow.weekday) &&
        (_isNotWeekend(timeNow.weekday))) {


      // 4 raz Ci zwracam uwage, ze w obu ifach dzieja sie te same rzeczy, mozna to albo wydzielic do osobnej funkcji albo dać poza ify i ten drugi pomysłnawet lepszy
      await prefs.remove(_homeWorkKey);
      final List<String> homeWorks = prefs.getStringList(_homeWorkKey) ?? [];
      emit(HomeworkLoaded(homeWorks));
      print("dzieje sie że lista się czyści");
    } else {
      final List<String> homeWorks = prefs.getStringList(_homeWorkKey) ?? [];
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
    // if do zmiennej dla czytelnosci
    if ((lessonNumber != _noSuchLesson) && (_isNotWeekend(timeNow.weekday))) {

      // powywalaj printy z calej apki, w apce wrzuconej juz do sklepu nie powinno byc widocznych logow tego typu
      final prefs = await SharedPreferences.getInstance();
      final List<String> actualLessonPlan =
          prefs.getStringList(lessonPlanKeys[timeNow.weekday - 1]) ??
              defaultLessonPlan;
      final homeWorkName = actualLessonPlan[lessonNumber - 1];
      final List<String> homeWorkList = prefs.getStringList(_homeWorkKey) ?? [];
      await prefs.setInt(_dayOfHomeWorkListLastUpdateKey, timeNow.weekday);
      _checkAndAddToListIfNeeded(homeWorkName, homeWorkList);
      await prefs.setStringList(_homeWorkKey, homeWorkList);
      emit(HomeworkLoaded(homeWorkList));
      print(homeWorkList);
    }
  }

  int _getLessonNumber(
    int hour,
    int minute,
  ) {
    int lesson = _noSuchLesson;
    final int currentTimeInMinutes = hour * _minutesInHour + minute;
    final int schoolBeginningTimeInMinutes =
        lessonHours.first.hour * _minutesInHour + lessonHours.first.minute;
    final int schoolEndingTimeInMinutes =
        lessonHours.last.hour * _minutesInHour + lessonHours.last.minute;
    final bool isSchoolTime =
        (currentTimeInMinutes >= schoolBeginningTimeInMinutes) &&
            (currentTimeInMinutes < schoolEndingTimeInMinutes);

    // wlasciwie to isSchollTime moglaby Ci wracac funkcja, bo zarowno schoolBeginningTime i endingTime nie wykorzystujesz nigdzie indzie

    if (isSchoolTime) {
      for (int i = _thisLesson; i <= _numberOfLessonsSupportedByApp; i++) {
        final bool currentLesson =
            (currentTimeInMinutes >= _lessonBeginningInMinutes(i)) &&
                (currentTimeInMinutes < _lessonEndingInMinutes(i));
        if (currentLesson) {
          lesson = i;
        }
      }
    }
    return lesson;
  }

  int _lessonBeginningInMinutes(int i) {
    // nie wie mco oznaczają te d∑ójki i co się dzieje w nawiasach klamrowych
    return lessonHours[i * 2 - 2].hour * _minutesInHour +
        lessonHours[i * 2 - 2].minute;
  }

  int _lessonEndingInMinutes(int i) {
    return lessonHours[i * 2].hour * _minutesInHour + lessonHours[i * 2].minute;
  }

  void _checkAndAddToListIfNeeded(String lessonName, List homeWorkList) {
    if (((homeWorkList.isEmpty) || (lessonName != homeWorkList.last)) &&
        (lessonName != 'none')) {
      homeWorkList.add(lessonName);
    }
  }
}

// funckja jest poza cuvbitem, przenies do cubita
bool _isNotWeekend(int timeNow) {
  return timeNow <= 5;
}

// zmienne tez mogloby byc w cubicie jako static consty, na samej gorze cubita
const int _numberOfLessonsSupportedByApp = 8;
const int _noSuchLesson = 500;
const String _homeWorkKey = "HOME_WORK";
const String _dayOfHomeWorkListLastUpdateKey = "DAY_OF_LIST_UPDATE";
const int _thisLesson = 1;
const int _minutesInHour = 60;
