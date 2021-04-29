// Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Skipping stacks example
/// Done using AutoRoute
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_uxr/main.gr.dart';

void main() {
  runApp(BooksApp());
}

class Book {
  final String title;
  final Author author;

  Book(this.title, this.author);
}

class Author {
  String name;

  Author(this.name);
}

class AppState extends ChangeNotifier {
  final List<Book> books = [
    Book('Stranger in a Strange Land', Author('Robert A. Heinlein')),
    Book('Foundation', Author('Isaac Asimov')),
    Book('Fahrenheit 451', Author('Ray Bradbury')),
  ];

  List<Author> get authors => [...books.map((book) => book.author)];
}

// Declare routing setup
@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      name: 'RootRouter',
      page: EmptyRouterPage,
      path: "/",
      children: [
        RedirectRoute(path: "", redirectTo: "books"),
        AutoRoute(
          path: 'books',
          page: BooksListPage,
        ),
        AutoRoute(
          path: 'book/:bookId',
          page: BookDetailsPage,
        ),
        AutoRoute(
          path: 'authors',
          page: AuthorsListPage,
        ),
        AutoRoute(
          path: 'author/:bookId',
          page: AuthorDetailsPage,
        ),
      ],
    ),
    RedirectRoute(path: "*", redirectTo: "/ ")
  ],
)
class $AppRouter {}

final AppState appState = AppState();

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

class BooksListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final books = appState.books;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          for (var book in books)
            ListTile(
              title: Text(book.title),
              subtitle: Text(book.author.name),
              onTap: () =>
                  context.router.pushNamed('/book/${books.indexOf(book)}'),
            )
        ],
      ),
    );
  }
}

class AuthorsListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authors = appState.authors;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () => context.router.pushNamed('/'),
            child: Text('Go to Books Page'),
          ),
          for (var author in authors)
            ListTile(
              title: Text(author.name),
              onTap: () => context.router
                  .pushNamed('/author/${authors.indexOf(author)}'),
            )
        ],
      ),
    );
  }
}

class BookDetailsPage extends StatelessWidget {
  final int bookId;

  BookDetailsPage({@PathParam('bookId') required this.bookId});

  @override
  Widget build(BuildContext context) {
    final book = appState.books[bookId];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.title, style: Theme.of(context).textTheme.headline6),
            ElevatedButton(
              // push both the AuthorsListRoute and AuthorsDetailsRoute
              onPressed: () => context.router.push(RootRouter(children: [
                AuthorsListRoute(),
                AuthorDetailsRoute(bookId: bookId)
              ])),
              child: Text(book.author.name),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthorDetailsPage extends StatelessWidget {
  final int bookId;

  AuthorDetailsPage({@PathParam('bookId') required this.bookId});

  @override
  Widget build(BuildContext context) {
    final author = appState.authors[bookId];
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(author.name, style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}

// // Copyright 2021, the Flutter project authors. Please see the AUTHORS file
// // for details. All rights reserved. Use of this source code is governed by a
// // BSD-style license that can be found in the LICENSE file.

// /// Skipping stacks example
// /// Done using AutoRoute
// import 'package:flutter/material.dart';
// import 'package:vrouter/vrouter.dart';

// void main() {
//   runApp(BooksApp());
// }

// class Book {
//   final String title;
//   final Author author;

//   Book(this.title, this.author);
// }

// class Author {
//   String name;

//   Author(this.name);
// }

// class AppState extends ChangeNotifier {
//   final List<Book> books = [
//     Book('Stranger in a Strange Land', Author('Robert A. Heinlein')),
//     Book('Foundation', Author('Isaac Asimov')),
//     Book('Fahrenheit 451', Author('Ray Bradbury')),
//   ];

//   List<Author> get authors => [...books.map((book) => book.author)];
// }

// class BooksApp extends StatelessWidget {
//   final AppState _appState = AppState();

//   @override
//   Widget build(BuildContext context) {
//     return VRouter(
//       routes: [
//         // Books
//         VWidget(
//           path: '/',
//           widget: BooksListPage(books: _appState.books),
//           stackedRoutes: [
//             VWidget(
//               path: r'book/:bookId(\d+)',
//               widget: Builder(
//                 builder: (context) {
//                   final bookId =
//                       int.parse(context.vRouter.pathParameters['bookId']!);
//                   return BookDetailsPage(
//                     book: _appState.books[bookId],
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),

//         // Authors
//         VWidget(
//           path: '/authors',
//           widget: AuthorsListPage(authors: _appState.authors),
//           stackedRoutes: [
//             VWidget(
//               path: r'/author/:bookId(\d+)',
//               widget: Builder(
//                 builder: (context) {
//                   final bookId =
//                       int.parse(context.vRouter.pathParameters['bookId']!);
//                   return AuthorDetailsPage(
//                     author: _appState.books[bookId].author,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),

//         // Redirect unknown
//         VRouteRedirector(path: r'.+', redirectTo: '/'),
//       ],
//     );
//   }
// }

// class BooksListPage extends StatelessWidget {
//   final List<Book> books;

//   BooksListPage({required this.books});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         children: [
//           for (var book in books)
//             ListTile(
//               title: Text(book.title),
//               subtitle: Text(book.author.name),
//               onTap: () => context.vRouter.push('/book/${books.indexOf(book)}'),
//             )
//         ],
//       ),
//     );
//   }
// }

// class AuthorsListPage extends StatelessWidget {
//   final List<Author> authors;

//   AuthorsListPage({required this.authors});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         children: [
//           ElevatedButton(
//             onPressed: () => context.vRouter.push('/'),
//             child: Text('Go to Books Page'),
//           ),
//           for (var author in authors)
//             ListTile(
//               title: Text(author.name),
//               onTap: () =>
//                   context.vRouter.push('/author/${authors.indexOf(author)}'),
//             )
//         ],
//       ),
//     );
//   }
// }

// class BookDetailsPage extends StatelessWidget {
//   final Book book;

//   BookDetailsPage({required this.book});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(book.title, style: Theme.of(context).textTheme.headline6),
//             ElevatedButton(
//               onPressed: () => context.vRouter
//                   .push('/author/${context.vRouter.pathParameters['bookId']}'),
//               child: Text(book.author.name),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class AuthorDetailsPage extends StatelessWidget {
//   final Author author;

//   AuthorDetailsPage({
//     required this.author,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(author.name, style: Theme.of(context).textTheme.headline6),
//           ],
//         ),
//       ),
//     );
//   }
// }
