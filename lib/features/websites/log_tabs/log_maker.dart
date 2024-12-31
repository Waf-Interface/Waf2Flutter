import 'package:flutter/material.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';

import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/websites/components/data_column_tile.dart';

class LogMaker extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> logs;
  const LogMaker({
    super.key,
    required this.title,
    required this.logs,
  });

  @override
  State<LogMaker> createState() => _LogMakerState();
}

class _LogMakerState extends State<LogMaker> {
  TextEditingController searchTextController = TextEditingController();

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  final List<int> entryOptions = [10, 20, 50, 100];
  int selectedEntries = 10;
  final int _currentPage = 1;

  int? _sortColumnIndex; // Tracks the sorted column index
  bool _isAscending = true; // Tracks sort order

  void _sortData(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;

      switch (columnIndex) {
        case 0: // Sort by #
          widget.logs.sort((a, b) =>
              ascending ? a["#"].compareTo(b["#"]) : b["#"].compareTo(a["#"]));
          break;
        case 1: // Sort by Log
          widget.logs.sort((a, b) => ascending
              ? a["Log"].compareTo(b["Log"])
              : b["Log"].compareTo(a["Log"]));
          break;
      }
    });
  }

  int get _startIndex => (_currentPage - 1) * selectedEntries;
  int get _endIndex => (_startIndex + selectedEntries > widget.logs.length)
      ? widget.logs.length
      : _startIndex + selectedEntries;
  @override
  Widget build(BuildContext context) {
    final displayedData = widget.logs.sublist(_startIndex, _endIndex);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title),
            CustomIconbuttonWidget(
              backColor: primaryColor,
              onPressed: () {},
              title: "Download Full Log",
              icon: Icons.download,
            )
          ],
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Existing Row for dropdown and search
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text("Show"),
                        SizedBox(width: 5),
                        Flexible(
                          child: DropdownButton<int>(
                            value: selectedEntries,
                            dropdownColor: Colors.grey[800],
                            items: entryOptions.map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  value.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            onChanged: (newVal) {
                              setState(() {
                                if (newVal != null) selectedEntries = newVal;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 5),
                        Flexible(child: Text("entries")),
                      ],
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text("Search"),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 150,
                        child: DashboardTextfield(
                          textEditingController: searchTextController,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Sortable DataTable
              DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _isAscending,
                columns: [
                  DataColumn(
                    label: const Text("#"),
                    numeric: true,
                    onSort: (columnIndex, ascending) {
                      _sortData(columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Text("Log"),
                    onSort: (columnIndex, ascending) {
                      _sortData(columnIndex, ascending);
                    },
                  ),
                ],
                rows: widget.logs.map((row) {
                  return DataRow(cells: [
                    DataCell(Text(row["#"].toString())),
                    DataCell(Text(row["Log"])),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
        // Footer
        Text(
          "Showing ${displayedData.isNotEmpty ? _startIndex + 1 : 0} to $_endIndex of ${widget.logs.length} entries",
        ),
      ],
    );
  }
}