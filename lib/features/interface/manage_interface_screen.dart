import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/status_widget.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/Interface/InterfaceController.dart';

class ManageInterfaceScreen extends GetView<InterfaceController> {
  const ManageInterfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<InterfaceController>();

    final ScrollController scrollbarController = ScrollController();

    return PageBuilder(
      sectionWidgets: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Responsive(
            mobile: Scrollbar(
              controller: scrollbarController,
              child: SingleChildScrollView(
                controller: scrollbarController,
                scrollDirection: Axis.horizontal,
                child: ipTable(),
              ),
            ),
            tablet: Scrollbar(
              controller: scrollbarController,
              child: SingleChildScrollView(
                controller: scrollbarController,
                scrollDirection: Axis.horizontal,
                child: ipTable(),
              ),
            ),
            desktop: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [ipTable()],
            ),
          ),
        ),
      ],
    );
  }

  Widget ipTable() => Obx(() => DataTable(
    sortColumnIndex: controller.sortColumnIndex?.value,
    sortAscending: controller.isAscending.value,
    columns: [
      DataColumn(
        label: const Text("#"),
        onSort: (columnIndex, ascending) => controller.sortData(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text("IP"),
        onSort: (columnIndex, ascending) => controller.sortData(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text("Interface"),
        onSort: (columnIndex, ascending) => controller.sortData(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text("Used By"),
        onSort: (columnIndex, ascending) => controller.sortData(columnIndex, ascending),
      ),
      DataColumn(
        label: const Text("Status"),
        onSort: (columnIndex, ascending) => controller.sortData(columnIndex, ascending),
      ),
      const DataColumn(label: Text("Delete")),
    ],
    rows: controller.isLoading.value
        ? [const DataRow(cells: [DataCell(CircularProgressIndicator())])]
        : controller.interfaces.map((row) {
      return DataRow(cells: [
        dataCellMaker(row["#"].toString()),
        dataCellMaker(row["ip"]),
        dataCellMaker(row["interface"]),
        dataCellMaker(row["usedby"]),
        DataCell(StatusWidget(
          title: row["status"],
          backgrounColor: primaryColor,
          titleColor: Colors.white,
        )),
        DataCell(
          SizedBox(
            width: 70,
            child: CustomIconbuttonWidget(
              backColor: Colors.red,
              onPressed: () => controller.deleteInterface(row["#"]),
              icon: Icons.delete,
            ),
          ),
        ),
      ]);
    }).toList(),
  ));

  DataCell dataCellMaker(dynamic title) => DataCell(SizedBox(
    width: 110,
    child: Text(
      title.toString(),
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
  ));
}