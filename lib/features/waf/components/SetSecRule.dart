import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/colorconfig.dart';
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
        return "Critical ! The dangerous requests cannot be blocked waf is off!";
      case "DetectionOnly":
        return "Warning waf is only detect the Critical requests.";
      case "On":
      default:
        return "Waf is blooking Critical Requests!";
    }
  }

  @override
  Widget build(BuildContext context) {
    final WafSetupController controller = Get.find<WafSetupController>();
    final RxString selectedValue = 'On'.obs;

    return Container(
      width: double.infinity,
      height: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: secondryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Change Waf Mode",
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
                      dropdownColor: secondryColor,
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.white,
                      items: <String>['On', 'Off', 'DetectionOnly']
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
                        // Inner cut-out (empty center)
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
                  bool success =
                      await controller.setSecRuleEngine(selectedValue.value);
                  if (success) {
                    Get.snackbar(
                      'Success',
                      'SecRuleEngine set to ${selectedValue.value} successfully',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Failed to set SecRuleEngine',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text("Change",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
