import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/log/NginxLogController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/waf/WafController.dart';
import 'package:msf/features/dashboard/component/CircleChar.dart';

class StatusSection extends StatelessWidget {
  StatusSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wafController = Get.find<WafLogController>();
    final NginxLogController controller = Get.find<NginxLogController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;

      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10) // مشابه LoginScreen
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: isCinematic
                ? BoxDecoration(
              color: ColorConfig.glassColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.01)
                    : Colors.black.withOpacity(0.0),
              ),
            )
                : BoxDecoration(
              color: ColorConfig.secondryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  "Status".tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() {
                  bool isOn = wafController.modStatus.value;
                  return CircleChart(
                    circleColor: isOn ? Colors.greenAccent : Colors.redAccent,
                    mainText: isOn ? "Safe" : "Unsafe",
                    subText: isOn ? "WAF is ON!" : "WAF is OFF!",
                  );
                }),
                const SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                          width: 2,
                          color: ColorConfig.primaryColor.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )
                          : BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: ColorConfig.primaryColor.withOpacity(0.15),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined,
                              color: Colors.blueAccent),
                          const SizedBox(width: 10),
                          AutoSizeText(
                            "Visitors: ".tr,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          AutoSizeText(
                            controller.logSummary['total_requests']?.toString() ??
                                '',
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w100, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                          width: 2,
                          color: Colors.greenAccent.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )
                          : BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.greenAccent.withOpacity(0.15),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.wifi_protected_setup_rounded,
                              color: Colors.greenAccent),
                          const SizedBox(width: 10),
                          AutoSizeText(
                            "Last refresh: ".tr,
                            maxLines: 2,
                            style: const TextStyle(fontSize: 12),
                          ),
                          AutoSizeText(
                            wafController.lastRefresh.value,
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w100, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 30),
                Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                          width: 2,
                          color: Colors.yellowAccent.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )
                          : BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.yellowAccent.withOpacity(0.15),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.supervised_user_circle_outlined,
                              color: Colors.yellowAccent),
                          const SizedBox(width: 10),
                          AutoSizeText(
                            "Warnings: ".tr,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          AutoSizeText(
                            wafController.warningsCount.value.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w100, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 30),
                Obx(() => ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                          width: 2,
                          color: Colors.redAccent.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      )
                          : BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.redAccent.withOpacity(0.15),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: Colors.redAccent),
                          const SizedBox(width: 10),
                          AutoSizeText(
                            "Critical: ".tr,
                            maxLines: 1,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          AutoSizeText(
                            wafController.criticalCount.value.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                fontWeight: FontWeight.w100, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      );
    });
  }
}