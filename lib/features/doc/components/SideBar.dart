import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';
import 'package:get/get.dart';
import 'package:msf/features/doc/doc.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final DocScreen? docScreen = context.findAncestorWidgetOfExactType<DocScreen>();
    final isRtl = Get.find<TranslateController>().isEnglish.value
        ? TextDirection.ltr
        : TextDirection.rtl;

    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      width: Responsive.isDesktop(context)
          ? MediaQuery.of(context).size.width * 0.2
          : null, // عرض سایدبار در دسکتاپ
      child: Directionality(
        textDirection: isRtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),
              Divider(color: Theme.of(context).dividerColor),
              ListTile(
                onTap: () {
                  if (docScreen != null) {
                    docScreen.selectedScreen.value = 0;
                  }
                  if (!Responsive.isDesktop(context)) {
                    Navigator.pop(context);
                  }
                },
                title: AutoSizeText(
                  "Introduce".tr,
                  maxLines: 1,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textDirection: isRtl,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              ListTile(
                onTap: () {
                  if (docScreen != null) {
                    docScreen.selectedScreen.value = 1;
                  }
                  if (!Responsive.isDesktop(context)) {
                    Navigator.pop(context);
                  }
                },
                title: AutoSizeText(
                  "Setup".tr,
                  maxLines: 1,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textDirection: isRtl,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              ListTile(
                onTap: () {
                  if (docScreen != null) {
                    docScreen.selectedScreen.value = 2;
                  }
                  if (!Responsive.isDesktop(context)) {
                    Navigator.pop(context);
                  }
                },
                title: AutoSizeText(
                  "Control Panel".tr,
                  maxLines: 1,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textDirection: isRtl,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              ListTile(
                onTap: () {
                  if (docScreen != null) {
                    docScreen.selectedScreen.value = 4;
                  }
                  if (!Responsive.isDesktop(context)) {
                    Navigator.pop(context);
                  }
                },
                title: AutoSizeText(
                  "Developer Final Thoughts".tr,
                  maxLines: 1,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textDirection: isRtl,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              const SizedBox(height: 400),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: isRtl,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AutoSizeText(
                        "Dark Mode".tr,
                        style: const TextStyle(color: Colors.white),
                        textDirection: isRtl,
                      ),
                    ),
                  ),
                  Obx(() => Switch(
                    value: Get.find<ThemeController>().isDark.value,
                    onChanged: (value) {
                      Get.find<ThemeController>().toggle();
                    },
                    activeColor: Theme.of(context).primaryColor,
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: isRtl,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: AutoSizeText(
                        "فارسی".tr,
                        style: const TextStyle(color: Colors.white),
                        textDirection: isRtl,
                      ),
                    ),
                  ),
                  Obx(() => Switch(
                    value: Get.find<TranslateController>().isEnglish.value,
                    onChanged: (value) {
                      Get.find<TranslateController>().changeLang(value ? 'en' : 'fa');
                    },
                    activeColor: Theme.of(context).primaryColor,
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}