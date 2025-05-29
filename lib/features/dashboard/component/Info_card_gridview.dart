import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/dashboard/ResourceUsageController.dart';
import 'package:msf/features/dashboard/component/infocard.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class InfoCardGridView extends StatelessWidget {
  final int crossAxisCount;
  final double childAspectRatio;

  InfoCardGridView({
    super.key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.2,
  });

  final ResourceUsageController dataController =
  Get.put(ResourceUsageController());

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;

    double cardWidth =
        (size.width - (crossAxisCount - 1) * 16) / crossAxisCount;
    double cardHeight = cardWidth / childAspectRatio;

    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: childAspectRatio,
      ),
      children: [
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: isCinematic
                    ? ImageFilter.blur(sigmaX: 10, sigmaY: 10) // مشابه LoginScreen
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
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
                  child: InfoCards(
                    icon: OctIcons.cpu_24,
                    title: "CPU Usage".tr,
                    color: Theme.of(context).colorScheme.primary,
                    numOfFiles: dataController.resourceUsage.value.cpuFiles ?? 0,
                    percentage: dataController.resourceUsage.value.cpuUsage ?? 0,
                    totalStorage:
                    "${dataController.resourceUsage.value.cpuUsage ?? 0}%",
                  ),
                ),
              ),
            ),
          );
        }),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: isCinematic
                    ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
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
                  child: InfoCards(
                    icon: OctIcons.cloud_24,
                    title: "Cloud Usage".tr,
                    color: Theme.of(context).colorScheme.secondary,
                    numOfFiles: dataController.resourceUsage.value.cloudFiles ?? 0,
                    percentage: dataController.resourceUsage.value.cloudUsage ?? 0,
                    totalStorage:
                    dataController.resourceUsage.value.cloudStorage ?? "0 MB",
                  ),
                ),
              ),
            ),
          );
        }),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: isCinematic
                    ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
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
                  child: InfoCards(
                    icon: Icons.memory_rounded,
                    title: "Memory Usage".tr,
                    color: Theme.of(context).colorScheme.tertiary,
                    numOfFiles: dataController.resourceUsage.value.memoryFiles ?? 0,
                    percentage: dataController.resourceUsage.value.memoryUsage ?? 0,
                    totalStorage:
                    dataController.resourceUsage.value.memoryStorage ?? "0 GB",
                  ),
                ),
              ),
            ),
          );
        }),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: isCinematic
                    ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
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
                  child: InfoCards(
                    icon: Icons.traffic_outlined,
                    title: "Traffic Usage".tr,
                    color: Theme.of(context).colorScheme.surface,
                    numOfFiles:
                    dataController.resourceUsage.value.trafficFiles ?? 0,
                    percentage:
                    dataController.resourceUsage.value.trafficUsage ?? 0,
                    totalStorage:
                    dataController.resourceUsage.value.trafficStorage ?? "0 GB",
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}