import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:resq_meal/constants/app_constants.dart';
import 'package:resq_meal/providers/app_providers.dart';
import 'package:resq_meal/providers/auth_provider.dart';
import 'package:resq_meal/providers/onboarding_provider.dart';
import 'package:resq_meal/routes/app_router.dart';
import 'package:resq_meal/theme/app_colors.dart';
import 'package:resq_meal/theme/app_theme.dart';
import 'package:resq_meal/widgets/app/fcm_token_sync.dart';

class ResQMealApp extends StatefulWidget {
  const ResQMealApp({super.key});

  @override
  State<ResQMealApp> createState() => _ResQMealAppState();
}

class _ResQMealAppState extends State<ResQMealApp> {
  final Future<List<SingleChildWidget>> _providersFuture = buildAppProviders();
  AppRouter? _appRouter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SingleChildWidget>>(
      future: _providersFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const Scaffold(
              backgroundColor: AppColors.white,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }

        return MultiProvider(
          providers: snapshot.data!,
          child: Consumer2<AuthProvider, OnboardingProvider>(
            builder: (context, auth, onboarding, _) {
              _appRouter ??= AppRouter(
                authProvider: auth,
                onboardingProvider: onboarding,
              );

              return FcmTokenSync(
                child: MaterialApp.router(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.light,
                  routerConfig: _appRouter!.router,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
