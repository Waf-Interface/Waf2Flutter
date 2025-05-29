import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/websites/edit_tabs/debuglog_tab.dart';
import 'package:msf/features/websites/edit_tabs/expert_config_tab.dart';
import 'package:msf/features/websites/edit_tabs/http_tab.dart';
import 'package:msf/features/websites/edit_tabs/rewrite_tab.dart';
import 'package:msf/features/websites/edit_tabs/waf_protection_tab.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class EditWebsite extends StatefulWidget {
  const EditWebsite({super.key});

  @override
  State<EditWebsite> createState() => _EditWebsiteState();
}

class _EditWebsiteState extends State<EditWebsite> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController scrollbarController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final String title = Get.arguments ?? "";
  int _selectedTabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 6, vsync: this);
    super.initState();

    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    scrollbarController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
        if (title != "")
          Obx(() {
            final isCinematic = themeController.isCinematic.value;
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: isCinematic
                    ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                    : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  decoration: isCinematic
                      ? BoxDecoration(
                    color: ColorConfig.glassColor,
                    border: Border.all(
                      color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )
                      : BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(title),
                ),
              ),
            );
          }),
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: BackdropFilter(
              filter: isCinematic
                  ? ImageFilter.blur(sigmaX: 10, sigmaY: 10)
                  : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: isCinematic
                    ? BoxDecoration(
                  color: ColorConfig.glassColor,
                  border: Border.all(
                    color: isDarkMode ? Colors.white.withOpacity(0.01) : Colors.black.withOpacity(0.0),
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
                    Scrollbar(
                      controller: scrollbarController,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: scrollbarController,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TabBar(
                            controller: _tabController,
                            tabAlignment: TabAlignment.center,
                            isScrollable: true,
                            indicator: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 2,
                                  color: ColorConfig.primaryColor,
                                ),
                              ),
                            ),
                            labelColor: Colors.white,
                            tabs: [
                              tabMaker("WAF Protection", Icons.shield),
                              tabMaker("Logs", Icons.details),
                              tabMaker("Configuration", Icons.build_circle_outlined),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: _buildTabContent(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (_selectedTabIndex) {
      case 0:
        return WafProtectionTab();
      case 1:
        return const DebugLogTab();
      case 2:
        return const ExpertConfigTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Tab tabMaker(String title, IconData icon) => Tab(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 5),
        Text(title),
      ],
    ),
  );
}