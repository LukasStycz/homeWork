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
    final int dayOfListUpdate = prefs.getInt("DAY_OF_LIST_UPDATE") ?? 0;

    /// uzywaj autoformatowania kodu bo maszz zle nawiasy
    /// zauwaz,ze w ifach robisz te same rzeczy, czyli je powtarzasz,
    ///
    /// np.
    /// if (dayOfListUpdate != timeNow.weekday) {
    ///     await prefs.remove("HOME_WORK");
    /// }
    ///
    /// final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
    /// emit(HomeworkLoaded(homeWorks));

    if (dayOfListUpdate != timeNow.weekday) {
      await prefs.remove("HOME_WORK");
      final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
      emit(HomeworkLoaded(homeWorks));
      print ("dzieje sie że lista się czyści");
    }
    else{
    final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
    emit(HomeworkLoaded(homeWorks));
    print ('dzieje się że lista porzechodzi dalej');
    }
  }

  Future<void> addNewHomeWorkIfNeeded() async {
    final timeNow = DateTime.now();
    final lessonNumber = _getLessonNumber(
      timeNow.hour,
      timeNow.minute,
    );

    if (lessonNumber != null) {
      final homeWorkName = _getHomeWorkName(timeNow.weekday, lessonNumber);
      final prefs = await SharedPreferences.getInstance();
      /// HOME_WORK i inne klucze przypisz do const zmiennej
      final List<String> homeWorkList = prefs.getStringList("HOME_WORK") ?? [];
      await prefs.setInt("DAY_OF_LIST_UPDATE", timeNow.weekday);
      _checkAndAddToListIfNeeded(homeWorkName, homeWorkList);
      await prefs.setStringList("HOME_WORK", homeWorkList);

      /// ponizsza linia niepotrzebna - przeciez przed chwila do prefsow wstadziles homeWorkList - wiec zrób emit(HomeworkLoaded(homeWorksList))
      final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
      emit(HomeworkLoaded(homeWorks));
      print(homeWorks);
    }
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
      lesson = 4;
    }
    return lesson;
  }

  String _getHomeWorkName(int dayNow, int lesson) {
    final String name;
    if (dayNow == DateTime.monday) {
      name = monday[lesson - 1].title;
    } else if (dayNow == DateTime.tuesday) {
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

/// FORMATOWANIE
void _checkAndAddToListIfNeeded(String lessonName, List homeWorkList) {
  if (((homeWorkList.isEmpty) || (lessonName != homeWorkList.last)) &&
      (lessonName != 'none')) {
    homeWorkList.add(lessonName);
  }
}

