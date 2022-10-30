import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> czitusek() async {
    print('zawolano czitusa');
    final prefs = await SharedPreferences.getInstance();
    final List<String> homeWorkList = prefs.getStringList("HOME_WORK") ?? [];
    homeWorkList.add('dupa');
    await prefs.setStringList("HOME_WORK", homeWorkList);
    final List<String> homeWorks = prefs.getStringList("HOME_WORK") ?? [];
    emit(HomeworkLoaded(homeWorks));
  }

  //w tym miejscu logika
// jak najmniejsze funkcje
// funkcje prywatne


// sprawdz ktora godzina itd.
// zapisz do sharedasd prefs z zawait

//nastepne obliczenia

//
}
