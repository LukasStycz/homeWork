import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/home_work_cubit/homework_cubit.dart';
import 'lesson_plan-cubit/lessonplan_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const int _tabSize = 3;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabSize,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigoAccent,
          title: Text(AppLocalizations.of(context)!.firstString),
          bottom: const TabBar(
            indicatorColor: Colors.white,
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
        color: Colors.white,
        size: 50.0,
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
        color: Colors.white,
        size: 50.0,
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
        color: Colors.white,
        size: 50.0,
      ),
    );
  }
}

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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerTop,
            backgroundColor: Colors.white,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    context.read<HomeworkCubit>().addNewHomeWorkIfNeeded();
                  },
                  label: Text(AppLocalizations.of(context)!.secondString),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          _pagesHomeWorkListPage(state, context),
          _pagesLessonPlanPage(context),
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
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(blurRadius: 10.0)]),
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
                    style: const TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ],
              ),
            );
          },
          itemCount: homeWorks.length),
    );
  }
}

class LessonPlanPage extends StatelessWidget {
  LessonPlanPage({
    required this.lessonPlanDaysAndHours,
    required this.currentDayPlan,
    required this.cardColorList,
    required this.whichDayIsActive,
    required this.lessonPlanOrChangePlan,
    Key? key,
  }) : super(key: key);
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
  final List<String> lessonPlanDaysAndHours;
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
        Row(
          children: [
            SizedBox(
              height: 50,
              width: 360,
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
                      margin: const EdgeInsets.only(left: 5),
                      width: 40,
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
            Flexible(
              child: Container(),
            ),
            changeLessonPlanButton(context),
            const SizedBox(
              width: 5,
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Flexible(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.indigoAccent,
                boxShadow: [BoxShadow(blurRadius: 10.0)]),
            child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    height: 60,
                    width: 50,
                    decoration: const BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: _lessonPlanOrLessonHoursShowOrChange(
                      lessonPlanOrChangePlan,
                      whichDayIsActive,
                      index,
                      _controller,
                      currentDayPlan,
                      context,
                    ),
                  );
                },
                itemCount: currentDayPlan.length),
          ),
        ),
      ],
    );
  }

  Widget changeLessonPlanButton(BuildContext context) {
    if (whichDayIsActive != 5) {
      return FloatingActionButton(
          backgroundColor: Colors.indigoAccent,
          foregroundColor: Colors.white,
          onPressed: () {
            bool activateOrDeactivateDaysAndHoursGestureDetector = context
                .read<LessonPlanCubit>()
                .activationOrDeactivationDaysAndHoursGestureDetector(
                  lessonPlanOrChangePlan,
                  _controller,
                  whichDayIsActive,
                  currentDayPlan,
                );
            context.read<LessonPlanCubit>().changePlanLayout(
                  whichDayIsActive,
                  activateOrDeactivateDaysAndHoursGestureDetector,
                );
            if (lessonPlanOrChangePlan == false) {
              final snackBar = SnackBar(
                content: Text(AppLocalizations.of(context)!.eleventhString),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.twelfthString,
                  onPressed: () {
                    context.read<LessonPlanCubit>().undoSetNewPlan();
                    context.read<LessonPlanCubit>().changePlanLayout(
                          whichDayIsActive,
                          activateOrDeactivateDaysAndHoursGestureDetector,
                        );
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
            print(whichDayIsActive);
          },
          child:
              LoadOrSaveIcon(lessonPlanOrChangePlan: lessonPlanOrChangePlan));
    } else {
      return const SizedBox(
        height: 56,
        width: 1,
      );
    }
  }
}

class LoadOrSaveIcon extends StatelessWidget {
  const LoadOrSaveIcon({required this.lessonPlanOrChangePlan, Key? key})
      : super(key: key);
  final bool lessonPlanOrChangePlan;

  @override
  Widget build(BuildContext context) {
    if (lessonPlanOrChangePlan == true) {
      return const Icon(Icons.change_circle_outlined);
    } else {
      return const Icon(Icons.save_outlined);
    }
  }
}

Widget _pagesHomeWorkListPage(state, BuildContext context) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          AppLocalizations.of(context)!.thirdString,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 30, color: Colors.indigoAccent),
        ),
      ),
      Flexible(
        child: _pagesHomeWorkList(state),
      ),
    ],
  );
}

Widget _pagesHomeWorkList(state) {
  if (state is HomeworkLoaded) {
    return HomeWorkListLayout(homeWorks: state.homeWorks);
  } else {
    return const CircularProgressIndicator();
  }
}

Widget _pagesLessonPlanPage(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;
  return BlocProvider(
    create: (context) => LessonPlanCubit(localizations),
    child: BlocBuilder<LessonPlanCubit, LessonPlanState>(builder: (
      BuildContext context,
      LessonPlanState state,
    ) {
      if (state is LessonPlan) {
        return LessonPlanPage(
          lessonPlanDaysAndHours: state.lessonPlanDaysAndHours,
          currentDayPlan: state.currentDayPlan,
          cardColorList: state.cardColorList,
          whichDayIsActive: state.whichDayIsActive,
          lessonPlanOrChangePlan: state.lessonPlanOrChangePlan,
        );
      } else {
        return const CircularProgressIndicator();
      }
    }),
  );
}

Widget _lessonPlanOrLessonHoursShowOrChange(
  bool lessonPlanOrChangePlan,
  int whichDayIsActive,
  int index,
  List<TextEditingController> controller,
  List<String> currentDayPlan,
  BuildContext context,
) {
  if ((lessonPlanOrChangePlan == false) && (whichDayIsActive != 5)) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        controller: controller[index],
        style: const TextStyle(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          hintText: '${index + 1}${AppLocalizations.of(context)!.tenthString}',
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
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
      ],
    );
  }
}
