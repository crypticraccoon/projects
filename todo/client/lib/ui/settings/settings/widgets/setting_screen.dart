import 'package:provider/provider.dart';
import 'package:todo/ui/auth/logout/view_models/logout_button_view_model.dart';
import 'package:todo/ui/auth/logout/widgets/logout_button.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/settings/settings/view_models/settings_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.viewModel});

  final SettingsViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _SettingsScreen();
  }
}

class _SettingsScreen extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Dimens.of(context).edgeInsetsScreenSymmetric,
          child: Column(
            children: [
              _accountCard(),
              Padding(
                padding: EdgeInsetsGeometry.only(
                  top: Dimens.of(context).paddingScreenVertical,
                ),
                child: LogoutButton(
                  viewModel: LogoutButtonViewModel(authRepo: context.read()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _accountCard() {
    return ListenableBuilder(
      listenable: widget.viewModel.loadUserData,
      builder: (context, _) {
        return widget.viewModel.loadUserData.completed
            ? SizedBox(
              width: double.maxFinite,
              child: Card(
                elevation: 5,
                child: Padding(
                  padding: Dimens.of(context).edgeInsetsScreenSymmetric,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.settingsAccountTitle,
                        style: TextStyle(fontWeight: FontWeight.w300),
                      ),
                      Divider(),

                      _accountButton(
                        "/home/settings/email",
                        widget.viewModel.userData!.getEmail,
                        Icons.perm_identity,
                      ),
                      _accountButton(
                        "/home/settings/username",
                        widget.viewModel.userData!.getUsername,
                        Icons.badge,
                      ),
                      _accountButton(
                        "/home/settings/password",
                        AppLocalizations.of(context)!.passwordHint,
                        Icons.password,
                      ),
                    ],
                  ),
                ),
              ),
            )
            : CircularProgressIndicator();
      },
    );
  }

  Widget _accountButton(String path, String text, IconData icon) {
    return TextButton(
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),

      onPressed: () {
        context.go(path);
      },
      child: Row(
        children: [
          Icon(icon),
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: Dimens.of(context).paddingScreenHorizontal,
              ),
              child: Text(text, overflow: TextOverflow.ellipsis),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
        ],
      ),
    );

  }
}
