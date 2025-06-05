import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/password_recovery/update/view_model/update_password_view_model.dart';

class UpdateRecoveryPasswordScreen extends StatefulWidget {
  const UpdateRecoveryPasswordScreen({
    super.key,
    required this.email,
    required this.code,
    required this.viewModel,
  });

  final String email;
  final String code;
  final UpdateRecoveryPasswordViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateRecoveryPasswordScreen();
  }
}

class _UpdateRecoveryPasswordScreen
    extends State<UpdateRecoveryPasswordScreen> {
  final TextEditingController _password = TextEditingController(text: '');
  final TextEditingController _confirmPassword = TextEditingController(
    text: '',
  );
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.updatePassword.addListener(_result);
  }

  @override
  void didUpdateWidget(covariant UpdateRecoveryPasswordScreen oldWidget) {
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
          content: Text(widget.viewModel.updatePassword.responseData as String),
        ),
      );
      widget.viewModel.updatePassword.clearResult();
      context.go("/");
    }

    if (widget.viewModel.updatePassword.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.updatePassword.errorMessage!)),
      );
      widget.viewModel.updatePassword.clearResult();
    }
  }

  Future<bool?> _showBackDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.popUpConfirmationTitle),
          content: Text(
            AppLocalizations.of(context)!.popUpRecoveryPasswordDesc,
          ),
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
                _updateTitle(),
                Expanded(child: Center(child: _updateForm())),
                _updateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _updateTitle() {
    return Text(
      AppLocalizations.of(context)!.recoveryUpdateNewPasswordTitle,
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
          controller: _password,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.passwordLabel),
            hintText: AppLocalizations.of(context)!.passwordHint,
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
            controller: _confirmPassword,
            decoration: InputDecoration(
              label: Text(AppLocalizations.of(context)!.confirmPasswordLabel),
              hintText: AppLocalizations.of(context)!.confirmPasswordHint,
              border: OutlineInputBorder(),
              counterText: "",
            ),
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
                  if (_confirmPassword.value.text != _password.value.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.mismatchPasswordsError,
                        ),
                      ),
                    );
                  } else if (_confirmPassword.text == "" ||
                      _password.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.updatePassword.execute((
                      widget.email,
                      widget.code,
                      _password.value.text,
                    ));
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.recoveryUpdatePasswordButton,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
