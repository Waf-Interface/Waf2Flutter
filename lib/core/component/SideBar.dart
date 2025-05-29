import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';
import 'package:get/get.dart';
import 'package:msf/core/utills/ColorConfig.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Map<int, bool> expansionTiles = {};

  void toggleExpansion(int index) {
    setState(() {
      expansionTiles[index] = !(expansionTiles[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;

      return Drawer(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: isCinematic
              ? BoxDecoration(
            color: ColorConfig.glassColor,
            border: Border.all(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.01)
                  : Colors.black.withOpacity(0.0),
            ),
          )
              : BoxDecoration(
            color: Theme.of(context).drawerTheme.backgroundColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.zero,
            child: BackdropFilter(
              filter: isCinematic
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 80),
                    Divider(color: Theme.of(context).dividerColor),
                    ListTile(
                      onTap: () {
                        Get.toNamed("/home");
                      },
                      leading: const Icon(Icons.speed_outlined,
                          color: Colors.white60),
                      title: AutoSizeText(
                        "Dashboard".tr,
                        maxLines: 1,
                        style:
                        TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Get.toNamed("/statics");
                      },
                      leading: const Icon(Icons.wifi_tethering,
                          color: Colors.white60),
                      title: AutoSizeText(
                        "Statistics".tr,
                        maxLines: 1,
                        style:
                        TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    ExpansionPanelList.radio(
                      initialOpenPanelValue: false,
                      materialGapSize: 5,
                      elevation: 0,
                      expansionCallback: (panelIndex, isExpanded) {
                        toggleExpansion(panelIndex);
                      },
                      children: [
                        expansionMaker(
                          0,
                          "Websites".tr,
                          Icons.web,
                          [
                            ListTile(
                              onTap: () {
                                Get.toNamed("/websites");
                              },
                              title: AutoSizeText(
                                "Websites".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () => Get.toNamed("/add_websites"),
                              leading:
                              const Icon(Icons.add, color: Colors.white60),
                              title: AutoSizeText(
                                "Add Website".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                        expansionMaker(
                          1,
                          "WAF".tr,
                          Icons.shield_outlined,
                          [
                            ListTile(
                              leading: const Icon(Icons.offline_bolt_outlined,
                                  color: Colors.white60),
                              onTap: () =>
                                  Get.toNamed(AppRouter.wafManagerScreen),
                              title: AutoSizeText(
                                "Waf Manager".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () => Get.toNamed(AppRouter.wafRuleScreen),
                              leading: const Icon(Icons.add_box,
                                  color: Colors.white60),
                              title: AutoSizeText(
                                "Rule Manager".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                        expansionMaker(
                          2,
                          "System".tr,
                          Icons.build,
                          [
                            ListTile(
                              onTap: () => Get.toNamed(AppRouter.systemRoute),
                              leading: const Icon(
                                Icons.route,
                                color: Colors.white60,
                                size: 20,
                              ),
                              title: AutoSizeText(
                                "Routes".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () =>
                                  Get.toNamed(AppRouter.activeConnectionRoute),
                              leading: const Icon(
                                Icons.connecting_airports_rounded,
                                color: Colors.white60,
                                size: 20,
                              ),
                              title: AutoSizeText(
                                "Active Connections".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            const SizedBox(height: 5),
                            ListTile(
                              onTap: () =>
                                  Get.toNamed(AppRouter.generalConfigurationRoute),
                              leading: const Icon(
                                Icons.build,
                                color: Colors.white60,
                                size: 20,
                              ),
                              title: AutoSizeText(
                                "General Configuration".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () =>
                                  Get.toNamed(AppRouter.userManagmentRoute),
                              leading: const Icon(
                                Icons.person,
                                color: Colors.white60,
                                size: 20,
                              ),
                              title: AutoSizeText(
                                "Users".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () => Get.toNamed(AppRouter.mediaRoute),
                              leading: const Icon(
                                Icons.info_outline_rounded,
                                color: Colors.white60,
                                size: 20,
                              ),
                              title: AutoSizeText(
                                "About".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                        expansionMaker(
                          3,
                          "Interfaces".tr,
                          Icons.public,
                          [
                            ListTile(
                              onTap: () {
                                Get.toNamed(AppRouter.addVirtualipRoute);
                              },
                              leading:
                              const Icon(Icons.add, color: Colors.white60),
                              title: AutoSizeText(
                                "Add virtual IP".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () =>
                                  Get.toNamed(AppRouter.manageVirtualipRoute),
                              leading: const Icon(Icons.build,
                                  color: Colors.white60),
                              title: AutoSizeText(
                                "List Virtual IPs".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                        expansionMaker(
                          4,
                          "System Log".tr,
                          Icons.padding,
                          [
                            ListTile(
                              onTap: () => Get.toNamed(AppRouter.WafLogRoute),
                              leading: const Icon(Icons.rocket_launch,
                                  color: Colors.white60),
                              title: AutoSizeText(
                                "Waf Log".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () => Get.toNamed(AppRouter.NginxLogRoute),
                              leading: const Icon(Icons.waterfall_chart,
                                  color: Colors.white60),
                              title: AutoSizeText(
                                "Nginx Log".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () =>
                                  Get.toNamed(AppRouter.userActionLogRoute),
                              leading:
                              const Icon(Icons.edit, color: Colors.white60),
                              title: AutoSizeText(
                                "User Actions Log".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                            ListTile(
                              onTap: () =>
                                  Get.toNamed(AppRouter.internalErrorLogRoute),
                              leading:
                              const Icon(Icons.close, color: Colors.white60),
                              title: AutoSizeText(
                                "Internal Error Logs".tr,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 500),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    //       child: AutoSizeText(
                    //         "Dark Mode".tr,
                    //         style: const TextStyle(color: Colors.white),
                    //       ),
                    //     ),
                    //     Switch(
                    //       value: themeController.isDark.value,
                    //       onChanged: (value) {
                    //         themeController.toggle();
                    //       },
                    //       activeColor: Theme.of(context).primaryColor,
                    //     ),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AutoSizeText(
                            "Cinematic Mode".tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Switch(
                          value: themeController.isCinematic.value,
                          onChanged: (value) {
                            themeController.toggleCinematicMode();
                          },
                          activeColor: Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: AutoSizeText(
                            "فارسی".tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Obx(() {
                          return Switch(
                            value: Get.find<TranslateController>().isEnglish.value,
                            onChanged: (value) {
                              Get.find<TranslateController>()
                                  .changeLang(value ? 'en' : 'fa');
                            },
                            activeColor: Theme.of(context).primaryColor,
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  ExpansionPanelRadio expansionMaker(
      int index, String title, IconData titleIcon, List<Widget> children) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ExpansionPanelRadio(
      value: index,
      canTapOnHeader: true,
      backgroundColor: Colors.transparent,
      headerBuilder: (context, isExpanded) {
        return ListTile(
          leading: Icon(titleIcon, color: Colors.white60),
          title: AutoSizeText(
            title,
            maxLines: 1,
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
      },
      body: Column(
        children: children.map((child) {
          return child is ListTile
              ? ListTile(
            onTap: child.onTap,
            leading: child.leading,
            title: child.title,
            tileColor: themeController.isCinematic.value
                ? ColorConfig.glassColor
                : null,
          )
              : child;
        }).toList(),
      ),
    );
  }
}