import 'dart:ui'; // برای BackdropFilter
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_dropdown.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/Interface/InterfaceController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class AddInterfaceScreen extends GetView<InterfaceController> {
  const AddInterfaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final ScrollController scrollbarController = ScrollController();
    final TextEditingController ipAddressTextcontroller = TextEditingController();
    final TextEditingController netmaskTextcontroller = TextEditingController(text: "255.255.255.0");

    RxString selectedInterface = "ens33".obs;

    return PageBuilder(
      sectionWidgets: [
        Responsive(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              createInterfaces(ipAddressTextcontroller, netmaskTextcontroller, selectedInterface),
              const SizedBox(width: 10, height: 10),
              addedInterfaces(),
            ],
          ),
          tablet: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: createInterfaces(ipAddressTextcontroller, netmaskTextcontroller, selectedInterface)),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 3, child: addedInterfaces()),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: createInterfaces(ipAddressTextcontroller, netmaskTextcontroller, selectedInterface)),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 3, child: addedInterfaces()),
            ],
          ),
        ),
      ],
    );
  }

  Widget createInterfaces(
      TextEditingController ipController, TextEditingController netmaskController, RxString selectedInterface) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Get.theme.brightness == Brightness.dark;
    final List<String> interfaces = ["ens33"]; // Could fetch dynamically if needed

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: isCinematic
                ? BoxDecoration(
              color: ColorConfig.glassColor,
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
              ),
              borderRadius: BorderRadius.circular(10),
            )
                : BoxDecoration(
              color: Get.theme.colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AutoSizeText("IP Address", maxLines: 1),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: ipController,
                  maxLength: 16,
                  hintText: "192.168.1.1",
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                const AutoSizeText("Netmask", maxLines: 1),
                const SizedBox(height: 10),
                DashboardTextfield(
                  textEditingController: netmaskController,
                  maxLength: 16,
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const AutoSizeText("Interface:", maxLines: 1),
                    const SizedBox(width: 10),
                    Obx(() => CustomDropdownWidget(
                      list: interfaces,
                      value: selectedInterface.value,
                      onchangeValue: (value) => selectedInterface.value = value!,
                    )),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 30,
                  width: 100,
                  child: CustomIconbuttonWidget(
                    backColor: ColorConfig.primaryColor,
                    onPressed: () async {
                      await controller.addInterface(
                        ipAddress: ipController.text,
                        netmask: netmaskController.text,
                        interface: selectedInterface.value,
                      );
                      ipController.clear(); // Clear input after adding
                    },
                    title: "Save",
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget addedInterfaces() {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Get.theme.brightness == Brightness.dark;

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: isCinematic
                ? BoxDecoration(
              color: ColorConfig.glassColor,
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
              ),
              borderRadius: BorderRadius.circular(10),
            )
                : BoxDecoration(
              color: Get.theme.colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AutoSizeText("Interfaces Added", maxLines: 1),
                    const SizedBox(height: 10),
                    Obx(() => Column(
                      children: controller.interfaces
                          .map((interface) =>
                          addedInterfaceMaker("${interface['ip']} (${interface['interface']})"))
                          .toList(),
                    )),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget addedInterfaceMaker(String text) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('•'),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          textAlign: TextAlign.justify,
          text,
        ),
      ),
    ],
  );
}