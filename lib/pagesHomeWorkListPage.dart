import 'package:flutter/material.dart';
import 'home_work_cubit/homework_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'colors.dart';
import 'constObjects.dart';
import 'dimens.dart';

Widget pagesHomeWorkListPage(state, AppLocalizations localizations) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(AppDimens.insetsBig),
        child: Text(
          localizations.homeworkList,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
              fontSize: AppDimens.fontBig,
              color: AppColors.tilesTextAndAppBackgroundColor),
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
    return _HomeWorkListLayout(homeWorks: state.homeWorks);
  } else {
    return ConstObjects.circularProgressIndicator;
  }
}

class _HomeWorkListLayout extends StatelessWidget {
  const _HomeWorkListLayout({required this.homeWorks, Key? key})
      : super(key: key);
  final List<String> homeWorks;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: AppColors.tilesTextAndAppBackgroundColor,
          borderRadius: ConstObjects.listBackgroundBorderRadius,
          boxShadow: [
            ConstObjects.listBackgroundBoxShadow,
          ]),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: ConstObjects.listContainerMargin,
              height: AppDimens.heightOrWidthBig,
              decoration: const BoxDecoration(
                color: AppColors.listAndTilesBackgroundColor,
                borderRadius: ConstObjects.listAndTilesBorderRadius,
              ),
              child: Center(
                child: Text(
                  homeWorks.elementAt(index),
                  style: ConstObjects.listTextStyle,
                ),
              ),
            );
          },
          itemCount: homeWorks.length),
    );
  }
}
