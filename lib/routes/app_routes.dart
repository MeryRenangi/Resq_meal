abstract final class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  static const String home = '/home';
  static const String explore = '/explore';
  static const String orders = '/orders';
  static const String profile = '/profile';

  static const Set<String> authFlowRoutes = {
    splash,
    onboarding,
    roleSelection,
    login,
    register,
    forgotPassword,
  };

  static const Set<String> shellRoutes = {
    home,
    explore,
    orders,
    profile,
  };
}
