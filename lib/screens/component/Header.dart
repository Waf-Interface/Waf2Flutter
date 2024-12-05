import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:msf/controllers/dashboard/CounterController.dart';
import 'package:msf/utills/colorconfig.dart';
import 'package:msf/utills/responsive.dart';
import 'package:msf/controllers/settings/MenuController.dart';

class Header extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Menu_Controller menuController = Get.find<Menu_Controller>();

  Header({required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
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
            "Welcome Admin!".tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 1 : 2),
        Spacer(),
        GestureDetector(
          onTap: (){
            Get.toNamed("/doc");
          },
          child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: secondryColor),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.help),
                  SizedBox(width: 6,),
                  Text(
                    "doc".tr,
                  ),
                ]),
              )),
        ),
        SizedBox(width: 10),
        Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: secondryColor),
          child: Obx(
            () {
              return Center(
                child: Text(
                  "Time remaining:   ".tr + Get.find<Counter>().remainingSec,
                ),
              );
            },
          ),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(left: 16),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16 / 2,
          ),
          decoration: BoxDecoration(
            color: secondryColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white12),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_circle, size: 26),

              const Text("test"),
              SizedBox(width: 5,),
              PopupMenuButton<String>(
                color: secondryColor,
                onSelected: (value) {
                  if (value == 'logout'.tr) {
                    _showLogoutConfirmation();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'profile'.tr,
                      child: Text('Profile'.tr),
                    ),
                    PopupMenuItem<String>(
                      value: 'settings'.tr,
                      child: Text('Settings'.tr),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout'.tr,
                      child: Text('Logout'.tr),
                    ),
                  ];
                },
                icon: const Icon(Icons.arrow_drop_down_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: secondryColor,
        title: Text(
          "Logout".tr,
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to logout?".tr,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel".tr,
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("Confirm".tr),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}
