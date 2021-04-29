// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'main.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter([_i2.GlobalKey<_i2.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    AppRoute.name: (routeData) {
      return _i1.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.AppPage(),
          transitionsBuilder: _i1.TransitionsBuilders.fadeIn,
          opaque: true,
          barrierDismissible: false);
    },
    BooksTab.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.BooksPage());
    },
    SettingsTab.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.SettingsPage());
    },
    AllBooksRoute.name: (routeData) {
      return _i1.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.AllBooksPage(),
          opaque: true,
          barrierDismissible: false);
    },
    NewBooksRoute.name: (routeData) {
      return _i1.CustomPage<dynamic>(
          routeData: routeData,
          child: _i3.NewBooksPage(),
          opaque: true,
          barrierDismissible: false);
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(AppRoute.name, path: '/', children: [
          _i1.RouteConfig(BooksTab.name, path: 'books', children: [
            _i1.RouteConfig('#redirect',
                path: '', redirectTo: 'all', fullMatch: true),
            _i1.RouteConfig(AllBooksRoute.name, path: 'all'),
            _i1.RouteConfig(NewBooksRoute.name, path: 'new')
          ]),
          _i1.RouteConfig(SettingsTab.name, path: 'settings')
        ]),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class AppRoute extends _i1.PageRouteInfo {
  const AppRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', children: children);

  static const String name = 'AppRoute';
}

class BooksTab extends _i1.PageRouteInfo {
  const BooksTab({List<_i1.PageRouteInfo>? children})
      : super(name, path: 'books', children: children);

  static const String name = 'BooksTab';
}

class SettingsTab extends _i1.PageRouteInfo {
  const SettingsTab() : super(name, path: 'settings');

  static const String name = 'SettingsTab';
}

class AllBooksRoute extends _i1.PageRouteInfo {
  const AllBooksRoute() : super(name, path: 'all');

  static const String name = 'AllBooksRoute';
}

class NewBooksRoute extends _i1.PageRouteInfo {
  const NewBooksRoute() : super(name, path: 'new');

  static const String name = 'NewBooksRoute';
}
