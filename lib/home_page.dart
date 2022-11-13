import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/home_work_cubit/homework_cubit.dart';

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
            ),
          ),

          /// to może jako funkcja i w parametrze podajesz state
          if (state is HomeworkLoaded)
            HomeWorkListLayout(homeWorks: state.homeWorks)
          else
            const CircularProgressIndicator(),

          /// mozliwe,ze to jednak moze tu zostac, musze sie zastanowić
          BlocProvider(
            create: (context) => LessonPlanCubit(),
            child: BlocBuilder<LessonPlanCubit, LessonPlanState>(builder: (
              BuildContext context,
              LessonPlanState state,
            ) {
              if (state is LessonPlan) {
                /// jak dasz po ostatnim argumencie przecinek to Ci ladniej poformatuje (po state.lessonPlanOrChangePlan)
                return LessonPlanAndChangePlanLayout(
                  currentDayPlan: state.currentDayPlan,
                  cardColorList: state.cardColorList,
                  gestureDetectorIndex: state.gestureDetectorIndex,
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
      required this.gestureDetectorIndex,
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
  final int gestureDetectorIndex;

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


                /// znowu Ci sie powtarzaja czesci kodu, w ifie daj tylko to co się zmienia czyli z tego co widze to np. child Padding
                /// nie jestem pewny tez czy w przypadku pierwszego ifa potrzebuejesz tam textFormField a nie tylko text? formfield jest wtedy gdy chcesz coś w tym miejscu pisać
                /// nie rozumiem tez zmiennej gestureDetectorIndex
                ///
                /// do tego ten kod ponizej to moglaby byc jakas funckja ktorej nazwa mowilaby od razu co to robi, bo teraz nie do konca wiadomo
                ///
                /// ogolnie bedziemy musieli to przegadac zdzwnaniac sie, ewentualnei jutro jeszcze zajrze
                if ((lessonPlanOrChangePlan == false) &&
                    (gestureDetectorIndex != 5)) {
                  return Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    height: 60,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      child: TextFormField(
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          hintText: '${index + 1} Lekcja',
                        ),
                      ),
                    ),
                  );
                  //todo zmienić  on pres przycisku  wzależnosci od gestureDetectorIndex będzie zapisywał do różnych list w shared preferences;
                } else if ((lessonPlanOrChangePlan == false) &&
                    (gestureDetectorIndex == 5)) {
                  return Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    height: 60,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      child: TextFormField(
                        controller: _controller[index],
                        onEditingComplete: () {
                          print(_controller[index].text);
                        },
                        style: const TextStyle(fontSize: 20, color: Colors.red),
                        keyboardType: TextInputType.number,
                        textAlignVertical: TextAlignVertical.bottom,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))
                        ],
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: 'gg.mm-gg.mm',
                        ),
                      ),
                    ),
                  );
                } else {
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
                }
              },
              itemCount: currentDayPlan.length),
        ),
        const SizedBox(
          height: 75,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              /// primary jest deprecated,czyli podpowiada,ze niedlugo moze to przestac działać. Sprawdź jak powinno to sie robic w google
                fixedSize: const Size(240, 50), primary: Colors.black26),
            onPressed: () {
              /// znowu powtarzasz kod.
              /// przypisz do zmiennej true lub false w zalezlnosci od tego co jest w lessonPlanOrChangePlan i wtedy w drugim parametrze changePlanLayout podajesz tę zmienną
              if (lessonPlanOrChangePlan == true) {
                context
                    .read<LessonPlanCubit>()
                    .changePlanLayout(gestureDetectorIndex, false);
                print(gestureDetectorIndex);
              } else {
                context
                    .read<LessonPlanCubit>()
                    .changePlanLayout(gestureDetectorIndex, true);
                print(gestureDetectorIndex);
              }
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
