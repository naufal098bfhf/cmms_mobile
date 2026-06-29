import 'package:flutter/material.dart';

class TaskTable extends StatelessWidget {
  const TaskTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Mesin')),
          DataColumn(label: Text('Maintenance')),
          DataColumn(label: Text('Status')),
        ],
        rows: const [
          DataRow(cells: [
            DataCell(Text('Muhammad Ali')),
            DataCell(Text('Onderdil')),
            DataCell(Text('Darurat')),
            DataCell(Text('Menunggu')),
          ]),
        ],
      ),
    );
  }
}
