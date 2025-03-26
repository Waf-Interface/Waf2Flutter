import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/controllers/waf/WafController.dart';

class RulePlace extends StatelessWidget {
  const RulePlace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WafLogController controller = Get.find<WafLogController>();

    return Obx(() {
      Map<String, int> ruleCounts = controller.getRuleTriggerCounts();

      if (ruleCounts.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: secondryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "No triggered rules found.",
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      int totalTriggered =
      ruleCounts.values.fold(0, (prev, element) => prev + element);

      List<MapEntry<String, int>> sortedEntries = ruleCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: secondryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: sortedEntries.asMap().entries.map((entry) {
            int index = entry.key;
            MapEntry<String, int> ruleEntry = entry.value;
            double percent = (ruleEntry.value / totalTriggered) * 100;
            double barFillPercent = 100 - percent;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "The #${index + 1} most triggered rule: ${ruleEntry.key}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 5),
                LayoutBuilder(
                  builder: (context, constraints) {
                    double fullWidth = constraints.maxWidth;
                    double fillWidth = fullWidth * (barFillPercent / 100);
                    return Stack(
                      children: [
                        Container(
                          width: fullWidth,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Container(
                          width: fillWidth,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              "${percent.toStringAsFixed(1)}%",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}
