import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/home_work_cubit/homework_cubit.dart';

import 'lesson_plan-cubit/lessonplan_cubit.dart';

// import 'package:bloc/';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const int _tabSize = 3;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabSize,
      child: Scaffold(
        backgroundColor: Colors.indigoAccent,
        appBar: AppBar(
          foregroundColor: Colors.indigoAccent,
          backgroundColor: Colors.white,
          title: const Text("Prace domowe"),
          bottom: const TabBar(
            indicatorColor: Colors.indigoAccent,
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
        color: Colors.indigoAccent,
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
        color: Colors.indigoAccent,
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
        color: Colors.indigoAccent,
        size: _tabBarIconSize,
      ),
    );
  }
}

const double _tabBarIconSize = 50.0;

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
                backgroundColor: Colors.white,
                foregroundColor: Colors.indigoAccent,
                splashColor: Colors.red,
                onPressed: () {
                  context.read<HomeworkCubit>().addNewHomeWorkIfNeeded();
                },
              )),
          if (state is HomeworkLoaded)
            HomeWorkListLayout(homeWorks: state.homeWorks)
          else
            const CircularProgressIndicator(),
          BlocProvider(
            create: (context) => LessonPlanCubit(),
            child: BlocBuilder<LessonPlanCubit, LessonPlanState>(builder: (
              BuildContext context,
              LessonPlanState state2,
            ) {
              if (state2 is LessonPlanMonday) {
                return LessonPlanLayout(
                    currentDayPlan: state2.currentDayPlan,
                    cardColorList: state2.cardColorList,
                    lessonHours: state2.lessonHours);
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
        color: Colors.indigoAccent,
      ),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
              height: 60,
              width: 50,
              decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
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

class LessonPlanLayout extends StatelessWidget {
  LessonPlanLayout(
      {required this.currentDayPlan,
      required this.cardColorList,
      required this.lessonHours,
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
  final List<String> currentDayPlan;
  final List<List<Color>> cardColorList;
  final List<int> lessonHours;

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
                  print('dzień$index');
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
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white, boxShadow: [BoxShadow(blurRadius: 10.0)]),
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    height: 60,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          currentDayPlan.elementAt(index),
                          style:
                              const TextStyle(fontSize: 30, color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
                itemCount: currentDayPlan.length),
          ),
        ),
      ],
    );
  }
}
