import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/dashboard/CounterController.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/waf/WafController.dart';

class Header extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Menu_Controller menuController = Get.find<Menu_Controller>();

  Header({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final WafLogController controller = Get.find<WafLogController>();

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
        const Spacer(),
        GestureDetector(
          onTap: () {
            Get.toNamed("/doc");
          },
          child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: secondryColor),
              child: Center(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.help),
                      const SizedBox(width: 6),
                      Text("doc".tr),
                    ]),
              )),
        ),
        const SizedBox(width: 10),
        Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: secondryColor),
          child: Obx(() {
            return Center(
              child: Text(
                "Time remaining:   ".tr + Get.find<Counter>().remainingSec,
              ),
            );
          }),
        ),
        const SizedBox(width: 10),
        Container(
          width: 150,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondryColor,
          ),
          child: Obx(() {
            bool isOn = controller.modStatus.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isOn ? "WAF is ON".tr : "WAF is OFF".tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOn ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
              ],
            );
          }),
        ),
        const SizedBox(width: 10),
        Container(
          width: 45,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondryColor,
          ),
          child: Obx(() {
            bool isOn = controller.modStatus.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                  controller.refreshLogs();
                }, icon: Icon(Icons.refresh_outlined,  color: isOn ? Colors.greenAccent : Colors.redAccent,))
              ],
            );
          }),
        ),
        const SizedBox(width: 10),
        PopupMenuButton<String>(
          color: secondryColor,
          onSelected: (value) {
            if (value == 'logout'.tr) {
              _showLogoutConfirmation();
            }
          },
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'profile',
                child: Text('Profile'.tr),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Text('Settings'.tr),
              ),
              PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'.tr),
              ),
            ];
          },
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: secondryColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.account_circle,
                  size: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 8),
                AutoSizeText(
                  "test",
                  maxLines: 1,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showLogoutConfirmation() {
    Get.dialog(
      AlertDialog(
        backgroundColor: secondryColor,
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
