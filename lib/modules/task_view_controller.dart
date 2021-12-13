import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/task.dart';

class TaskViewController extends StatefulWidget {
  final List<Task> tasks;

  const TaskViewController({Key? key, required this.tasks}) : super(key: key);

  @override
  _TaskViewControllerState createState() => _TaskViewControllerState();
}

class _TaskViewControllerState extends State<TaskViewController> {
  int _currentSortColumn = 1;
  bool _isAscending = true;

  late List<Task> _filteredTasks;

  @override
  void initState() {
    _filteredTasks = widget.tasks;
    _filteredTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
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
          rows: _filteredTasks.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.name)),
              DataCell(Text(item.dateTime.toIso8601String()))
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