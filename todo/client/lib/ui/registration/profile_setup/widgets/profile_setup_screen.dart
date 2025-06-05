import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/registration/profile_setup/view_models/profile_setup_view_model.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({
    super.key,
    required this.id,
    required this.code,
    required this.viewModel,
  });

  final String id;
  final String code;
  final ProfileSetupViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _ProfileSetupScreen();
  }
}

class _ProfileSetupScreen extends State<ProfileSetupScreen> {
  final TextEditingController _username = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    widget.viewModel.setupProfile.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant ProfileSetupScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.setupProfile.removeListener(_onResult);
    widget.viewModel.setupProfile.addListener(_onResult);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.setupProfile.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.setupProfile.completed) {
      GoRouter.of(context).go("/");
      widget.viewModel.setupProfile.clearResult();
      return;
    }
    if (widget.viewModel.setupProfile.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.setupProfile.errorMessage!)),
      );
      widget.viewModel.setupProfile.clearResult();
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.popUpConfirmationTitle),
          content: Text(AppLocalizations.of(context)!.popUpRegistrationDesc),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.popUpCancel),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.popUpConfirm),
              onPressed: () {
                context.go("/");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog() ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Dimens.of(context).edgeInsetsScreenSymmetric,
            child: Column(
              children: [
                _profileSetupTitle(),
                Expanded(child: Center(child: _profileSetupForm())),
                _profileSetupButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileSetupTitle() {
    return Text(
      AppLocalizations.of(context)!.profileSetupTitle,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
      ),
    );
  }

  Widget _profileSetupForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: Dimens.of(context).edgeInsetsScreenVertical,
          child: TextField(
            maxLength: 25,
            controller: _username,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.usernameHint,
              counterText: "",
              border: OutlineInputBorder(),
              label: Text(AppLocalizations.of(context)!.usernameLabel),
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileSetupButton() {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return FilledButton(
                onPressed: () {
                  if (_username.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.setupProfile.execute((
                      widget.id,
                      widget.code,
                      _username.text,
                    ));
                  }
                },
                child: Text(AppLocalizations.of(context)!.profileSetupButton),
              );
            },
          ),
        ),
      ],
    );
  }
}
