import 'dart:ui'; // برای BackdropFilter
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/features/controllers/websites/uploads/PendingWebsiteController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/core/utills/ColorConfig.dart';

class AddWebsiteScreen extends StatefulWidget {
  const AddWebsiteScreen({Key? key}) : super(key: key);

  @override
  _AddWebsiteScreenState createState() => _AddWebsiteScreenState();
}

class _AddWebsiteScreenState extends State<AddWebsiteScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PendingWebsiteController pendingController = Get.put(PendingWebsiteController());
  final TextEditingController applicationTextController = TextEditingController();
  final TextEditingController urlTextController = TextEditingController();
  final ScrollController scrollbarController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
        Responsive(
          mobile: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              addNewAppSection(context),
              const SizedBox(width: 10, height: 10),
              pendingAppSection,
            ],
          ),
          tablet: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: addNewAppSection(context)),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 3, child: pendingAppSection),
            ],
          ),
          desktop: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: addNewAppSection(context)),
              const SizedBox(width: 10, height: 10),
              Expanded(flex: 3, child: pendingAppSection),
            ],
          ),
        ),
      ],
    );
  }

  Widget addNewAppSection(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Size size = MediaQuery.of(context).size;

    return Obx(() {
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
                 AutoSizeText("Add New Application".tr, maxLines: 1),
                const SizedBox(height: 15),
                 AutoSizeText("Application Name".tr, maxLines: 1),
                const SizedBox(height: 5),
                DashboardTextfield(
                  textEditingController: applicationTextController,
                  hintText: "EX: Customer_name (without space)",
                ),
                const SizedBox(height: 10),
                 AutoSizeText("Application Url".tr, maxLines: 1),
                const SizedBox(height: 5),
                DashboardTextfield(
                  textEditingController: urlTextController,
                  hintText: "www.example.com",
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: size.width / 7,
                  child: CustomIconbuttonWidget(
                    icon: Icons.save_outlined,
                    backColor: Colors.blue,
                    title: "Save".tr,
                    onPressed: () {
                      String name = applicationTextController.text.trim();
                      String url = urlTextController.text.trim();
                      if (name.isEmpty || url.isEmpty) {
                        Get.snackbar("Error".tr, "Please fill in both fields.".tr);
                        return;
                      }
                      pendingController.addPendingWebsite(name, url);
                      applicationTextController.clear();
                      urlTextController.clear();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget get pendingAppSection {
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(Get.context!).brightness == Brightness.dark;

    return Obx(() {
      final isCinematic = themeController.isCinematic.value;
      if (pendingController.pendingWebsites.isEmpty) {
        return  Text("No pending applications.".tr);
      }

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
              color: Theme.of(Get.context!).colorScheme.onSecondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Scrollbar(
                controller: scrollbarController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: scrollbarController,
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         AutoSizeText(
                          "Applications Pending to Preview".tr,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 10),
                        DataTable(
                          columnSpacing: 30,
                          border: TableBorder.all(
                            color: Colors.white,
                            width: 0.07,
                          ),
                          columns:  [
                            DataColumn(label: Text('Name'.tr)),
                            DataColumn(label: Text('Application Url'.tr)),
                            DataColumn(label: Text('Status'.tr)),
                            DataColumn(label: Text('Actions'.tr)),
                          ],
                          rows: pendingController.pendingWebsites.map((website) {
                            return DataRow(
                              cells: [
                                DataCell(Text(website.name)),
                                DataCell(Text(website.url)),
                                DataCell(Obx(() => Text(website.deploymentStatus.value))),
                                DataCell(
                                  Row(
                                    children: [
                                      Tooltip(
                                        message: 'Upload this website to the server'.tr,
                                        child: IconButton(
                                          icon: const Icon(Icons.upload),
                                          onPressed: () {
                                            if (website.deploymentStatus.value == 'Waiting for zip') {
                                              pendingController.uploadZipFile(website, website.name);
                                            } else {
                                              Get.snackbar("Error".tr,
                                                  "Cannot upload. Current status: ${website.deploymentStatus.value}");
                                            }
                                          },
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Deploy this website to the server'.tr,
                                        child: IconButton(
                                          icon: const Icon(Icons.cloud_upload),
                                          onPressed: () {
                                            if (website.deploymentStatus.value == 'Deployed') {
                                              Get.snackbar("Error".tr, "This website is already deployed.".tr);
                                            } else if (website.deploymentStatus.value == 'Ready to deploy!'.tr) {
                                              pendingController.deployWebsite(website);
                                            } else {
                                              Get.snackbar("Error".tr,
                                                  "Cannot deploy. Current status: ${website.deploymentStatus.value}");
                                            }
                                          },
                                        ),
                                      ),
                                      Tooltip(
                                        message: 'Delete this website from the pending list'.tr,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            pendingController.removePendingWebsite(website);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}