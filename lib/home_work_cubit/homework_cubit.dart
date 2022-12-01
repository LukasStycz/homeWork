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
    final int dayOfListUpdate = prefs.getInt(dayOfListUpdateKey) ?? 0;
    /// nie wiem co ta zmienna oznacza, poszukałbym lepszej nazwy

    if (dayOfListUpdate != timeNow.weekday) {
      await prefs.remove(homeWorkKey);
      final List<String> homeWorks = prefs.getStringList(homeWorkKey) ?? [];

      /// skoro linię wyżej usunąłeś ten klucz, to przecież homeWorks zawsze zwróci puste, po co odczytywać wtedy z prefsów?
      /// po prostu w emit daj pustą listę :       emit(HomeworkLoaded(List.empty()));
      /// moglbys tez ogolnie uproscic nieco tego ifa, robiac poza nim wszystko co wspolne,bo niektore rzeczzy sie powtarzaja

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
    /// cyfra 5 nic nie mówi, mógłbyś zorbić na nia consta friday, ale w tym przypadku nie ma potrzeby
    /// bo DateTime nam to daje, podmieńz     DateTime.friday - jak w niego wejdziesz to zobaczysz,że to int o wartości 5

    if ((lessonNumber != noSuchLesson) && (timeNow.weekday <= 5)) {
      final prefs = await SharedPreferences.getInstance();

      /// mega dziwna nazwa zmiennej, do tego nie stosuj _, np. currentDayLessonPlan
      final List<String> lessonPlanFor_getHomeWorkName = prefs.getStringList(
          lessonPlanKeysInSharedpreferences[timeNow.weekday - 1]) ?? defaultLessonPlan;
      final homeWorkName = lessonPlanFor_getHomeWorkName[lessonNumber - 1];
      final List<String> homeWorkList = prefs.getStringList(homeWorkKey) ?? [];

      /// szczerze mowiac nie rozumiem co tu robisz, zapisujesz obecny dzien w prefsach, po co?
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
      lesson = noSuchLesson;
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

const int noSuchLesson = 500;
const String homeWorkKey = "HOME_WORK";
const String dayOfListUpdateKey = "DAY_OF_LIST_UPDATE";
