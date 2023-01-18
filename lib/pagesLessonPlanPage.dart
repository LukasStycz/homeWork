import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lesson_plan-cubit/lessonplan_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constObjects.dart';

class PagesLessonPlanPage extends StatelessWidget {
  const PagesLessonPlanPage({required this.localizations, Key? key})
      : super(key: key);
  final AppLocalizations localizations;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LessonPlanCubit(localizations),
      child: BlocBuilder<LessonPlanCubit, LessonPlanState>(builder: (
        BuildContext context,
        LessonPlanState state,
      ) {
        if (state is LessonPlan) {
          return _LessonPlanPage(
            localizations: state.localizations,
            lessonPlanDaysAndHours: state.lessonPlanDaysAndHours,
            currentDayPlan: state.currentDayPlan,
            cardColorList: state.cardColorList,
            whichDayIsActive: state.whichDayIsActive,
            lessonPlanOrChangePlan: state.lessonPlanOrChangePlan,
          );
        } else {
          return ConstObjects.circularProgressIndicator;
        }
      }),
    );
  }
}

class _LessonPlanPage extends StatelessWidget {
  _LessonPlanPage(
      {required this.localizations,
      required this.currentDayPlan,
      required this.cardColorList,
      required this.whichDayIsActive,
      required this.lessonPlanOrChangePlan,
      required this.lessonPlanDaysAndHours,
      Key? key})
      : super(key: key);
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
  final AppLocalizations localizations;
  final List<String> lessonPlanDaysAndHours;
  final bool lessonPlanOrChangePlan;
  final List<String> currentDayPlan;
  final List<List<Color>> cardColorList;
  final int whichDayIsActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstObjects. sizedBoxTwentyHeight,
        _changingDaysAndHoursTilesAndChangingPlanButton(context),
        ConstObjects.sizedBoxTwentyHeight,
        _lessonPlanAndHoursView(),
      ],
    );
  }

  Widget _changingDaysAndHoursTilesAndChangingPlanButton(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
            height: 40,
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
                    margin: const EdgeInsets.only(left: 4),
                    width: 40,
                    decoration: BoxDecoration(
                      color: cardColorList[index][0],
                      borderRadius: ConstObjects. listListBackgroundAndTilesBorderRadius,
                    ),
                    child: Column(
                      children: [
                        ConstObjects.sizedBoxTwelveHeight,
                        Text(
                          lessonPlanDaysAndHours[index],
                          style: TextStyle(
                              fontSize: 16,
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
        ),
        _changeLessonPlanButton(context),
        const SizedBox(
          width: 4,
        )
      ],
    );
  }

  Widget _lessonPlanAndHoursView() {
    return Flexible(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            borderRadius:  ConstObjects.listListBackgroundAndTilesBorderRadius,
            color: Colors.indigoAccent,
            boxShadow: [
              ConstObjects.listBackgroundBoxShadow,
            ]),
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin:  ConstObjects.listContainerMargin,
                height: 60,
                width: 52,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  borderRadius: ConstObjects.listListBackgroundAndTilesBorderRadius,
                ),
                child: _lessonPlanOrLessonHoursShowOrChange(
                  index,
                ),
              );
            },
            itemCount: currentDayPlan.length),
      ),
    );
  }

  Widget _changeLessonPlanButton(
    BuildContext context,
  ) {
    if (whichDayIsActive != 5) {
      return FloatingActionButton.small(
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
                content: Text(localizations.undoChanges),
                action: SnackBarAction(
                  label: localizations.undo,
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
              _LoadOrSaveIcon(lessonPlanOrChangePlan: lessonPlanOrChangePlan));
    } else {
      return const SizedBox(
        height: 48,
      );
    }
  }

  Widget _lessonPlanOrLessonHoursShowOrChange(
    int index,
  ) {
    if ((lessonPlanOrChangePlan == false) && (whichDayIsActive != 5)) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextFormField(
          controller: _controller[index],
          style: const TextStyle(fontSize: 20, color: Colors.white),
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: '${index + 1}${localizations.lesson}',
          ),
        ),
      );
    } else {
      return Column(
        children: [
          ConstObjects.sizedBoxTwelveHeight,
          Text(
            currentDayPlan.elementAt(index),
            style: ConstObjects.listTextStyle,
          ),
        ],
      );
    }
  }
}

class _LoadOrSaveIcon extends StatelessWidget {
  const _LoadOrSaveIcon({required this.lessonPlanOrChangePlan, Key? key})
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
