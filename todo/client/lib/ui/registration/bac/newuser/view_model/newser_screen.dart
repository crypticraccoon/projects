import 'package:todo/ui/registration/newuser/widgets/newuser_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/l10n/app_localizations.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({
    super.key,
    required this.id,
    required this.code,
    required this.viewModel,
  });

  final String id;
  final String code;
  final NewUserViewmodel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _NewUserScreen();
  }
}

class _NewUserScreen extends State<NewUserScreen> {
  final TextEditingController _username = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    widget.viewModel.registerUserData.addListener(_onResult);
  }

  @override
  void didUpdateWidget(covariant NewUserScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.registerUserData.removeListener(_onResult);
  }

  void _onResult() {
    if (widget.viewModel.registerUserData.completed) {
      String res = widget.viewModel.registerUserData.responseData as String;
      widget.viewModel.registerUserData.clearResult();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("$res. User created.")));
      context.go("/");
    }

    if (widget.viewModel.registerUserData.error) {
      String hasError =
          widget.viewModel.registerUserData.errorMessage != null
              ? widget.viewModel.registerUserData.errorMessage!
              : "";

      widget.viewModel.registerUserData.clearResult();
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
                    Text(AppLocalizations.of(context)!.registerUserPageHeader),
                    Text(AppLocalizations.of(context)!.registerUserPageDesc),

                    TextField(
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.usernamePlaceholder,
                        counterText: "",
                      ),
                      maxLength: 25,
                      controller: _username,
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
                    if (_username.value.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.missingInformation,
                          ),
                        ),
                      );
                    } else {
                      widget.viewModel.registerUserData.execute((
                        _username.value.text,
                        widget.id,
                        widget.code,
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

  //@override
  //Widget build(BuildContext context) {
    //return Scaffold(
      //body: SafeArea(
        //child: Column(
          //children: [
            //Expanded(
              //child: Center(
                //child: Column(mainAxisSize: MainAxisSize.min, children: []),
              //),
            //),
          //],
        //),
      //),
    //);
  //}
