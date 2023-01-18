import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'constObjects.dart';
import 'home_work_cubit/homework_cubit.dart';
import 'pagesHomeWorkListPage.dart';
import 'pagesLessonPlanPage.dart';
import 'colors.dart';
import 'dimens.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return widgetForCreatingVariableLocalizations(context);
  }
}

Widget widgetForCreatingVariableLocalizations(BuildContext context) {
  final localizations = AppLocalizations.of(context)!;

  return DefaultTabController(
    length: ConstObjects.tabLength,
    child: Scaffold(
      backgroundColor: AppColors.scaffoldIconAndTextColor,
      appBar: AppBar(
        foregroundColor: AppColors.scaffoldIconAndTextColor,
        backgroundColor: AppColors.tilesTextAndAppBackgroundColor,
        title: Text(localizations.homework),
        bottom: const TabBar(
          indicatorColor: AppColors.scaffoldIconAndTextColor,
          indicatorWeight: AppDimens.insetsSmall,
          isScrollable: true,
          tabs: [
            _Tabs(icon: Icons.playlist_add_outlined),
            _Tabs(icon: Icons.home_work),
            _Tabs(icon: Icons.table_rows_rounded),
          ],
        ),
      ),
      body: _Pages(localizations: localizations),
    ),
  );
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.icon, Key? key}) : super(key: key);
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Icon(
        icon,
        color: AppColors.scaffoldIconAndTextColor,
        size: AppDimens.tabIconSize,
      ),
    );
  }
}

class _Pages extends StatelessWidget {
  const _Pages({required this.localizations, Key? key}) : super(key: key);
  final AppLocalizations localizations;

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
            backgroundColor: AppColors.scaffoldIconAndTextColor,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  backgroundColor: AppColors.tilesTextAndAppBackgroundColor,
                  foregroundColor: AppColors.scaffoldIconAndTextColor,
                  onPressed: () {
                    context.read<HomeworkCubit>().addNewHomeWorkIfNeeded();
                  },
                  label: Text(localizations.addHomework),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          pagesHomeWorkListPage(state, localizations),
          PagesLessonPlanPage(localizations: localizations),
        ],
      );
    });
  }
}





