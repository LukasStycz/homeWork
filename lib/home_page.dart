import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/home_work_cubit/homework_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lesson_plan-cubit/lessonplan_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const int _tabSize = 3;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabSize,
      child: Scaffold(
        backgroundColor: Colors.yellow,
        appBar: AppBar(
          foregroundColor: _tabBarPrimaryColor,
          backgroundColor: _tabBarSecondaryColor,
          title: const Text("Prace domowe"),
          bottom: const TabBar(
            indicatorColor: _tabBarPrimaryColor,
            indicatorWeight: 4.0,
            isScrollable: true,
            tabs: [
              _AddHomeWorkTab(),
              _HomeWorksTab(),
              _LessonPlanTab(),
            ],
          ),
        ),
        body: const _Pages(),
      ),
    );
  }
}

class _AddHomeWorkTab extends StatelessWidget {
  const _AddHomeWorkTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Tab(
      icon: Icon(
        Icons.playlist_add_outlined,
        color: _tabBarPrimaryColor,
        size: _tabBarIconSize,
      ),
    );
  }
}

class _HomeWorksTab extends StatelessWidget {
  const _HomeWorksTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Tab(
      icon: Icon(
        Icons.home_work,
        color: _tabBarPrimaryColor,
        size: _tabBarIconSize,
      ),
    );
  }
}

class _LessonPlanTab extends StatelessWidget {
  const _LessonPlanTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Tab(
      icon: Icon(
        Icons.table_rows_rounded,
        color: _tabBarPrimaryColor,
        size: _tabBarIconSize,
      ),
    );
  }
}

const Color _tabBarPrimaryColor = Colors.indigoAccent;
const double _tabBarIconSize = 50.0;
const Color _tabBarSecondaryColor = Colors.white;

class _Pages extends StatelessWidget {
  const _Pages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeworkCubit, HomeworkState>(builder: (
      BuildContext context,
      HomeworkState state,
    ) {
      return TabBarView(
        children: [
          Scaffold(
            backgroundColor: Colors.red,
            floatingActionButton: FloatingActionButton.large(
              backgroundColor: _tabBarSecondaryColor,
              foregroundColor: _tabBarPrimaryColor,
              splashColor: Colors.red,
              onPressed: () {
                context.read<HomeworkCubit>().addNewHomeWorkIfNeeded();
              },
              child: const Text("Dodaj Prace Domową"),
            ),
          ),
          _pagesHomeWorkList(state),
          BlocProvider(
            create: (context) => LessonPlanCubit(),
            child: BlocBuilder<LessonPlanCubit, LessonPlanState>(builder: (
              BuildContext context,
              LessonPlanState state,
            ) {
              if (state is LessonPlan) {
                return LessonPlanAndChangePlanLayout(
                  currentDayPlan: state.currentDayPlan,
                  cardColorList: state.cardColorList,
                  whichDayIsActive: state.whichDayIsActive,
                  lessonPlanOrChangePlan: state.lessonPlanOrChangePlan,
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
          ),
        ],
      );
    });
  }
}

class HomeWorkListLayout extends StatelessWidget {
  const HomeWorkListLayout({required this.homeWorks, Key? key})
      : super(key: key);
  final List<String> homeWorks;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
      ),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
              height: 60,
              width: 50,
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    homeWorks.elementAt(index),
                    style: const TextStyle(fontSize: 30, color: Colors.red),
                  ),
                ],
              ),
            );
          },
          itemCount: homeWorks.length),
    );
  }
}

