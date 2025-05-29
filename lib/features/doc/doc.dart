import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/IdleController.dart';
import 'package:msf/core/utills/responsive.dart';
import 'components/sidebar.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/features/doc/screen/intro.dart';
import 'package:msf/features/doc/screen/setupscreen.dart';
import 'package:msf/features/doc/screen/controlpanelscreen.dart';
import 'package:msf/features/doc/screen/apirefrencescreen.dart';
import 'package:msf/features/doc/screen/developerthoughtsscreen.dart';
import 'components/Header.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';

class DocScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Menu_Controller menuController = Get.find<Menu_Controller>();
  final RxInt selectedScreen = 0.obs;

  DocScreen({super.key});

  Widget _getSelectedScreen() {
    switch (selectedScreen.value) {
      case 0:
        return const IntroScreen();
      case 1:
        return const SetupScreen();
      case 2:
        return const ControlPanelScreen();
      case 3:
        return const ApiReferenceScreen();
      case 4:
        return const DeveloperThoughtsScreen();
      default:
        return const IntroScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Get.find<IdleController>().onUserInteraction();
      },
      child: Scaffold(
        key: scaffoldKey,
        drawer: !Responsive.isDesktop(context)
            ? Drawer(child: const SideBar())
            : null,
        body: Column(
          children: [
            Header(scaffoldKey: scaffoldKey),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                textDirection: TextDirection.ltr, // ترتیب ویجت‌ها همیشه LTR
                children: [
                  if (Responsive.isDesktop(context))
                    Container(
                      width: screenWidth * 0.2,
                      child: const SideBar(),
                    ),
                  Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Obx(() => _getSelectedScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}