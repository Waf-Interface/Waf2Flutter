import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/services/unit/api/HttpService.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/features/dashboard/component/CircleChar.dart';
import 'package:msf/features/dashboard/component/RequestsBars.dart';
import 'package:msf/features/waf/components/RadarChart.dart';
import 'package:msf/features/waf/components/WafConfig.dart';
import 'package:msf/features/waf/components/rulePlace.dart';
import 'package:msf/core/utills/responsive.dart';
import 'components/SetSecRule.dart';

class WafManagerScreen extends StatefulWidget {
  const WafManagerScreen({super.key});

  @override
  State<WafManagerScreen> createState() => _ManageWafScreenState();
}

class _ManageWafScreenState extends State<WafManagerScreen> {
  final Menu_Controller menuController = Get.find<Menu_Controller>();
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
                            Expanded(flex: 2, child:  WafConfigWidget()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RulePlace(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: RadarChartWidget()),
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
                            Expanded(flex: 1, child:  WafConfigWidget()),
                          ],
                        ),
                        const SizedBox(height: 10),
                        RulePlace(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(flex: 1, child: RadarChartWidget()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get WafActions {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AutoSizeText(
            "Waf Actions",
            maxLines: 1,
          ),
          const SizedBox(height: 15),
          FutureBuilder<bool>(
            future: httpService.checkModSecurityStatus(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleChart(
                  circleColor: Colors.grey[500]!,
                  mainText: "Loading",
                  subText: "Checking status...",
                );
              } else if (snapshot.hasError) {
                return CircleChart(
                  circleColor: Colors.redAccent,
                  mainText: "Error",
                  subText: "Unable to get status",
                );
              } else if (snapshot.hasData) {
                bool isOn = snapshot.data!;
                if (isOn) {
                  return CircleChart(
                    circleColor: Colors.greenAccent,
                    mainText: "Safe",
                    subText: "WAF is ON!",
                  );
                } else {
                  return CircleChart(
                    circleColor: Colors.redAccent,
                    mainText: "Unsafe",
                    subText: "WAF is OFF!",
                  );
                }
              }
              return CircleChart(
                circleColor: Colors.grey[500]!,
                mainText: "Loading",
                subText: "Checking status...",
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
                  title: "Check Confg",
                  icon: Icons.check,
                  onPressed: () async {
                    bool status = await httpService.checkModSecurityStatus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(status ? "WAF is ON!" : "WAF is OFF!"),
                      ),
                    );
                    setState(() {});
                  },
                ),
                CustomIconbuttonWidget(
                  backColor: Colors.green[100]!,
                  iconColor: Colors.green[900]!,
                  titleColor: Colors.green[900]!,
                  title: "Start Engine",
                  icon: Icons.play_arrow,
                  onPressed: () async {
                    bool result = await httpService.toggleModSecurity("on");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result
                            ? "WAF started successfully!"
                            : "Failed to start WAF"),
                      ),
                    );
                    setState(() {});
                  },
                ),
                CustomIconbuttonWidget(
                  backColor: Colors.redAccent[100]!,
                  iconColor: Colors.red[900]!,
                  titleColor: Colors.red[900]!,
                  title: "Stop Engine",
                  icon: Icons.stop,
                  onPressed: () async {
                    bool result = await httpService.toggleModSecurity("off");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result
                            ? "WAF stopped successfully!"
                            : "Failed to stop WAF"),
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
    );
  }
}