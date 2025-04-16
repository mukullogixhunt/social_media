
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/post/presentation/screens/home_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

const Duration transitionDuration = Duration(milliseconds: 600);
const Offset slideInFromRight = Offset(1.0, 0.0);
const Offset slideUpFromBottom = Offset(0.0, 1.0);
const Curve transitionCurve = Curves.easeInOut;

CustomTransitionPage buildTransitionPage(Widget child, Offset begin) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: transitionDuration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var tween = Tween(
        begin: begin,
        end: Offset.zero,
      ).chain(CurveTween(curve: transitionCurve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: /*'/'*/LoginScreen.path,
  navigatorKey: rootNavigatorKey,
  routes: [
    GoRoute(
      path: LoginScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const LoginScreen(), slideInFromRight),
    ),

    GoRoute(
      path: SignupScreen.path,
      pageBuilder:
          (context, state) =>
              buildTransitionPage(const SignupScreen(), slideInFromRight),
    ),
    GoRoute(
      path: HomeScreen.path, // Add Home Screen route
      pageBuilder: (context, state) => NoTransitionPage( // Or your preferred transition
        child: const HomeScreen(),
      ),
    ),
  ],
  redirect: (BuildContext context, GoRouterState state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn = state.matchedLocation == LoginScreen.path || state.matchedLocation == SignupScreen.path;

    // If not logged in and trying to access anything other than login/signup, redirect to login
    if (!loggedIn && !loggingIn) {
      print('Redirecting to login: Not logged in, accessing ${state.matchedLocation}');
      return LoginScreen.path;
    }

    // If logged in and trying to access login/signup, redirect to home
    if (loggedIn && loggingIn) {
      print('Redirecting to home: Logged in, accessing login/signup');
      return HomeScreen.path;
    }

    // Otherwise, allow navigation
    print('No redirection needed for ${state.matchedLocation}');
    return null; // No redirect needed
  },
);
