import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/connection/iconnection.dart';
import 'package:smart_mirror/core/model/task.dart';
import 'package:smart_mirror/modules/task/task_view.dart';

class TasksViewController extends StatefulWidget {
  final List<IConnection> connections;
  final List<Task> tasks;

  final IConnection? startingSelection;

  const TasksViewController({
    Key? key, required this.connections, required this.tasks,
    this.startingSelection
  }) : super(key: key);

  @override
  _TasksViewControllerState createState() => _TasksViewControllerState();
}

class _TasksViewControllerState extends State<TasksViewController> {
  int _currentSortColumn = 1;
  bool _isAscending = true;

  int? _selectedConnection;

  late List<Task> _filteredTasks;

  @override
  void initState() {
    if (widget.startingSelection != null) {
      var idx = widget.connections.indexOf(widget.startingSelection!);
      if (idx != -1) _selectedConnection = idx;
    }
    _filteredTasks = widget.tasks;
    _filteredTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    super.initState();
  }

  List<ChoiceChip> getConnectionChips() {
    return List<ChoiceChip>.generate(
        widget.connections.length, (int index) {
      var connection = widget.connections[index];
      return ChoiceChip(
        label: Text(connection.name),
        selected: _selectedConnection == index,
        onSelected: (bool selected) {
          setState(() {
            if (selected){
              _selectedConnection = index;
              _filteredTasks = widget.tasks.where((task) => task.connection == connection).toList();
            } else {
              _selectedConnection = null;
              _filteredTasks = widget.tasks;
            }
          });
        },
      );
    }).toList();
  }

  void _showTaskView(Task task) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return Container(
                    height: height - 400,
                    width: width - 400,
                    child: TaskView(task: task),
                  );
                }),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ]
        )
    );
  }

  Widget getTable(BuildContext context) {
    return Expanded(child: SingleChildScrollView(
      child: DataTable(
        sortColumnIndex: _currentSortColumn,
        sortAscending: _isAscending,
        columns: [
          DataColumn(label: Text('Name'),
              onSort: (columnIndex, _) => setState(() {
                _isAscending = !_isAscending;
                _currentSortColumn = columnIndex;
                _filteredTasks.sort((a, b) => (_isAscending ? 1 : -1)
                    * a.name.compareTo(b.name));
              })),
          DataColumn(label: Text('Date'),
              onSort: (columnIndex, _) => setState(() {
                _isAscending = !_isAscending;
                _currentSortColumn = columnIndex;
                _filteredTasks.sort((a, b) => (_isAscending ? 1 : -1)
                    * a.dateTime.compareTo(b.dateTime));
              }))
        ],
        rows: _filteredTasks.map((task) {
          return DataRow(cells: [
            DataCell(InkWell(child: Text(task.name)), onTap: () => _showTaskView(task) ),
            DataCell(Text(task.dateTime.toIso8601String()))
          ]);
        }).toList(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Task View')),
        body: Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 20),
            child: Column(children: [
              Wrap(children: getConnectionChips()),
              getTable(context),
            ]
            )
        )
    );
  }
}