class LessonPlanAndChangePlanLayout extends StatelessWidget {
  LessonPlanAndChangePlanLayout(
      {required this.currentDayPlan,
      required this.cardColorList,
      required this.whichDayIsActive,
      required this.lessonPlanOrChangePlan,
      Key? key})
      : super(key: key);
  final List<String> lessonPlanDaysAndHours = [
    "Pon",
    "Wto",
    "Śro",
    "Czw",
    "Pią",
    "Lek"
  ];
  final List<TextEditingController> _controller = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final bool lessonPlanOrChangePlan;
  final List<String> currentDayPlan;
  final List<List<Color>> cardColorList;
  final int whichDayIsActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 50,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lessonPlanDaysAndHours.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  if (lessonPlanOrChangePlan == true) {
                    context
                        .read<LessonPlanCubit>()
                        .changePlanLayout(index, lessonPlanOrChangePlan);
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  height: 70,
                  width: 50,
                  decoration: BoxDecoration(
                      color: cardColorList[index][0],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        lessonPlanDaysAndHours[index],
                        style: TextStyle(
                            fontSize: 18,
                            color: cardColorList[index][1],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          height: 525,
          decoration: const BoxDecoration(
              color: Colors.purple, boxShadow: [BoxShadow(blurRadius: 10.0)]),
          child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  height: 60,
                  width: 50,
                  decoration: const BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: _lessonPlanOrLessonHoursShowOrchange(
                      lessonPlanOrChangePlan,
                      whichDayIsActive,
                      index,
                      _controller,
                      currentDayPlan),
                );
              },
              itemCount: currentDayPlan.length),
        ),
        const SizedBox(
          height: 75,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                fixedSize: const Size(240, 50), primary: Colors.black26),
            onPressed: () {
              bool activateOrDeactivateDaysAndHoursGestureDetector =
                  _activateOrDeactivateDaysAndHoursGestureDetector(
                lessonPlanOrChangePlan,
                _controller,
                whichDayIsActive,
              );
              context.read<LessonPlanCubit>().changePlanLayout(
                    whichDayIsActive,
                    activateOrDeactivateDaysAndHoursGestureDetector,
                  );
              print(whichDayIsActive);
            },
            child: LessonPlanOrChangePlanButton(
                lessonPlanOrChangePlan: lessonPlanOrChangePlan)),
      ],
    );
  }
}

class LessonPlanOrChangePlanButton extends StatelessWidget {
  const LessonPlanOrChangePlanButton(
      {required this.lessonPlanOrChangePlan, Key? key})
      : super(key: key);
  final bool lessonPlanOrChangePlan;

  @override
  Widget build(BuildContext context) {
    if (lessonPlanOrChangePlan == true) {
      return const Text(
        'Zmień',
        style: TextStyle(fontSize: 25),
      );
    } else {
      return const Text(
        'Zapisz',
        style: TextStyle(fontSize: 25),
      );
    }
  }
}

Widget _pagesHomeWorkList(state) {
  if (state is HomeworkLoaded) {
    return HomeWorkListLayout(homeWorks: state.homeWorks);
  } else {
    return const CircularProgressIndicator();
  }
}

Widget _lessonPlanOrLessonHoursShowOrchange(
  bool lessonPlanOrChangePlan,
  int whichDayIsActive,
  int index,
  List<TextEditingController> controller,
  List<String> currentDayPlan,
) {
  if ((lessonPlanOrChangePlan == false) && (whichDayIsActive != 5)) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: controller[index],
        style: const TextStyle(fontSize: 20, color: Colors.red),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: '${index + 1} Lekcja',
        ),
      ),
    );
  } else if ((lessonPlanOrChangePlan == false) && (whichDayIsActive == 5)) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: TextFormField(
        controller: controller[index],
        onEditingComplete: () {
          print(controller[index].text);
        },
        style: const TextStyle(fontSize: 20, color: Colors.red),
        keyboardType: TextInputType.number,
        textAlignVertical: TextAlignVertical.bottom,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))],
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'gg.mm-gg.mm',
        ),
      ),
    );
  } else {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          currentDayPlan.elementAt(index),
          style: const TextStyle(fontSize: 30, color: Colors.red),
        ),
      ],
    );
  }
}

bool _activateOrDeactivateDaysAndHoursGestureDetector(
  lessonPlanOrChangePlan,
  List<TextEditingController> controller,
  int whichDayIsActive,
) {
  if (lessonPlanOrChangePlan == true) {
    return false;
  } else {
    List<String> newPlan = [];
    for (int i = 0; i <= 7; i++) {
      newPlan.add(controller[i].text);
      _setNewPlan(
        newPlan,
        whichDayIsActive,
      );
    }
    print(newPlan);
    return true;
  }
}

Future<void> _setNewPlan(
  List<String> newPlan,
  int whichDayIsActive,
) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList(
      lessonPlanKeysInSharedpreferences[whichDayIsActive], newPlan);
}
