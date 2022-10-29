import 'package:flutter/material.dart';

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
        body: _Pagess(),
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


class _Pagess extends StatelessWidget {
  const _Pagess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Scaffold(
            floatingActionButton: FloatingActionButton.large(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigoAccent,
              splashColor: Colors.red,
              onPressed: ,
            )
        ),
        HomeWorkListLayout(homeWorks: homeWorks,),
      ],
    );
  }
}


class HomeWorkListLayout extends StatefulWidget {
  const HomeWorkListLayout({required this.homeWorks, Key? key})
      : super(key: key);
  final List<String> homeWorks;

  @override
  State<HomeWorkListLayout> createState() => _HomeWorkListLayoutState();
}

class _HomeWorkListLayoutState extends State<HomeWorkListLayout> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return
            Text(
              widget.homeWorks.elementAt(index),
              style:
              const TextStyle(height: 5, fontSize: 30, color: Colors.red),
            );
        },
        itemCount: widget.homeWorks.length);
  }
}