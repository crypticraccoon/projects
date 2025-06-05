import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/home/view_models/create_todo_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateTodoScreen extends StatefulWidget {
  const CreateTodoScreen({super.key, required this.viewModel});
  final CreateTodoViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _CreateTodoScreen();
  }
}

class _CreateTodoScreen extends State<CreateTodoScreen> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.createTodo.addListener(_result);
  }

  @override
  void didUpdateWidget(covariant CreateTodoScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.createTodo.removeListener(_result);
    widget.viewModel.createTodo.addListener(_result);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.createTodo.removeListener(_result);
  }

  void _result() {
    if (widget.viewModel.createTodo.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.createTodoCompleted),
        ),
      );
      context.go("/home");
    }

    if (widget.viewModel.createTodo.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.createTodo.errorMessage!)),
      );
      widget.viewModel.createTodo.clearResult();
    }
  }

  final TextEditingController _todoTitle = TextEditingController(text: '');
  final TextEditingController _todoBody = TextEditingController(text: '');
  final TextEditingController _todoDeadline = TextEditingController(text: '');
  DateTime? _selectedDateTime;

  void _updateTextField() {
    if (_selectedDateTime != null) {
      _todoDeadline.text = _selectedDateTime!.toUtc().toIso8601String();
    } else {
      _todoDeadline.text = '';
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
      helpText: 'Select Date',

      builder: (_, child) {
        return child!;
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            _selectedDateTime != null
                ? TimeOfDay.fromDateTime(_selectedDateTime!)
                : TimeOfDay.now(),
        helpText: 'Select Time',
        builder: (_, child) {
          return child!;
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _updateTextField();
        });
      }
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
              _title(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [_form()],
                  ),
                ),
              ),
              _button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      AppLocalizations.of(context)!.createTodoTitle,
      style: Theme.of(context).textTheme.displayMedium,
    );
  }

  Widget _form() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: Dimens.of(context).paddingScreenVertical,
          ),
          child: TextField(
            decoration: InputDecoration(hintText: "Title", counterText: ""),
            maxLength: 25,
            controller: _todoTitle,
          ),
        ),

        TextField(
          decoration: InputDecoration(hintText: "Body", counterText: ""),
          maxLength: 25,
          controller: _todoBody,
        ),

        Padding(
          padding: EdgeInsetsGeometry.symmetric(
            vertical: Dimens.of(context).paddingScreenVertical,
          ),
          child: TextField(
            controller: _todoDeadline,
            readOnly: true,
            onTap: () => _selectDateTime(context),
            decoration: const InputDecoration(hintText: 'Select Deadline'),
          ),
        ),
      ],
    );
  }

  Widget _button() {
    return Row(
      children: [
        Expanded(
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return FilledButton(
                onPressed: () {
                  widget.viewModel.createTodo.execute((
                    _todoTitle.value.text,
                    _todoBody.value.text,
                    _todoDeadline.value.text,
                  ));
                },
                child: Text(AppLocalizations.of(context)!.createTodoButton),
              );
            },
          ),
        ),
      ],
    );
  }
}
