import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class Header extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Menu_Controller menuController = Get.find<Menu_Controller>();

  Header({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            onPressed: () {
              menuController.openDrawer(scaffoldKey);
            },
            icon: const Icon(Icons.menu_sharp),
          ),
        if (!Responsive.isMobile(context))
          AutoSizeText(
            "Docs".tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 1 : 2),
        const Spacer(),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return GestureDetector(
            onTap: () {
              Get.toNamed("/home");
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: isCinematic
                    ? ImageFilter.blur(sigmaX: 10, sigmaY: 10) // مشابه LoginScreen
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  width: 100,
                  height: 40,
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
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back_ios_sharp),
                        const SizedBox(width: 6),
                        Text("Back".tr),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 10),
      ],
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: ColorConfig.secondryColor,
        title: Text(
          "Logout".tr,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to logout?".tr,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel".tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.to(AppRouter.loginRoute);
            },
            child: Text("Confirm".tr),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}