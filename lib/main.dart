// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Nested example
/// Done using AutoRoute
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_uxr/main.gr.dart';

void main() {
  runApp(BooksApp());
}

// Declare routing setup
@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.fadeIn, // cross fade between tabs
      page: AppScreen,
      path: "/",
      children: [
        RedirectRoute(path: "", redirectTo: "books/new"),
        CustomRoute(
          name: 'BooksTab',
          path: 'books',
          page: BooksScreen,
          children: [
            CustomRoute(path: "new", page: NewBooksScreen),
            CustomRoute(path: "all", page: AllBooksScreen),
            RedirectRoute(path: "*", redirectTo: "new"),
          ],
        ),
        AutoRoute(
          name: "SettingsTab",
          path: 'settings',
          page: SettingsScreen,
        ),
      ],
    ),
    RedirectRoute(path: "*", redirectTo: "/")
  ],
)
class $AppRouter {}

class BooksApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
    );
  }
}

class AppScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [BooksTab(), SettingsTab()],
      bottomNavigationBuilder: (_, tabsRouter) {
        return BottomNavigationBar(
          currentIndex: tabsRouter.activeIndex,
          onTap: (idx) => tabsRouter.setActiveIndex(idx),
          items: [
            BottomNavigationBarItem(
              label: 'Books',
              icon: Icon(Icons.chrome_reader_mode_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
        );
      },
    );
  }
}

class BooksScreen extends StatefulWidget {
  @override
  _BooksScreenState createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    var url;
    Future.delayed(Duration.zero, () {
      url = AutoRouterDelegate.of(context).urlState.path;
    });
    _tabController = TabController(
        length: 2, vsync: this, initialIndex: url == "/books/new" ? 0 : 1);

    super.initState();
  }

  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          onTap: (int index) => context.router
              .pushNamed(index == 0 ? "/books/new" : "/books/all"),
          // onTap: (int index) => setState(() {
          //   _tabController.index = index;
          // }),
          labelColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(icon: Icon(Icons.bathtub), text: 'New'),
            Tab(icon: Icon(Icons.group), text: 'All'),
          ],
        ),
        Expanded(
          child: AutoRouter(),
          // child: AutoRouter.declarative(
          //   routes: (router) {
          //     return [
          //       if (_tabController.index == 0) NewBooksRoute(),
          //       if (_tabController.index == 1) AllBooksRoute(),
          //     ];
          //   },
          //   onPopRoute: (_, __) {
          //     print('popping');
          //   },
          // ),
        ),
      ],
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}

class AllBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All Books'),
      ),
    );
  }
}

class NewBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('New Books'),
      ),
    );
  }
}
