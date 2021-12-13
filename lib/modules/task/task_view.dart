import 'package:flutter/material.dart';
import 'package:smart_mirror/core/model/task.dart';

class TaskView extends StatelessWidget {
  final Task task;

  TaskView({Key? key, required this.task}) : super(key: key);

  TableRow getRow(String header, String value) {
    return TableRow(children: [
      TableCell(child: Text(header)),
      TableCell(child: Text(value))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    var borderSide = BorderSide(color: Theme.of(context).primaryColor);
    return Table(
        border: TableBorder(
            horizontalInside: borderSide,
            verticalInside: borderSide
        ),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(64),
          1: FlexColumnWidth(),
        },
        children: <TableRow>[
          getRow('name', task.name),
          getRow('date', task.dateTime.toIso8601String()),
          if(task.endDateTime != null)
            getRow('end', task.endDateTime!.toIso8601String())
        ]
    );
  }
}