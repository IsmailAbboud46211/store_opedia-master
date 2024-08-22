import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopesapp/presentation/pages/control_page.dart';
import 'package:shopesapp/presentation/pages/login_page.dart';
import 'package:shopesapp/presentation/pages/porfile.dart';
import 'package:shopesapp/presentation/pages/privacy%20policies.dart';
import 'package:shopesapp/presentation/pages/settings.dart';
import 'package:shopesapp/presentation/pages/splash_screen_page.dart';

import 'package:shopesapp/presentation/pages/verify_password.dart';

import '../../logic/cubites/user/auth_cubit.dart';
import '../../logic/cubites/user/auth_state.dart';

class AppRouter {
  Route? onGeneratedRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) {
          return BlocBuilder<AuthCubit, AuthState>(builder: ((context, state) {
            if (state is UserLoginedIn || state is OwnerLoginedIn) {
              return const ControlPage();
            } else {
              return const SplashScreenPage();
            }
          }));
        });

      case '/control':
        return MaterialPageRoute(builder: (context) {
          return const ControlPage();
        });
      case '/verifiy':
        return MaterialPageRoute(builder: (context) {
          return const VerifyPassword();
        });
      case '/settings':
        return MaterialPageRoute(builder: (context) {
          return const SettingsPage();
        });
      case '/privacy&policies':
        return MaterialPageRoute(builder: (context) {
          return const PrivacyPlicies();
        });
      case '/login':
        return MaterialPageRoute(builder: (context) {
          return const LoginPage();
        });

      case '/profile':
        return MaterialPageRoute(builder: (context) {
          return const ProfilePage();
        });
    }
    return null;
  }
}
