import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'routes/app_routes.dart';
import '../data/providers/app_state_provider.dart';
import '../features/splash/splash_screen.dart';
import '../features/authentication/login_screen.dart';
import '../features/authentication/register_screen.dart';
import '../features/authentication/forgot_password_screen.dart';
import '../features/elderly/elderly_main_navigation.dart';
import '../features/caregiver/caregiver_main_navigation.dart';

class CareLinkApp extends StatelessWidget {
  const CareLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.elderlyMain: (_) => const ElderlyMainNavigation(),
        AppRoutes.caregiverMain: (_) => const CaregiverMainNavigation(),
      },
    );
  }
}
