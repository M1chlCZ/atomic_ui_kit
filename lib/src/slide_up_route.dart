import 'package:flutter/material.dart';

/// Creates a route that slides [page] up from the bottom of the screen.
Route<void> slideUpRoute(Widget page) {
  return PageRouteBuilder<void>(
    pageBuilder: (_, _, _) => page,
    transitionDuration: const Duration(milliseconds: 500),
    transitionsBuilder: (_, Animation<double> animation, _, Widget child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: const Offset(0.0, 0.0),
        ).chain(CurveTween(curve: Curves.easeOut)).animate(animation),
        child: child,
      );
    },
  );
}
