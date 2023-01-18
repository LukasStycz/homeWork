import 'package:flutter/material.dart';
import 'package:homeworkapp/home_work_cubit/homework_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constObjects.dart';

Widget pagesHomeWorkListPage(state, AppLocalizations localizations) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          localizations.homeworkList,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 28, color: Colors.indigoAccent),
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
          color: Colors.indigoAccent,
          borderRadius:ConstObjects.listListBackgroundAndTilesBorderRadius,
          boxShadow: [
            ConstObjects.listBackgroundBoxShadow,
          ]),
      child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: ConstObjects.listContainerMargin,
              height: 60,
              width: 52,
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius:  ConstObjects.listListBackgroundAndTilesBorderRadius,
              ),
              child: Column(
                children: [
                  ConstObjects.sizedBoxTwelveHeight,
                  Text(
                    homeWorks.elementAt(index),
                    style:  ConstObjects.listTextStyle,
                  ),
                ],
              ),
            );
          },
          itemCount: homeWorks.length),
    );
  }
}
