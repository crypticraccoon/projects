import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/auth/login/view_model/login_viewmodel.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen();
  }
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController(text: '');
  final TextEditingController _password = TextEditingController(text: '');
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.login.removeListener(_onResult);
    widget.viewModel.login.addListener(_onResult);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.login.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.login.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.login.errorMessage!)),
      );
      widget.viewModel.login.clearResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Dimens.of(context).edgeInsetsScreenSymmetric,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(
                  top: Dimens.of(context).paddingScreenVertical,
                ),
                child: _loginTitle(),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _loginForm(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: Dimens.of(context).paddingScreenVertical,
                          ),
                          child: _recoverButton(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _loginButton(),
              Padding(
                padding: EdgeInsetsGeometry.only(
                  top: Dimens.of(context).paddingScreenVertical,
                ),
                child: _registerButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginTitle() {
    return Text(
      AppLocalizations.of(context)!.loginTitle,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget _loginForm() {
    return Column(
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
      ],
    );
  }

  Widget _loginButton() {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  if (_email.value.text == "" || _password.value.text == "") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.login.execute((
                      _email.value.text,
                      _password.value.text,
                    ));
                  }
                },
                child: Text(AppLocalizations.of(context)!.loginButton),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _recoverButton() {
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
        ),

        text: AppLocalizations.of(context)!.forgotPasswordText,
        recognizer:
            TapGestureRecognizer()
              ..onTap = () {
                context.go("/recover");
              },
      ),
    );
  }

  Widget _registerButton() {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
        ),
        children: <TextSpan>[
          TextSpan(text: "${AppLocalizations.of(context)!.registerText} "),
          TextSpan(
            text: AppLocalizations.of(context)!.registerHereButton,
            style: TextStyle(color: Theme.of(context).primaryColor),

            recognizer:
                TapGestureRecognizer()
                  ..onTap = () {
                    context.go("/register");
                  },
          ),
        ],
      ),
    );
  }
}
