import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/registration/registration/view_models/registration_view_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.viewModel});

  final RegistrationViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreen();
  }
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final TextEditingController _email = TextEditingController(text: "");
  final TextEditingController _password = TextEditingController(text: "");
  final TextEditingController _confirmPassword = TextEditingController(
    text: "",
  );
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.register.addListener(_result);
  }

  @override
  void didUpdateWidget(covariant RegistrationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.register.removeListener(_result);
    widget.viewModel.register.addListener(_result);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.register.removeListener(_result);
  }

  void _result() {
    if (widget.viewModel.register.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.register.responseData as String),
        ),
      );
      widget.viewModel.register.clearResult();
    }
    if (widget.viewModel.register.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.register.errorMessage!)),
      );
      widget.viewModel.register.clearResult();
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
              _registrationTitle(),
              Expanded(child: Center(child: _registrationForm())),
              _registrationButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registrationTitle() {
    return Text(
      "Registration",
      style: TextStyle(
        fontSize: Theme.of(context).textTheme.displayMedium!.fontSize,
      ),
    );
  }

  Widget _registrationForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: Dimens.of(context).edgeInsetsScreenVertical,
          child: TextField(
            maxLength: 25,
            controller: _email,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.emailHint,
              counterText: "",
              border: OutlineInputBorder(),
              label: Text(AppLocalizations.of(context)!.emailLabel),
            ),
          ),
        ),
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

  Widget _registrationButton() {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return FilledButton(
                onPressed: () {
                  if (_email.text.isEmpty ||
                      _password.text.isEmpty ||
                      _confirmPassword.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else if (_password.text != _confirmPassword.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.mismatchPasswordsError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.register.execute((
                      _email.text,
                      _password.text,
                    ));
                  }

                  return;
                },
                child: Text(AppLocalizations.of(context)!.registerButton),
              );
            },
          ),
        ),
      ],
    );
  }
}
