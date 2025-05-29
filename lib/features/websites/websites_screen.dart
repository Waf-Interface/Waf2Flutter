import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/helper/snackbar_helper.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/websites/website/websiteController.dart';
import 'package:msf/features/websites/components/data_column_tile.dart';
import 'package:msf/features/websites/components/data_row_tile.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class WebsitesScreen extends StatefulWidget {
  const WebsitesScreen({super.key});

  @override
  State<WebsitesScreen> createState() => _WebsitesScreenState();
}

class _WebsitesScreenState extends State<WebsitesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController scrollbarController = ScrollController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final WebsiteController websiteController = Get.find<WebsiteController>();
  int _selectedTabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
    websiteController.fetchWebsites();
  }

  @override
  void dispose() {
    _tabController.dispose();
    scrollbarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
        Obx(() {
          final isCinematic = themeController.isCinematic.value;
          if (websiteController.websites.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final activeWebsites = websiteController.websites.where((w) => w.status.value == 'Active').toList();
            final disabledWebsites = websiteController.websites.where((w) => w.status.value != 'Active').toList();

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
                    children: [
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicator: const BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              width: 2,
                              color: ColorConfig.primaryColor,
                            ),
                          ),
                        ),
                        tabAlignment: TabAlignment.start,
                        labelColor: Colors.white,
                        tabs: [
                          Tab(text: "${"Websites Running".tr} (${activeWebsites.length})"),
                          Tab(text: "${"Disable Websites".tr} (${disabledWebsites.length})"),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_selectedTabIndex == 0) ...[
                        SizedBox(
                          width: double.infinity,
                          child: Scrollbar(
                            controller: scrollbarController,
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              controller: scrollbarController,
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: DataTable(
                                  columnSpacing: 30,
                                  border: TableBorder.all(
                                    color: Colors.white,
                                    width: 0.07,
                                  ),
                                  columns: [
                                    DataColumnTile.buildRow(title: 'Name'),
                                    DataColumnTile.buildRow(title: 'Application'),
                                    DataColumnTile.buildRow(title: 'Listens to'),
                                    DataColumnTile.buildRow(title: 'Real web server'),
                                    DataColumnTile.buildRow(title: 'Logs'),
                                    DataColumnTile.buildRow(title: 'Status'),
                                    DataColumnTile.buildRow(title: 'Status Notes'),
                                    DataColumnTile.buildRow(title: 'Mode'),
                                    DataColumnTile.buildRow(title: 'Actions'),
                                  ],
                                  rows: activeWebsites.map((website) => DataRowTile.websiteRow(
                                    name: website.name,
                                    application: website.url,
                                    listenTo: website.listenTo ?? 'N/A',
                                    onListenTap: () =>
                                        Get.toNamed(AppRouter.editWebsiteRoute, arguments: website.url),
                                    realWebServer: website.realWebServer ?? 'N/A',
                                    onTapLog: () =>
                                        Get.toNamed(AppRouter.websiteLogRoute, arguments: website.url),
                                    status: website.status.value,
                                    statusNotes: website.status.value == 'Active' ? '' : website.status.value,
                                    mode: website.mode ?? 'disabled',
                                    onModeChanged: (newMode) {
                                      if (newMode != null) {
                                        website.mode = newMode;
                                        websiteController.update();
                                      }
                                    },
                                    onTapEdit: () {},
                                    onTapStart: () {
                                      SnackbarHelper().questionSnackbar(
                                        question: 'Disable website ${website.name}?',
                                        snackBarTitle: 'Website Started'.tr,
                                        snackBarMessage: 'Website ${website.name} has been started'.tr,
                                      );
                                    },
                                    onTapPause: () {},
                                    onTapDelete: () {
                                      SnackbarHelper().questionSnackbar(
                                        question: 'Are you sure to delete website ${website.name}?',
                                        snackBarTitle: 'Confirm Deletion',
                                        snackBarMessage: 'This action cannot be undone',
                                        onYes: () => websiteController.deleteWebsite(website),
                                      );
                                    },
                                  )).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else if (_selectedTabIndex == 1) ...[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            columnSpacing: 30,
                            border: TableBorder.all(
                              color: Colors.white,
                              width: 0.07,
                            ),
                            columns: [
                              DataColumnTile.buildRow(title: 'Name'),
                              DataColumnTile.buildRow(title: 'Application'),
                              DataColumnTile.buildRow(title: 'Listens to'),
                              DataColumnTile.buildRow(title: 'Real web server'),
                              DataColumnTile.buildRow(title: 'Logs'),
                              DataColumnTile.buildRow(title: 'Status'),
                              DataColumnTile.buildRow(title: 'Status Notes'),
                              DataColumnTile.buildRow(title: 'Mode'),
                              DataColumnTile.buildRow(title: 'Actions'),
                            ],
                            rows: disabledWebsites.map((website) => DataRowTile.websiteRow(
                              name: website.name,
                              application: website.url,
                              listenTo: website.listenTo ?? 'N/A',
                              onListenTap: () =>
                                  Get.toNamed(AppRouter.editWebsiteRoute, arguments: website.url),
                              realWebServer: website.realWebServer ?? 'N/A',
                              onTapLog: () => Get.toNamed(AppRouter.websiteLogRoute, arguments: website.url),
                              status: website.status.value,
                              statusNotes: website.status.value == 'Active' ? '' : website.status.value,
                              mode: website.mode ?? 'disabled',
                              onModeChanged: (newMode) {
                                if (newMode != null) {
                                  website.mode = newMode;
                                  websiteController.update();
                                }
                              },
                              onTapEdit: () {},
                              onTapStart: () {
                                SnackbarHelper().questionSnackbar(
                                  question: 'Disable website ${website.name}?',
                                  snackBarTitle: 'Website Started'.tr,
                                  snackBarMessage: 'Website ${website.name} has been started'.tr,
                                );
                              },
                              onTapPause: () {},
                              onTapDelete: () {
                                SnackbarHelper().questionSnackbar(
                                  question: 'Are you sure to delete website ${website.name}?',
                                  snackBarTitle: 'Confirm Deletion',
                                  snackBarMessage: 'This action cannot be undone',
                                  onYes: () => websiteController.deleteWebsite(website),
                                );
                              },
                            )).toList(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ],
    );
  }
}