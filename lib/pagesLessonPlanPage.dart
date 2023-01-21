import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'colors.dart';
import 'dimens.dart';
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
            whichTileIsActive: state.whichTileIsActive,
            isTilesClickable: state.isTilesClickable,
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
      required this.whichTileIsActive,
      required this.isTilesClickable,
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
  final bool isTilesClickable;
  final List<String> currentDayPlan;
  final List<CardColors> cardColorList;
  final int whichTileIsActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConstObjects.sizedBoxTwentyHeight,
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
            height: AppDimens.heightOrWidthSmall,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lessonPlanDaysAndHours.length,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return _tiles(context,index);
              },
            ),
          ),
        ),
        _changeLessonPlanButton(context),
      ],
    );
  }
  Widget _tiles(BuildContext context, int index,){
    return GestureDetector(
      onTap: () {
        if (isTilesClickable) {
          context.read<LessonPlanCubit>().changePlanLayout(
            index,
            isTilesClickable,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(left: AppDimens.insetsSmall),
        width: AppDimens.heightOrWidthSmall,
        decoration: BoxDecoration(
          color: cardColorList[index].tilesBackgroundColor,
          borderRadius: ConstObjects.listAndTilesBorderRadius,
        ),
        child: Column(
          children: [
            Padding(
              padding: ConstObjects.paddingTopTwelve,
              child: Text(
                lessonPlanDaysAndHours[index],
                style: TextStyle(
                  fontSize: AppDimens.fontSmall,
                  color: cardColorList[index].tilesTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _lessonPlanAndHoursView() {
    return Flexible(
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: ConstObjects.listBackgroundBorderRadius,
            color: AppColors.tilesTextAndAppBackgroundColor,
            boxShadow: [
              ConstObjects.listBackgroundBoxShadow,
            ]),
        child: ListView.builder(
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return Container(
                margin: ConstObjects.listContainerMargin,
                height: AppDimens.heightOrWidthBig,
                decoration: const BoxDecoration(
                  color: AppColors.listAndTilesBackgroundColor,
                  borderRadius: ConstObjects.listAndTilesBorderRadius,
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
    if (whichTileIsActive != ConstObjects.lessonTile) {
      return Padding(
        padding: const EdgeInsets.only(right: AppDimens.insetsSmall),
        child: FloatingActionButton.small(
            backgroundColor: AppColors.tilesTextAndAppBackgroundColor,
            foregroundColor: AppColors.scaffoldIconAndTextColor,
            onPressed: () {
                  context.read<LessonPlanCubit>().saveOrUndoSaveNewPlan(
                        isTilesClickable,
                        _controller,
                        whichTileIsActive,
                        currentDayPlan,
                      );
              if (isTilesClickable == false) {
                const bool clickableTilesSwitch =true;
                final snackBar = SnackBar(
                  content: Text(localizations.undoChanges),
                  action: SnackBarAction(
                    label: localizations.undo,
                    onPressed: () {
                      context.read<LessonPlanCubit>().undoSetNewPlan(
                            whichTileIsActive,
                        clickableTilesSwitch,
                          );
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: _LoadOrSaveIcon(isTilesClickable: isTilesClickable)),
      );
    } else {
      return const SizedBox(
        height: AppDimens.heightOrWidthMedium,
      );
    }
  }

  Widget _lessonPlanOrLessonHoursShowOrChange(
    int index,
  ) {
    if ((isTilesClickable == false) && (whichTileIsActive != ConstObjects.lessonTile)) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.insetsMedium,
          vertical: AppDimens.insetsBig,
        ),
        child: TextFormField(
          controller: _controller[index],
          style: const TextStyle(
              fontSize: AppDimens.fontMedium,
              color: AppColors.scaffoldIconAndTextColor),
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: '${index + 1}${localizations.lesson}',
          ),
        ),
      );
    } else {
      return Center(
        child: Text(
          currentDayPlan.elementAt(index),
          style: ConstObjects.listTextStyle,
        ),
      );
    }
  }
}

class _LoadOrSaveIcon extends StatelessWidget {
  const _LoadOrSaveIcon({required this.isTilesClickable, Key? key})
      : super(key: key);
  final bool isTilesClickable;

  @override
  Widget build(BuildContext context) {
    if (isTilesClickable == true) {
      return const Icon(Icons.change_circle_outlined);
    } else {
      return const Icon(Icons.save_outlined);
    }
  }
}
