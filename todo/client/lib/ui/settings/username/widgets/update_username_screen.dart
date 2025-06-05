import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/settings/username/view_models/update_username_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UpdateUsernameScreen extends StatefulWidget {
  const UpdateUsernameScreen({super.key, required this.viewModel});

  final UpdateUsernameViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _UpdateUsernameScreen();
  }
}

class _UpdateUsernameScreen extends State<UpdateUsernameScreen> {
  final TextEditingController _username = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.updateUsername.addListener(_result);
  }

  @override
  void didUpdateWidget(covariant UpdateUsernameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.updateUsername.removeListener(_result);
    widget.viewModel.updateUsername.addListener(_result);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.updateUsername.removeListener(_result);
  }

  void _result() {
    if (widget.viewModel.updateUsername.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.settingsUpdateUsername),
        ),
      );
      widget.viewModel.updateUsername.clearResult();
      context.go("/home/settings");
    }

    if (widget.viewModel.updateUsername.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.updateUsername.errorMessage!)),
      );
      widget.viewModel.updateUsername.clearResult();
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
      AppLocalizations.of(context)!.updateUsernameTitle,
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
          controller: _username,
          decoration: InputDecoration(
            label: Text(AppLocalizations.of(context)!.usernameLabel),
            hintText: AppLocalizations.of(context)!.usernameHint,
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
                  if (_username.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.missingInformationError,
                        ),
                      ),
                    );
                  } else {
                    widget.viewModel.updateUsername.execute((_username.text,));
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
