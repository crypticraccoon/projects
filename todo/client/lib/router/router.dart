import 'package:todo/data/repositories/api_repository.dart';
import 'package:todo/router/routes.dart';
import 'package:todo/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:todo/ui/auth/login/widgets/login_screen.dart';
import 'package:todo/ui/home/view_models/create_todo_viewmodel.dart';
import 'package:todo/ui/home/view_models/home_viewmodel.dart';
import 'package:todo/ui/home/view_models/update_todo_viewmodel.dart';
import 'package:todo/ui/home/widgets/create_todo_screen.dart';
import 'package:todo/ui/home/widgets/home_screen.dart';
import 'package:todo/ui/home/widgets/update_todo_screen.dart';
import 'package:todo/ui/password_recovery/recovery/view_model/recovery_view_model.dart';
import 'package:todo/ui/password_recovery/recovery/widgets/recovery_screen.dart';
import 'package:todo/ui/password_recovery/update/view_model/update_password_view_model.dart';
import 'package:todo/ui/password_recovery/update/widgets/update_screen.dart';
import 'package:todo/ui/registration/profile_setup/view_models/profile_setup_view_model.dart';
import 'package:todo/ui/registration/profile_setup/widgets/profile_setup_screen.dart';
import 'package:todo/ui/registration/registration/view_models/registration_view_model.dart';
import 'package:todo/ui/registration/registration/widgets/registration_screen.dart';
import 'package:todo/ui/settings/email/view_models/update_email_viewmodel.dart';
import 'package:todo/ui/settings/email/widgets/update_email_screen.dart';
import 'package:todo/ui/settings/password/view_models/update_password_viewmodel.dart';
import 'package:todo/ui/settings/password/widgets/update_password_screen.dart';
import 'package:todo/ui/settings/settings/view_models/settings_viewmodel.dart';
import 'package:todo/ui/settings/settings/widgets/setting_screen.dart';
import 'package:todo/ui/settings/username/view_models/update_username_viewmodel.dart';
import 'package:todo/ui/settings/username/widgets/update_username_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
  debugLogDiagnostics: false,
  refreshListenable: authRepository,
  redirect: _redirect,
  initialLocation: "/",
  //initialLocation: "/home",
  routes: [_login(), _home()],
);

GoRoute _login() {
  return GoRoute(
    path: Routes.login,
    builder: (context, state) {
      return LoginScreen(
        viewModel: LoginViewModel(authRepository: context.read()),
      );
    },
    routes: [_recovery(), _register()],
  );
}

GoRoute _recovery() {
  return GoRoute(
    path: Routes.recover,

    builder: (context, state) {
      return PasswordRecoveryScreen(
        viewModel: PasswordRecoveryViewmodel(
          recoveryRepository: context.read(),
        ),
      );
    },

    routes: [
      GoRoute(
        path: Routes.recoveryUpdate,
        builder: (context, state) {
          return UpdateRecoveryPasswordScreen(
            email: state.pathParameters['email']!,
            code: state.pathParameters['code']!,
            viewModel: UpdateRecoveryPasswordViewModel(
              recoveryRepository: context.read(),
            ),
          );
        },
      ),
    ],
  );
}

GoRoute _register() {
  return GoRoute(
    path: Routes.register,
    builder: (context, state) {
      return RegistrationScreen(
        viewModel: RegistrationViewModel(
          registrationRepository: context.read(),
        ),
      );
    },

    routes: [
      GoRoute(
        path: Routes.registerProfileSetup,
        builder: (context, state) {
          return ProfileSetupScreen(
            id: state.pathParameters['id']!,
            code: state.pathParameters['code']!,
            viewModel: ProfileSetupViewModel(
              registrationRepository: context.read(),
            ),
          );
        },
      ),
    ],
  );
}

GoRoute _home() {
  return GoRoute(
    path: Routes.home,
    builder: (context, state) {
      //final viewModel = HomeViewModel(
      //userRepository: context.read(),
      //todoRepository: context.read(),
      //sharedPrefrences: context.read(),
      //);
      //viewModel.loadUserData.execute();
      //viewModel.getUsername.execute();
      return HomeScreen(
        viewModel: HomeViewModel(
          userRepository: context.read(),
          todoRepository: context.read(),
          sharedPrefrences: context.read(),
        ),
      );
    },
    routes: [
      _settings(),

      GoRoute(
        path: Routes.createTodo,
        builder: (context, state) {
          return CreateTodoScreen(
            viewModel: CreateTodoViewModel(todoRepository: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.updateTodo,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;

          return UpdateTodoScreen(
            extra: extra,
            viewModel: UpdateTodoViewModel(todoRepository: context.read()),
          );
        },
      ),
    ],
  );
}

GoRoute _settings() {
  return GoRoute(
    path: Routes.settings,
    builder: (context, state) {
      return SettingsScreen(
        viewModel: SettingsViewModel(
          sharedPrefrences: context.read(),
          userRepository: context.read(),
          authRepository: context.read(),
        ),
      );
    },
    routes: [
      GoRoute(
        path: Routes.settingsUpdateUsername,
        builder: (context, state) {
          return UpdateUsernameScreen(
            viewModel: UpdateUsernameViewmodel(userRepository: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.settingsUpdatePassword,
        builder: (context, state) {
          return UpdatePasswordScreen(
            viewModel: UpdatePasswordViewModel(userRepository: context.read()),
          );
        },
      ),
      GoRoute(
        path: Routes.settingsUpdateEmail,
        builder: (context, state) {
          return UpdateEmailScreen(
            viewModel: UpdateEmailViewmodel(userRepository: context.read()),
          );
        },
      ),
    ],
  );
}

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  final isUserLoggedIn = await context.read<AuthRepository>().isAuthenticated;
  final loggingIn = state.matchedLocation == Routes.login;
  final register = state.matchedLocation.contains(Routes.register);
  final recover = state.matchedLocation.contains(Routes.recover);
  if (!isUserLoggedIn && !recover && !register) {
    return Routes.login;
  }

  if (loggingIn) {
    return Routes.home;
  }

  return null;
}
