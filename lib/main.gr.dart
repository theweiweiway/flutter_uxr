// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import 'main.dart' as _i2;

class AppRouter extends _i1.RootStackRouter {
  AppRouter();

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    BooksListRoute.name: (entry) {
      var queryParams = entry.routeData.queryParams;
      var args = entry.routeData.argsAs<BooksListRouteArgs>(
          orElse: () =>
              BooksListRouteArgs(filter: queryParams.optString('filter')));
      return _i1.MaterialPageX(
          entry: entry, child: _i2.BooksListScreen(filter: args.filter));
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(BooksListRoute.name, path: '/'),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class BooksListRoute extends _i1.PageRouteInfo<BooksListRouteArgs> {
  BooksListRoute({String? filter})
      : super(name,
            path: '/',
            args: BooksListRouteArgs(filter: filter),
            queryParams: {'filter': filter});

  static const String name = 'BooksListRoute';
}

class BooksListRouteArgs {
  const BooksListRouteArgs({this.filter});

  final String? filter;
}
