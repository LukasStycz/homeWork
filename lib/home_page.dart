import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homeworkapp/home_work_cubit/homework_cubit.dart';
// import 'package:bloc/';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const int _tabSize = 2;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabSize,
      child: Scaffold(
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
            const CircularProgressIndicator()
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
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Text(
            homeWorks.elementAt(index),
            style: const TextStyle(height: 5, fontSize: 30, color: Colors.red),
          );
        },
        itemCount: homeWorks.length);
  }
}
