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
      required this.wishlistGuard})
      : super(navigatorKey);

  final _i3.WishlistGuard wishlistGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    EmptyRouterRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.EmptyRouterPage());
    },
    WishlistListRoute.name: (routeData) {
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.WishlistListPage());
    },
    WishlistRoute.name: (routeData) {
      var pathParams = routeData.pathParams;
      final args = routeData.argsAs<WishlistRouteArgs>(
          orElse: () => WishlistRouteArgs(id: pathParams.getString('id')));
      return _i1.MaterialPageX<dynamic>(
          routeData: routeData, child: _i3.WishlistPage(id: args.id));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(EmptyRouterRoute.name, path: '/', children: [
          _i1.RouteConfig(WishlistListRoute.name, path: ''),
          _i1.RouteConfig(WishlistRoute.name,
              path: 'wishlist/:id', guards: [wishlistGuard])
        ]),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class EmptyRouterRoute extends _i1.PageRouteInfo {
  const EmptyRouterRoute({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', children: children);

  static const String name = 'EmptyRouterRoute';
}

class WishlistListRoute extends _i1.PageRouteInfo {
  const WishlistListRoute() : super(name, path: '');

  static const String name = 'WishlistListRoute';
}

class WishlistRoute extends _i1.PageRouteInfo<WishlistRouteArgs> {
  WishlistRoute({required String id})
      : super(name,
            path: 'wishlist/:id',
            args: WishlistRouteArgs(id: id),
            params: {'id': id});

  static const String name = 'WishlistRoute';
}

class WishlistRouteArgs {
  const WishlistRouteArgs({required this.id});

  final String id;
}
