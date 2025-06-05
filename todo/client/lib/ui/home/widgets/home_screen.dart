import 'package:todo/domain/models/todo/todo.dart';
import 'package:todo/l10n/app_localizations.dart';
import 'package:todo/ui/core/theme/dimens.dart';
import 'package:todo/ui/home/view_models/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});
  final HomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    widget.viewModel.getUserData.addListener(_userDataResult);
    widget.viewModel.getTodo.addListener(_getTodoResult);
    widget.viewModel.deleteTodo.addListener(_deleteTodoResult);
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.viewModel.getUserData.removeListener(_userDataResult);
    widget.viewModel.getUserData.addListener(_userDataResult);
    widget.viewModel.getTodo.removeListener(_getTodoResult);
    widget.viewModel.getTodo.addListener(_getTodoResult);
    widget.viewModel.deleteTodo.removeListener(_deleteTodoResult);
    widget.viewModel.deleteTodo.addListener(_deleteTodoResult);
  }

  @override
  void dispose() {
    super.dispose();
    widget.viewModel.getUserData.removeListener(_userDataResult);
    widget.viewModel.getTodo.removeListener(_getTodoResult);
    widget.viewModel.deleteTodo.removeListener(_deleteTodoResult);
  }

  void _userDataResult() {
    if (widget.viewModel.getUserData.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.getUserData.errorMessage!)),
      );
      widget.viewModel.getUserData.clearResult();
    }
  }

  void _getTodoResult() {
    if (widget.viewModel.getTodo.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.getTodo.errorMessage!)),
      );
      widget.viewModel.getTodo.clearResult();
    }
  }

  void _deleteTodoResult() {
    if (widget.viewModel.deleteTodo.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.todoDeleteText)),
      );
      widget.viewModel.deleteTodo.clearResult();
    }

    if (widget.viewModel.deleteTodo.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.deleteTodo.errorMessage!)),
      );
      widget.viewModel.deleteTodo.clearResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go("/home/create");
        },
        icon: Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.createTodoButton),
      ),

      appBar: AppBar(
        title: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, child) {
            return Text(AppLocalizations.of(context)!.appTitle);
          },
        ),

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.go("/home/settings");
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _calenderView(),
            ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: Dimens.of(context).paddingScreenHorizontal,
                    ),
                    child: LayoutBuilder(
                      builder: (
                        BuildContext context,
                        BoxConstraints viewportConstraints,
                      ) {
                        return RefreshIndicator(
                          onRefresh: () {
                            return widget.viewModel.getTodo.execute((
                              selectedDay.toString().split(" ")[0],
                              1,
                            ));
                          },
                          child:
                              widget.viewModel.todoData.isEmpty
                                  ? Center(child: Text("No todo's found."))
                                  : ListView.builder(
                                    itemCount: widget.viewModel.todoData.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              Dimens.of(
                                                context,
                                              ).paddingScreenVertical,
                                        ),
                                        child: _listItem(
                                          item:
                                              widget.viewModel.todoData[index],
                                        ),
                                      );
                                    },
                                  ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteDialog(
    BuildContext context,
    String date,
    String id,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.popUpConfirmationTitle),
          content: Text(AppLocalizations.of(context)!.popUpDeleteTodoDesc),

          actions: [
            TextButton(
              onPressed: () {
                widget.viewModel.deleteTodo.execute((date, id));

                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.popUpConfirm),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.popUpCancel),
            ),
          ],
        );
      },
    );
  }

  Widget _listItem({required TodoResponse item}) {
    return Slidable(
      key: ValueKey(item.title),
      startActionPane: ActionPane(
        motion: ScrollMotion(),
        children:
            item.isCompleted
                ? []
                : [
                  SlidableAction(
                    flex: 1,
                    onPressed: (e) {
                      widget.viewModel.completeTodo.execute((
                        selectedDay.toString().split(" ")[0],
                        item.id,
                      ));
                    },
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    foregroundColor: Theme.of(context).colorScheme.surface,
                    icon: Icons.check,
                  ),
                ],
      ),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (e) {
              context.go(
                "/home/update",
                extra: {
                  "date": selectedDay.toString().split(" ")[0],
                  "data": item,
                },
              );
            },
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            foregroundColor: Theme.of(context).colorScheme.surface,
            icon: Icons.edit,
          ),
          SlidableAction(
            flex: 1,
            onPressed: (e) {
              _deleteDialog(
                context,
                selectedDay.toString().split(" ")[0],
                item.id,
              );
            },
            backgroundColor: Theme.of(context).colorScheme.onSurface,
            foregroundColor: Theme.of(context).colorScheme.surface,
            icon: Icons.delete,
          ),
        ],
      ),

      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(1.0),
          side: BorderSide(
            color:
                item.deadline.isBefore(DateTime.now()) && !item.isCompleted
                    ? Colors.red
                    : item.isCompleted
                    ? Colors.green
                    : Theme.of(context).colorScheme.onSurface,
            width: 1.0,
          ),
        ),
        child: ListTile(title: Text(item.title), subtitle: Text(item.body)),
      ),
    );
  }

  CalendarFormat calendarFormat = CalendarFormat.week;
  DateTime focusedDay = DateTime.now();
  late DateTime? selectedDay = focusedDay;

  Widget _calenderView() {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        return TableCalendar(
          headerVisible: false,
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: focusedDay,
          calendarFormat: calendarFormat,
          daysOfWeekHeight: 25,
          rangeSelectionMode: RangeSelectionMode.toggledOff,
          selectedDayPredicate: (day) {
            return isSameDay(selectedDay, day);
          },
          onDaySelected: (sDay, fDay) {
            if (!isSameDay(selectedDay, sDay)) {
              setState(() {
                selectedDay = sDay;
                focusedDay = fDay;
              });

              widget.viewModel.getTodo.execute((
                selectedDay.toString().split(" ")[0],
                1,
              ));
            }
          },
          onPageChanged: (fDay) {
            focusedDay = fDay;
          },
        );
      },
    );
  }
}
