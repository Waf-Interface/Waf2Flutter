import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/features/websites/components/data_column_tile.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/system/SystemController.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Menu_Controller menuController = Get.find<Menu_Controller>();
    final SystemController systemController = Get.find<SystemController>();
    final TextEditingController gatewayTextcontroller = TextEditingController();

    systemController.onInit();
    return PageBuilder(
      sectionWidgets: [
        Responsive(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              configGateway(systemController, gatewayTextcontroller),
              const SizedBox(width: 10, height: 10),
              routesSection(systemController),
            ],
          ),
          tablet: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: configGateway(systemController, gatewayTextcontroller)),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 3, child: routesSection(systemController)),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: configGateway(systemController, gatewayTextcontroller)),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 3, child: routesSection(systemController)),
            ],
          ),
        ),
      ],
    );
  }

  Widget configGateway(SystemController systemController, TextEditingController gatewayTextcontroller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.context!.theme.colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AutoSizeText(
            "Waf Actions",
            maxLines: 1,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const AutoSizeText(
                "IP Virtual:",
                maxLines: 1,
              ),
              const SizedBox(width: 10),
              Obx(() {
                final ipList = systemController.networkInterfaces
                    .map((iface) => "${iface['address']} - Available")
                    .toList();
                return CustomDropdownWidget(
                  list: ipList.isNotEmpty ? ipList : ["No IPs available"],
                  value: ipList.isNotEmpty ? ipList[0] : "No IPs available",
                  onchangeValue: (value) {},
                );
              }),
            ],
          ),
          const SizedBox(height: 15),
          const AutoSizeText(
            "Gateway",
            maxLines: 1,
          ),
          const SizedBox(height: 10),
          DashboardTextfield(
            textEditingController: gatewayTextcontroller,
            maxLength: 16,
            hintText: "192.168.1.1",
            inputType: TextInputType.number,
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const AutoSizeText(
                "Interface:",
                maxLines: 1,
              ),
              const SizedBox(width: 10),
              Obx(() {
                final interfaceList = systemController.networkInterfaces
                    .map((iface) => iface['name'].toString())
                    .toList();
                return CustomDropdownWidget(
                  list: interfaceList.isNotEmpty ? interfaceList : ["No interfaces"],
                  value: interfaceList.isNotEmpty ? interfaceList[0] : "No interfaces",
                  onchangeValue: (value) {},
                );
              }),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 30,
            width: 100,
            child: Obx(() => CustomIconbuttonWidget(
              backColor: primaryColor,
              onPressed: () {
                if (!systemController.isLoading.value) {
                  systemController.createGateway(gatewayTextcontroller.text);
                }
              },
              title: systemController.isLoading.value ? "Adding..." : "Add",
            )),
          ),
        ],
      ),
    );
  }

  Widget routesSection(SystemController systemController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.context!.theme.colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AutoSizeText(
                "Routes",
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Obx(() => systemController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : DataTable(
                columnSpacing: 30,
                border: TableBorder.all(
                  color: Colors.white,
                  width: 0.07,
                ),
                columns: [
                  DataColumnTile.buildRow(title: 'Destination'),
                  DataColumnTile.buildRow(title: 'Gateway'),
                  DataColumnTile.buildRow(title: 'Genmask'),
                  DataColumnTile.buildRow(title: 'iface'),
                ],
                rows: systemController.networkRoutes.map((route) {
                  return DataRow(
                    cells: [
                      DataCell(Text(route['destination'] ?? 'N/A')),
                      DataCell(Text(route['gateway'] ?? 'N/A')),
                      DataCell(Text(route['genmask'] ?? 'N/A')),
                      DataCell(Text(route['iface'] ?? 'N/A')),
                    ],
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }
}