import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/settings/email/view_models/update_email_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateEmailScreen extends StatefulWidget {
  const UpdateEmailScreen({super.key, required this.viewModel});

  final UpdateEmailViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateEmailScreen();
  }
}

class _UpdateEmailScreen extends State<UpdateEmailScreen> {
  final TextEditingController _email = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateEmail.addListener(_result);
  }

  @override
  void didUpdateWidget(covariant UpdateEmailScreen oldWidget) {
    widget.viewModel.updateEmail.removeListener(_result);
    widget.viewModel.updateEmail.addListener(_result);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updateEmail.removeListener(_result);
  }

  void _result() {
    if (widget.viewModel.updateEmail.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.emailUpdatedText)),
      );
      widget.viewModel.updateEmail.clearResult();
      context.go("/home/settings");
    }

    if (widget.viewModel.updateEmail.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.updateEmail.errorMessage!)),
      );
      widget.viewModel.updateEmail.clearResult();
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
      AppLocalizations.of(context)!.updateEmailTitle,
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
          maxLength: 25,
          controller: _email,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.emailLabel),
            hintText: AppLocalizations.of(context)!.emailHint,
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
                  if (_email.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.updateEmail.execute((_email.text,));
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
