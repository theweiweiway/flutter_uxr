// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

import 'package:auto_route/auto_route.dart' as _i1;

import 'main.dart' as _i2;

class AppRouter extends _i1.RootStackRouter {
  AppRouter({required this.signedInGuard, required this.signedOutGuard});

  final _i2.SignedInGuard signedInGuard;

  final _i2.SignedOutGuard signedOutGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    AppStack.name: (entry) {
      return _i1.MaterialPageX(
          entry: entry, child: const _i1.EmptyRouterPage());
    },
    SignInRoute.name: (entry) {
      var args = entry.routeData.argsAs<SignInRouteArgs>();
      return _i1.MaterialPageX(
          entry: entry, child: _i2.SignInScreen(onSignedIn: args.onSignedIn));
    },
    HomeRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i2.HomeScreen());
    },
    BooksListRoute.name: (entry) {
      return _i1.MaterialPageX(entry: entry, child: _i2.BooksListScreen());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(AppStack.name, path: '/', guards: [
          signedInGuard
        ], children: [
          _i1.RouteConfig(HomeRoute.name, path: ''),
          _i1.RouteConfig(BooksListRoute.name, path: 'books')
        ]),
        _i1.RouteConfig(SignInRoute.name,
            path: '/signIn', guards: [signedOutGuard]),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

class AppStack extends _i1.PageRouteInfo {
  const AppStack({List<_i1.PageRouteInfo>? children})
      : super(name, path: '/', initialChildren: children);

  static const String name = 'AppStack';
}

class SignInRoute extends _i1.PageRouteInfo<SignInRouteArgs> {
  SignInRoute({required void Function(_i2.Credentials) onSignedIn})
      : super(name,
            path: '/signIn', args: SignInRouteArgs(onSignedIn: onSignedIn));

  static const String name = 'SignInRoute';
}

class SignInRouteArgs {
  const SignInRouteArgs({required this.onSignedIn});

  final void Function(_i2.Credentials) onSignedIn;
}

class HomeRoute extends _i1.PageRouteInfo {
  const HomeRoute() : super(name, path: '');

  static const String name = 'HomeRoute';
}

class BooksListRoute extends _i1.PageRouteInfo {
  const BooksListRoute() : super(name, path: 'books');

  static const String name = 'BooksListRoute';
}
