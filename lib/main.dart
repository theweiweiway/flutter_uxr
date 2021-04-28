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
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.fadeIn, // cross fade between tabs
      page: EmptyRouterPage,
      path: "/",
      children: [
        AutoRoute(path: "", page: AppPage, children: [
          AutoRoute(
            name: "BooksTab",
            path: 'books',
            page: BooksPage,
            children: [
              RedirectRoute(path: "", redirectTo: "all"),
              CustomRoute(
                path: "all",
                page: AllBooksPage,
              ),
              CustomRoute(
                path: "new",
                page: NewBooksPage,
              ),
            ],
          ),
          AutoRoute(
            name: "SettingsTab",
            path: 'settings',
            page: SettingsPage,
          ),
        ]),
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

class AppPage extends StatelessWidget {
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

class BooksPage extends StatefulWidget {
  BooksPage({
    Key? key,
  }) : super(key: key);

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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
          onTap: (int index) => setState(() {
            _tabController.index = index;
          }),
          labelColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(icon: Icon(Icons.bathtub), text: 'New'),
            Tab(icon: Icon(Icons.group), text: 'All'),
          ],
        ),
        Expanded(
          child: AutoRouter.declarative(
            routes: (context) {
              return [
                if (_tabController.index == 0) NewBooksRoute(),
                if (_tabController.index == 1) AllBooksRoute(),
              ];
            },
          ),
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings'),
      ),
    );
  }
}

class AllBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('All Books'),
      ),
    );
  }
}

class NewBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('New Books'),
      ),
    );
  }
}
