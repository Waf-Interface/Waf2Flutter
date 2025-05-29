import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';
import 'package:msf/core/utills/ColorConfig.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final ThemeController themeController = Get.find<ThemeController>();
  final isDarkMode = Get.theme.brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return PageBuilder(
      sectionWidgets: [
        const Text("About"),
        const SizedBox(height: 16),
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Dear Reader",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                          "This waf interface that you dear, currently using it, its a flower from hardworking people who develop this interface for working easily with ModSecurity WAF in months.",
                          style: TextStyle(fontSize: 16),
                        ),
                          Text(
                            "Let me make it short,The purpose of this page is to respect the production team.",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "And of course you dear user.",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 25),
                          Text(
                            "Following is the list of developers, whom working on this waf interface:",
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• "),
                              Expanded(
                                child: Text(
                                  "Mortza Mansouri, Leader team , < Flutter / FastApi Developer > ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• "),
                              Expanded(
                                child: Text(
                                  "Mohammad Esmaili < Flutter Developer >",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 8),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "And dear helpers, whom help this project to grow, to experience :",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• "),
                              Expanded(
                                child: Text(
                                  "Ehsan Moradi < FastApi Developer >",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• "),
                              Expanded(
                                child: Text(
                                  "Erfan JasemZadeh < Flutter Developer >",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("• "),
                              Expanded(
                                child: Text(
                                  "Reza Mostofi < FastApi developer > ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
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
}