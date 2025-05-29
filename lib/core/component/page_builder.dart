import 'dart:ui'; // برای BackdropFilter
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/Header.dart';
import 'package:msf/core/component/SideBar.dart';
import 'package:msf/core/utills/responsive.dart';
import 'package:msf/core/utills/AnimatedWidgets/smokeAnim/smoke.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class PageBuilder extends StatefulWidget {
  final List<Widget> sectionWidgets;
  const PageBuilder({super.key, required this.sectionWidgets});

  @override
  State<PageBuilder> createState() => _PageBuilderState();
}

class _PageBuilderState extends State<PageBuilder> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final sideBar = const SideBar();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final glassColor = isDarkMode
        ? Colors.white.withOpacity(0.1)
        : Colors.white.withOpacity(0.3);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? const Drawer(
          child: SideBar(),
        )
            : null,
        body: Obx(() {
          if (themeController.isCinematic.value) {
            return Stack(
              children: [
                const SmokeHomeWidget(),
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: glassColor,
                        border: Border.all(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.01)
                              : Colors.black.withOpacity(0.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (Responsive.isDesktop(context))
                            Expanded(
                              child: sideBar,
                            ),
                          Expanded(
                            flex: 5,
                            child: SafeArea(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Header(scaffoldKey: scaffoldKey),
                                    const SizedBox(height: 16),
                                    ...widget.sectionWidgets,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  Expanded(
                    child: sideBar,
                  ),
                Expanded(
                  flex: 5,
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Header(scaffoldKey: scaffoldKey),
                          const SizedBox(height: 16),
                          ...widget.sectionWidgets,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}