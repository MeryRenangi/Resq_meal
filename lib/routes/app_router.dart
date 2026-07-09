import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:resq_meal/constants/route_names.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/navigation_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/routes/app_routes.dart';
import 'package:resq_meal/screens/auth/forgot_password_screen.dart';
import 'package:resq_meal/screens/auth/login_screen.dart';
import 'package:resq_meal/screens/auth/onboarding_screen.dart';
import 'package:resq_meal/screens/auth/register_screen.dart';
import 'package:resq_meal/screens/auth/role_selection_screen.dart';
import 'package:resq_meal/screens/auth/splash_screen.dart';
import 'package:resq_meal/screens/shell/main_shell_screen.dart';
import 'package:resq_meal/screens/shell/shell_tab_screen.dart';
import 'package:resq_meal/widgets/navigation/nav_destinations.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter({
    required this._authProvider,
    required this._onboardingProvider,
  });

  final AuthProvider _authProvider;
  final OnboardingProvider _onboardingProvider;

  late final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: Listenable.merge([_authProvider, _onboardingProvider]),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SplashScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => _fadePage(state, const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        name: RouteNames.roleSelection,
        pageBuilder: (context, state) => _fadePage(state, const RoleSelectionScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => _fadePage(state, const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: RouteNames.register,
        pageBuilder: (context, state) => _slidePage(state, const RegisterScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: RouteNames.forgotPassword,
        pageBuilder: (context, state) => _slidePage(state, const ForgotPasswordScreen()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          for (var i = 0; i < NavDestinations.tabCount; i++)
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: _shellPathForIndex(i),
                  name: _shellNameForIndex(i),
                  pageBuilder: (context, state) => NoTransitionPage(
                    child: ShellTabScreen(tabIndex: i),
                  ),
                ),
              ],
            ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.uri}')),
    ),
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final auth = _authProvider;
    final onboarding = _onboardingProvider;

    if (!auth.isInitialized || !onboarding.isInitialized) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    if (auth.isAuthenticated) {
      if (AppRoutes.authFlowRoutes.contains(location)) {
        return AppRoutes.home;
      }
      return null;
    }

    if (!onboarding.isOnboardingComplete) {
      return location == AppRoutes.onboarding ? null : AppRoutes.onboarding;
    }

    if (!onboarding.hasSelectedRole) {
      return location == AppRoutes.roleSelection ? null : AppRoutes.roleSelection;
    }

    if (location == AppRoutes.splash) {
      return AppRoutes.login;
    }

    if (AppRoutes.shellRoutes.contains(location)) {
      return AppRoutes.login;
    }

    return null;
  }

  static CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1, 0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static String _shellPathForIndex(int index) {
    return switch (index) {
      0 => AppRoutes.home,
      1 => AppRoutes.explore,
      2 => AppRoutes.orders,
      3 => AppRoutes.profile,
      _ => AppRoutes.home,
    };
  }

  static String _shellNameForIndex(int index) {
    return switch (index) {
      0 => RouteNames.home,
      1 => RouteNames.explore,
      2 => RouteNames.orders,
      3 => RouteNames.profile,
      _ => RouteNames.home,
    };
  }
}

/// Syncs [NavigationProvider] when shell tab changes via router.
void syncNavIndexFromShell(BuildContext context, int index) {
  context.read<NavigationProvider>().setIndex(index);
}
