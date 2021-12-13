import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/task.dart';
import 'package:smart_mirror/modules/task/task_view.dart';

class TasksViewController extends StatefulWidget {
  final List<Task> tasks;

  const TasksViewController({Key? key, required this.tasks}) : super(key: key);

  @override
  _TasksViewControllerState createState() => _TasksViewControllerState();
}

class _TasksViewControllerState extends State<TasksViewController> {
  int _currentSortColumn = 1;
  bool _isAscending = true;

  late List<Task> _filteredTasks;

  @override
  void initState() {
    _filteredTasks = widget.tasks;
    _filteredTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    super.initState();
  }
  
  void _showTaskView(Task task) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: TaskView(task: task),
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
    return Container(
      width: double.infinity,
      child: SingleChildScrollView(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Task View')),
        body: getTable(context)
    );
  }
}