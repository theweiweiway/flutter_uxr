// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
//
/// Dynamic linking example
/// Done using AutoRoute

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_uxr/main.gr.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(WishListApp());
}

class Wishlist {
  final String id;

  Wishlist(this.id);
}

class AppState extends ChangeNotifier {
  final List<Wishlist> wishlists = <Wishlist>[];

  void addWishlist(Wishlist wishlist) {
    wishlists.add(wishlist);
    notifyListeners();
  }
}

// Declare routing setup
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: "/",
      page: EmptyRouterPage,
      children: [
        AutoRoute(path: "", page: WishlistListPage),
        AutoRoute(path: "wishlist/:id", page: WishlistPage),
      ],
    ),
    RedirectRoute(path: "*", redirectTo: "/")
  ],
)
class $AppRouter {}

class WishListApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _WishListAppState();
}

class _WishListAppState extends State<WishListApp> {
  final AppState _appState = AppState();
  late final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      builder: (_, router) {
        return ChangeNotifierProvider(create: (_) => _appState, child: router);
      },
    );
  }
}

class WishlistListPage extends StatelessWidget {
  void onCreate(BuildContext context, String value) {
    final wishlist = Wishlist(value);
    context.read<AppState>().addWishlist(wishlist);
    context.router.navigateNamed('/wishlist/$value');
  }

  @override
  Widget build(BuildContext context) {
    final wishlists = context.watch<AppState>().wishlists;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('Navigate to /wishlist/<ID> in the URL bar to dynamically '
                    'create a new wishlist.'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                var randomInt = Random().nextInt(10000);
                onCreate(context, '$randomInt');
              },
              child: Text('Create a new Wishlist'),
            ),
          ),
          for (var i = 0; i < wishlists.length; i++)
            ListTile(
              title: Text('Wishlist ${i + 1}'),
              subtitle: Text(wishlists[i].id),
              onTap: () =>
                  context.router.navigateNamed("/wishlist/${wishlists[i].id}"),
            )
        ],
      ),
    );
  }
}

class WishlistPage extends StatefulWidget {
  WishlistPage({@PathParam('id') required this.id});
  final String id;

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    final _appState = context.read<AppState>();
    if (_appState.wishlists.indexWhere((element) => element.id == widget.id) ==
        -1) {
      _appState.addWishlist(Wishlist(widget.id));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${widget.id}',
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}
