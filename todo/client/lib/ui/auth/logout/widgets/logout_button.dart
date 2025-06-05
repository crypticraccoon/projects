import 'package:flutter/material.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/auth/logout/view_models/logout_button_view_model.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key, required this.viewModel});

  final LogoutButtonViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _LogoutButton();
  }
}

class _LogoutButton extends State<LogoutButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant LogoutButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return FilledButton(
                onPressed: () {
                  widget.viewModel.logout.execute();
                },
                child: Text(AppLocalizations.of(context)!.logOutButton),
              );
            },
          ),
        ),
      ],
    );
  }
}
