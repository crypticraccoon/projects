import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/password_recovery/recovery/view_model/recovery_view_model.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key, required this.viewModel});

  final PasswordRecoveryViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _PasswordRecoveryScreen();
  }
}

class _PasswordRecoveryScreen extends State<PasswordRecoveryScreen> {
  final TextEditingController _email = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.sendRecoveryEmail.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant PasswordRecoveryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.sendRecoveryEmail.removeListener(_onResult);
    widget.viewModel.sendRecoveryEmail.addListener(_onResult);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.sendRecoveryEmail.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.sendRecoveryEmail.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.viewModel.sendRecoveryEmail.responseData as String,
          ),
        ),
      );
      widget.viewModel.sendRecoveryEmail.clearResult();
    }

    if (widget.viewModel.sendRecoveryEmail.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.sendRecoveryEmail.errorMessage!),
        ),
      );
      widget.viewModel.sendRecoveryEmail.clearResult();
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
              _recoveryTitle(),
              Expanded(child: Center(child: _recoveryForm())),
              _recoveryButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recoveryTitle() {
    return Text(
      AppLocalizations.of(context)!.recoverPasswordTitle,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget _recoveryForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          maxLength: 25,
          controller: _email,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.emailHint,
            counterText: "",
            border: OutlineInputBorder(),
            label: Text(AppLocalizations.of(context)!.emailLabel),
          ),
        ),
      ],
    );
  }

  Widget _recoveryButton() {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return FilledButton(
                onPressed: () {
                  if (_email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.sendRecoveryEmail.execute((_email.text,));
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.sendRecoveryLinkButton,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
