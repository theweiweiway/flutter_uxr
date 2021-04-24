// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Deeplink path parameters example
/// Done using AutoRoute
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_uxr/main.gr.dart';
import 'package:provider/provider.dart';

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
      name: 'AppStack',
      page: EmptyRouterPage,
      guards: [SignedInGuard],
      children: [
        AutoRoute(path: "", page: HomeScreen),
        AutoRoute(path: "books", page: BooksListScreen),
      ],
    ),
    AutoRoute(path: "/signIn", guards: [SignedOutGuard], page: SignInScreen),
    RedirectRoute(path: "*", redirectTo: "/")
  ],
)
class $AppRouter {}

// Declare route guards
class SignedOutGuard extends AutoRouteGuard {
  final AppState appState;
  SignedOutGuard({required this.appState});

  @override
  Future<bool> canNavigate(
      List<PageRouteInfo> pendingRoutes, StackRouter router) async {
    if (await appState.auth.isSignedIn()) {
      router.root.pushPath("/");
      return false;
    }
    return true;
  }
}

class SignedInGuard extends AutoRouteGuard {
  final AppState appState;
  SignedInGuard({required this.appState});

  @override
  Future<bool> canNavigate(
      List<PageRouteInfo> pendingRoutes, StackRouter router) async {
    if (!await appState.auth.isSignedIn()) {
      router.root.push(SignInRoute(onSignedIn: (c) {
        appState.signIn(c.username, c.password);
        router.replaceAll(pendingRoutes);
      }));
      return false;
    }
    return true;
  }
}

// Main App
class BooksApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  AppState _appState = AppState(MockAuthentication());

  late final _appRouter = AppRouter(
      signedOutGuard: SignedOutGuard(appState: _appState),
      signedInGuard: SignedInGuard(appState: _appState));

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      builder: (_, router) {
        return ChangeNotifierProvider(
          create: (_) => _appState,
          child: router,
        );
      },
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
                // this signOut function is why I need to use a ChangeNotifier.
                // If there was a way to expose a signOut() function on the HomeScreen,
                // through the routing setup, I could eliminate ChangeNotifier and make
                // this more like the Flutter_UXR examples.
                context.read<AppState>().signOut();

                // IF i did `.push` instead of `.replace`, I would be able to
                // pop back to the HomePage even though I am now signed out.
                // I believe is because the `Guard` does not fire when popping
                //
                // By using replace, it fixes this problem - however, I think
                // it probably makes sense for the `Guard` should fire on pop
                context.router.root.replace(SignInRoute(onSignedIn: (c) {
                  context.read<AppState>().signIn(c.username, c.password);
                }));
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
