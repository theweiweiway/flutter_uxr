// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i2;

import 'main.dart' as _i3;

class AppRouter extends _i1.RootStackRouter {
  AppRouter(
      {_i2.GlobalKey<_i2.NavigatorState>? navigatorKey,
      required this.appGuard,
      required this.signInGuard})
      : super(navigatorKey);

  final _i3.AppGuard appGuard;

  final _i3.SignInGuard signInGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    EmptyRouterRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterScreen());
    },
    SignInRoute.name: (routeData) {
      final args = routeData.argsAs<SignInRouteArgs>();
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.SignInScreen(onSignedIn: args.onSignedIn));
    },
    HomeRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.HomeScreen());
    },
    BooksListRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.BooksListScreen());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(EmptyRouterRoute.name, path: '/', guards: [
          appGuard
        ], children: [
          _i1.RouteConfig(HomeRoute.name, path: ''),
          _i1.RouteConfig(BooksListRoute.name, path: 'books')
        ]),
        _i1.RouteConfig(SignInRoute.name,
            path: '/signIn', guards: [signInGuard]),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class EmptyRouterRoute extends _i1.PageRouteInfo {
  const EmptyRouterRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', children: children);

  static const String name = 'EmptyRouterRoute';
}

class SignInRoute extends _i1.PageRouteInfo<SignInRouteArgs> {
  SignInRoute({required void Function(_i3.Credentials) onSignedIn})
      : super(name,
            path: '/signIn', args: SignInRouteArgs(onSignedIn: onSignedIn));

  static const String name = 'SignInRoute';
}

class SignInRouteArgs {
  const SignInRouteArgs({required this.onSignedIn});

  final void Function(_i3.Credentials) onSignedIn;
}

class HomeRoute extends _i1.PageRouteInfo {
  const HomeRoute() : super(name, path: '');

  static const String name = 'HomeRoute';
}

class BooksListRoute extends _i1.PageRouteInfo {
  const BooksListRoute() : super(name, path: 'books');

  static const String name = 'BooksListRoute';
}
