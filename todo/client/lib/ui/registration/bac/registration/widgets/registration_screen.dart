import 'package:todo/ui/registration/newuser/view_model/registration_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key, required this.viewModel});
  final RegistrationViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreen();
  }
}

class _RegistrationScreen extends State<RegistrationScreen> {
  final TextEditingController _email = TextEditingController(text: '');
  final TextEditingController _password = TextEditingController(text: '');
  final TextEditingController _confirmPassword = TextEditingController(
    text: '',
  );
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.registerUser.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant RegistrationScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.registerUser.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.registerUser.completed) {
      String res = widget.viewModel.registerUser.responseData as String;
      widget.viewModel.registerUser.clearResult();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    }

    if (widget.viewModel.registerUser.error) {
      String hasError =
          widget.viewModel.registerUser.errorMessage != null
              ? widget.viewModel.registerUser.errorMessage!
              : "";

      widget.viewModel.registerUser.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(hasError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppLocalizations.of(context)!.registrationPageHeader),
                    Text(AppLocalizations.of(context)!.registrationPageDesc),
                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.emailPlaceholder,
                        counterText: "",
                      ),
                      maxLength: 25,
                      controller: _email,
                    ),
                    TextField(
                      decoration: InputDecoration(
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
                        counterText: "",
                        hintText:
                            AppLocalizations.of(context)!.passwordPlaceholder,
                      ),
                      controller: _password,
                      maxLength: 25,
                      obscureText: _obscurePassword,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                      ),
                      controller: _confirmPassword,
                      maxLength: 25,
                      obscureText: _obscurePassword,
                    ),
                  ],
                ),
              ),
            ),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return FilledButton(
                  onPressed: () {
                    if (_confirmPassword.value.text == "" ||
                        _password.value.text == "" ||
                        _email.value.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.missingInformation,
                          ),
                        ),
                      );
                    } else if (_confirmPassword.value.text !=
                        _password.value.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.mismatchPasswords,
                          ),
                        ),
                      );
                    } else {
                      widget.viewModel.registerUser.execute((
                        _email.value.text,
                        _password.value.text,
                      ));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.verifyEmail),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
