import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';

class SetSecRule extends StatelessWidget {
  const SetSecRule({Key? key}) : super(key: key);

  Color getBorderColor(String mode) {
    switch (mode) {
      case "Off":
        return Colors.redAccent;
      case "DetectionOnly":
        return Colors.yellowAccent;
      case "On":
      default:
        return Colors.green;
    }
  }

  String getTooltipMessage(String mode) {
    switch (mode) {
      case "Off":
        return "Critical ! The dangerous requests cannot be blocked waf is off!".tr;
      case "DetectionOnly":
        return "Warning waf is only detect the Critical requests.".tr;
      case "On":
      default:
        return "Waf is blooking Critical Requests!".tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final WafSetupController controller = Get.find<WafSetupController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final RxString selectedValue = 'On'.obs;

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            width: double.infinity,
            height: 140,
            padding: const EdgeInsets.all(16),
            decoration: isCinematic
                ? BoxDecoration(
              color: ColorConfig.glassColor,
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.01)
                    : Colors.black.withOpacity(0.0),
              ),
              borderRadius: BorderRadius.circular(10),
            )
                : BoxDecoration(
              color: ColorConfig.secondryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Change Waf Mode".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => DropdownButton<String>(
                        value: selectedValue.value,
                        dropdownColor: ColorConfig.secondryColor,
                        style: const TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white,
                        items: <String>['On'.tr, 'Off'.tr, 'DetectionOnly'.tr]
                            .map((String mode) {
                          return DropdownMenuItem<String>(
                            value: mode,
                            child: Text(mode),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          if (newValue != null) {
                            selectedValue.value = newValue;
                          }
                        },
                      )),
                    ),
                    Expanded(
                      child: Center(
                        child: Obx(
                              () => Tooltip(
                            message: getTooltipMessage(selectedValue.value),
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: getBorderColor(selectedValue.value),
                                  width: 10,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        bool success = await controller
                            .setSecRuleEngine(selectedValue.value);
                        if (success) {
                          Get.snackbar(
                            'Success'.tr,
                            'SecRuleEngine set to ${selectedValue.value} successfully'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } else {
                          Get.snackbar(
                            'Error'.tr,
                            'Failed to set SecRuleEngine'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      },
                      child:  Text(
                        "Change".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}