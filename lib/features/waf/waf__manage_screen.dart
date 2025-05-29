import 'dart:ui'; // برای BackdropFilter
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';
import 'package:msf/features/dashboard/component/CircleChar.dart';
import 'package:msf/features/dashboard/component/RequestsBars.dart';
import 'package:msf/features/system/update/UpdateStatusWidget.dart';
import 'package:msf/features/waf/components/RadarChart.dart';
import 'package:msf/features/waf/components/WafConfig.dart';
import 'package:msf/features/waf/components/rulePlace.dart';
import 'components/SetSecRule.dart';

class WafManagerScreen extends StatefulWidget {
  const WafManagerScreen({super.key});

  @override
  State<WafManagerScreen> createState() => _ManageWafScreenState();
}

class _ManageWafScreenState extends State<WafManagerScreen> {
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final ThemeController themeController = Get.find<ThemeController>();
  final ScrollController scrollbarController = ScrollController();
  HttpService httpService = HttpService();

  @override
  void initState() {
    super.initState();
    final wafSetupController = WafSetupController();
    wafSetupController.setHttpService(httpService);
    Get.put(wafSetupController);
  }

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      sectionWidgets: [
        Responsive(
          mobile: Column(
            children: [
              WafActions,
              const SizedBox(height: 10),
              RequestsBars(),
              const SizedBox(height: 10),
              SetSecRule(),
              const SizedBox(height: 10),
              WafConfigWidget(),
              const SizedBox(height: 10),
              RulePlace(),
              const SizedBox(height: 10),
              RadarChartWidget(),
              const SizedBox(height: 10),
              UpdateStatusWidget(),
            ],
          ),
          tablet: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: WafActions),
                  const SizedBox(width: 10),
                  Expanded(flex: 3, child: RequestsBars()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: SetSecRule()),
                            const SizedBox(width: 10),
                            Expanded(flex: 2, child: WafConfigWidget()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RulePlace(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        RadarChartWidget(),
                        const SizedBox(height: 10),
                        UpdateStatusWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          desktop: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: WafActions),
                  const SizedBox(width: 10),
                  Expanded(flex: 3, child: RequestsBars()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 2, child: SetSecRule()),
                            const SizedBox(width: 10),
                            Expanded(flex: 1, child: WafConfigWidget()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RulePlace(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        RadarChartWidget(),
                        const SizedBox(height: 10),
                        UpdateStatusWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get WafActions {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: isCinematic
              ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
              : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
          child: Container(
            height: 350,
            padding: const EdgeInsets.all(16),
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
              color: Theme.of(context).colorScheme.onSecondary, // تم پیش‌فرض
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 AutoSizeText(
                  "Waf Actions".tr,
                  maxLines: 1,
                ),
                const SizedBox(height: 15),
                FutureBuilder<bool>(
                  future: httpService.checkModSecurityStatus(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircleChart(
                        circleColor: Colors.grey[500]!,
                        mainText: "Loading".tr,
                        subText: "Checking status...".tr,
                      );
                    } else if (snapshot.hasError) {
                      return CircleChart(
                        circleColor: Colors.redAccent,
                        mainText: "Error".tr,
                        subText: "Unable to get status".tr,
                      );
                    } else if (snapshot.hasData) {
                      bool isOn = snapshot.data!;
                      if (isOn) {
                        return CircleChart(
                          circleColor: Colors.greenAccent,
                          mainText: "Safe".tr,
                          subText: "WAF is ON!".tr,
                        );
                      } else {
                        return CircleChart(
                          circleColor: Colors.redAccent,
                          mainText: "Unsafe".tr,
                          subText: "WAF is OFF!".tr,
                        );
                      }
                    }
                    return CircleChart(
                      circleColor: Colors.grey[500]!,
                      mainText: "Loading".tr,
                      subText: "Checking status...".tr,
                    );
                  },
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIconbuttonWidget(
                        backColor: Colors.yellow[100]!,
                        iconColor: Colors.yellow[900]!,
                        titleColor: Colors.yellow[900]!,
                        title: "Check Confg".tr,
                        icon: Icons.check,
                        onPressed: () async {
                          bool status = await httpService.checkModSecurityStatus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(status ? "WAF is ON!".tr : "WAF is OFF!".tr),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      CustomIconbuttonWidget(
                        backColor: Colors.green[100]!,
                        iconColor: Colors.green[900]!,
                        titleColor: Colors.green[900]!,
                        title: "Start Engine".tr,
                        icon: Icons.play_arrow,
                        onPressed: () async {
                          bool result = await httpService.toggleModSecurity("on");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result
                                  ? "WAF started successfully!".tr
                                  : "Failed to start WAF".tr),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                      CustomIconbuttonWidget(
                        backColor: Colors.redAccent[100]!,
                        iconColor: Colors.red[900]!,
                        titleColor: Colors.red[900]!,
                        title: "Stop Engine".tr,
                        icon: Icons.stop,
                        onPressed: () async {
                          bool result = await httpService.toggleModSecurity("off".tr);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result
                                  ? "WAF stopped successfully!".tr
                                  : "Failed to stop WAF".tr),
                            ),
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}