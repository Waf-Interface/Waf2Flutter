import 'dart:io';

import 'package:flutter/material.dart';
import 'package:msf/core/bindings/bindings.dart';
import 'package:get/get.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

import 'package:msf/core/services/unit/api/config/Config.dart';
import 'package:msf/core/utills/theme.dart';
import 'package:msf/core/utills/translator.dart';

import 'core/services/unit/api/HttpService.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Config.loadConfig();
  Get.put(ThemeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isDark = Get.find<ThemeController>().isDark.value;

      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Translator(),
        initialBinding: MyBindings(),
        getPages: AppRouter.appPages,
        navigatorObservers: [
          GetObserver((_) {
            print('User route: ${Get.currentRoute}');
          })
        ],
        initialRoute: AppRouter.homeRoute,
        title: 'ModSec Admin Panel'.tr,
        theme: getTheme(isDark),
      );
    });
  }
}
