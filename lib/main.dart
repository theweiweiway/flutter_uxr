// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Deeplink path parameters example
// Done using AutoRoute
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_uxr/main.gr.dart';

void main() {
  runApp(BooksApp());
}

class Credentials {
  final String username;
  final String password;

  Credentials(this.username, this.password);
}

abstract class Authentication {
  Future<bool> isSignedIn();

  Future<void> signOut();

  Future<bool> signIn(String username, String password);
}

class MockAuthentication implements Authentication {
  bool _signedIn = false;

  @override
  Future<bool> isSignedIn() async {
    return _signedIn;
  }

  @override
  Future<void> signOut() async {
    _signedIn = false;
  }

  @override
  Future<bool> signIn(String username, String password) async {
    return _signedIn = true;
  }
}

class AppState extends ChangeNotifier {
  final Authentication auth;

  AppState(this.auth);

  Future<bool> signIn(String username, String password) async {
    var success = await auth.signIn(username, password);
    notifyListeners();
    return success;
  }

  Future<void> signOut() async {
    await auth.signOut();
    notifyListeners();
  }
}

// Declare routing setup
@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: "/",
      page: EmptyRouterScreen,
      guards: [AppGuard],
      children: [
        AutoRoute(path: "", page: HomeScreen),
        AutoRoute(path: "books", page: BooksListScreen),
      ],
    ),
    AutoRoute(path: "/signIn", guards: [SignInGuard], page: SignInScreen),
    RedirectRoute(path: "*", redirectTo: "/")
  ],
)
class $AppRouter {}

final AppState appState = AppState(MockAuthentication());

// Declare route guards
class SignInGuard extends AutoRouteGuard {
  @override
  Future<bool> canNavigate(
      List<PageRouteInfo> pendingRoutes, StackRouter router) async {
    if (await appState.auth.isSignedIn()) {
      router.replaceAll([HomeRoute()]);
      return false;
    }
    return true;
  }
}

class AppGuard extends AutoRouteGuard {
  @override
  Future<bool> canNavigate(
      List<PageRouteInfo> pendingRoutes, StackRouter router) async {
    if (!await appState.auth.isSignedIn()) {
      router.push(SignInRoute(onSignedIn: (c) {
        appState.signIn(c.username, c.password);
        router.replaceAll(pendingRoutes);
      }));
      return false;
    }
    return true;
  }
}

class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  late final _appRouter =
      AppRouter(appGuard: AppGuard(), signInGuard: SignInGuard());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.router.push(BooksListRoute()),
              child: Text('View my bookshelf'),
            ),
            ElevatedButton(
              onPressed: () async {
                appState.signOut();
                context.router.replaceAll([
                  SignInRoute(onSignedIn: (c) {
                    appState.signIn(c.username, c.password);
                    context.router.replaceAll([HomeRoute()]);
                  })
                ]);
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  final ValueChanged<Credentials> onSignedIn;

  SignInScreen({required this.onSignedIn});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'username (any)'),
              onChanged: (s) => _username = s,
            ),
            TextField(
              decoration: InputDecoration(hintText: 'password (any)'),
              obscureText: true,
              onChanged: (s) => _password = s,
            ),
            ElevatedButton(
              onPressed: () =>
                  widget.onSignedIn(Credentials(_username, _password)),
              child: Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}

class BooksListScreen extends StatelessWidget {
  BooksListScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ListTile(
            title: Text('Stranger in a Strange Land'),
            subtitle: Text('Robert A. Heinlein'),
          ),
          ListTile(
            title: Text('Foundation'),
            subtitle: Text('Isaac Asimov'),
          ),
          ListTile(
            title: Text('Fahrenheit 451'),
            subtitle: Text('Ray Bradbury'),
          ),
        ],
      ),
    );
  }
}

/// Deeplink path parameters example
/// Done using AutoRoute
// import 'package:flutter/material.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter_uxr/main.gr.dart';
// import 'package:provider/provider.dart';

// final AppState appState = AppState(MockAuthentication());

// void main() {
//   runApp(ChangeNotifierProvider(create: (_) => appState, child: BooksApp()));
// }

// class Credentials {
//   final String username;
//   final String password;

//   Credentials(this.username, this.password);
// }

// abstract class Authentication {
//   Future<bool> isSignedIn();

//   Future<void> signOut();

//   Future<bool> signIn(String username, String password);
// }

// class MockAuthentication implements Authentication {
//   bool _signedIn = false;

//   @override
//   Future<bool> isSignedIn() async {
//     return _signedIn;
//   }

//   @override
//   Future<void> signOut() async {
//     _signedIn = false;
//   }

//   @override
//   Future<bool> signIn(String username, String password) async {
//     return _signedIn = true;
//   }
// }

// class AppState extends ChangeNotifier {
//   final Authentication auth;

//   AppState(this.auth);

//   Future<bool> signIn(String username, String password) async {
//     var success = await auth.signIn(username, password);
//     notifyListeners();
//     return success;
//   }

//   Future<void> signOut() async {
//     await auth.signOut();
//     notifyListeners();
//   }
// }

// // Declare routing setup
// @MaterialAutoRouter(
//   replaceInRouteName: 'Screen,Route',
//   routes: <AutoRoute>[
//     AutoRoute(
//       path: "/",
//       name: 'App',
//       page: EmptyRouterScreen,
//       children: [
//         AutoRoute(path: "", page: HomeScreen),
//         AutoRoute(path: "books", page: BooksListScreen),
//       ],
//     ),
//     AutoRoute(path: "/signIn", page: SignInScreen),
//     RedirectRoute(path: "*", redirectTo: "/")
//   ],
// )
// class $AppRouter {}

// class BooksApp extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _BooksAppState();
// }

// class _BooksAppState extends State<BooksApp> {
//   final _appRouter = AppRouter();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       routeInformationParser: _appRouter.defaultRouteParser(),
//       routerDelegate: AutoRouterDelegate.declarative(
//         _appRouter,
//         routes: (context) {
//           var a = context.watch<AppState>();
//           print(a);
//           var authenticated;
//           Future.delayed(Duration.zero, () async {
//             authenticated = await appState.auth.isSignedIn();
//           });
//           return [
//             if (authenticated == true) App() else SignInRoute(),
//           ];
//         },
//       ),
//     );
//   }
// }

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: () => context.router.push(BooksListRoute()),
//               child: Text('View my bookshelf'),
//             ),
//             ElevatedButton(
//               onPressed: () => appState.signOut(),
//               child: Text('Sign out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class SignInScreen extends StatefulWidget {
//   @override
//   _SignInScreenState createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   String _username = '';
//   String _password = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(hintText: 'username (any)'),
//               onChanged: (s) => _username = s,
//             ),
//             TextField(
//               decoration: InputDecoration(hintText: 'password (any)'),
//               obscureText: true,
//               onChanged: (s) => _password = s,
//             ),
//             ElevatedButton(
//               onPressed: () =>
//                   context.read<AppState>().auth.signIn(_username, _password),
//               child: Text('Sign in'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BooksListScreen extends StatelessWidget {
//   BooksListScreen();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         children: [
//           ListTile(
//             title: Text('Stranger in a Strange Land'),
//             subtitle: Text('Robert A. Heinlein'),
//           ),
//           ListTile(
//             title: Text('Foundation'),
//             subtitle: Text('Isaac Asimov'),
//           ),
//           ListTile(
//             title: Text('Fahrenheit 451'),
//             subtitle: Text('Ray Bradbury'),
//           ),
//         ],
//       ),
//     );
//   }
// }
