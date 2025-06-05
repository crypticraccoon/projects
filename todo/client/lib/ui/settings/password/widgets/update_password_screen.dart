import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/ui/settings/password/view_models/update_password_viewmodel.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key, required this.viewModel});

  final UpdatePasswordViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdatePasswordScreen();
  }
}

class _UpdatePasswordScreen extends State<UpdatePasswordScreen> {
  final TextEditingController _newPassword = TextEditingController(text: '');
  final TextEditingController _confirmPassword = TextEditingController(
    text: '',
  );
  final TextEditingController _oldPassword = TextEditingController(text: '');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.updatePassword.addListener(_result);
  }

  @override
  void didUpdateWidget(covariant UpdatePasswordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.updatePassword.removeListener(_result);
    widget.viewModel.updatePassword.addListener(_result);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updatePassword.removeListener(_result);
  }

  void _result() {
    if (widget.viewModel.updatePassword.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordUpdatedText),
        ),
      );
      widget.viewModel.updatePassword.clearResult();
      context.go("/home/settings");
    }

    if (widget.viewModel.updatePassword.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.updatePassword.errorMessage!)),
      );
      widget.viewModel.updatePassword.clearResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Dimens.of(context).edgeInsetsScreenSymmetric,
          child: Column(
            children: [
              _updateTitle(),
              Expanded(child: Center(child: _updateForm())),
              _updateButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateTitle() {
    return Text(
      AppLocalizations.of(context)!.updatePasswordTitle,
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
      ),
    );
  }

  Widget _updateForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          obscureText: _obscurePassword,
          maxLength: 25,
          controller: _oldPassword,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.oldPasswordLabel),
            hintText: AppLocalizations.of(context)!.oldPasswordHint,
            border: OutlineInputBorder(),
            counterText: "",
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              child: Icon(
                _obscurePassword
                    ? Icons.remove_red_eye_sharp
                    : Icons.remove_red_eye_outlined,
              ),
            ),
          ),
        ),
        Padding(
          padding: Dimens.of(context).edgeInsetsScreenVertical,
          child: TextField(
            obscureText: _obscurePassword,
            maxLength: 25,
            controller: _newPassword,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.newPasswordLabel),
              hintText: AppLocalizations.of(context)!.newPasswordHint,
              border: OutlineInputBorder(),
              counterText: "",
            ),
          ),
        ),
        TextField(
          obscureText: _obscurePassword,
          maxLength: 25,
          controller: _confirmPassword,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.confirmPasswordLabel),
            hintText: AppLocalizations.of(context)!.confirmPasswordHint,
            border: OutlineInputBorder(),
            counterText: "",
          ),
        ),
      ],
    );
  }

  Widget _updateButton() {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return FilledButton(
                onPressed: () {
                  if (_oldPassword.text.isEmpty ||
                      _newPassword.text.isEmpty ||
                      _confirmPassword.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else if (_newPassword.text != _confirmPassword.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.mismatchPasswordsError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.updatePassword.execute((
                      _newPassword.value.text,
                      _oldPassword.value.text,
                    ));
                  }
                },

                child: Text(AppLocalizations.of(context)!.updateButton),
              );
            },
          ),
        ),
      ],
    );
  }
}
