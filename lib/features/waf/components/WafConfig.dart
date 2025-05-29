import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';
import 'package:msf/features/waf/components/EditConfigScreen.dart';

class WafConfigWidget extends StatelessWidget {
  final WafSetupController controller = Get.find<WafSetupController>();

  WafConfigWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    HttpService httpService = HttpService();
    controller.setHttpService(httpService);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: themeController.isCinematic.value
            ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: themeController.isCinematic.value
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
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Configuration Files".tr,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(
                              screenWidth < 600 ? 100 : 120,
                              36,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onPressed: () {
                            Get.to(() => EditConfigScreen(fileKey: "modsecurity"));
                          },
                          child:  Text(
                            "ModSecurity".tr,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(
                              screenWidth < 600 ? 100 : 120,
                              36,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onPressed: () {
                            Get.to(() => EditConfigScreen(fileKey: "crs_setup"));
                          },
                          child:  Text(
                            "CRS Setup".tr,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(
                              screenWidth < 600 ? 100 : 120,
                              36,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          onPressed: () {
                            Get.to(() => EditConfigScreen(fileKey: "nginx"));
                          },
                          child:  Text(
                            "Nginx".tr,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}