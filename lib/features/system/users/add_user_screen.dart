import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/core/utills/ColorConfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/features/controllers/user/UserController.dart';
import 'package:msf/features/controllers/settings/ThemeController.dart';

class AddUserScreen extends StatelessWidget {
  const AddUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Menu_Controller menuController = Get.find<Menu_Controller>();
    final UserController userController = Get.find<UserController>();
    final TextEditingController firstNameTextcontroller = TextEditingController();
    final TextEditingController lastNameTextcontroller = TextEditingController();
    final TextEditingController emailTextcontroller = TextEditingController();
    final TextEditingController usernameTextcontroller = TextEditingController();
    final TextEditingController passwordTextcontroller = TextEditingController();
    final ThemeController themeController = Get.find<ThemeController>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return PageBuilder(
      sectionWidgets: [
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
                    SizedBox(
                      width: 100,
                      child: CustomIconbuttonWidget(
                        backColor: ColorConfig.primaryColor,
                        onPressed: () => Get.toNamed(AppRouter.userManagmentRoute),
                        title: "Go Back",
                        icon: Icons.arrow_back,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const AutoSizeText("First Name", maxLines: 1),
                    const SizedBox(height: 10),
                    DashboardTextfield(textEditingController: firstNameTextcontroller),
                    const SizedBox(height: 10),
                    const AutoSizeText("Last Name", maxLines: 1),
                    const SizedBox(height: 10),
                    DashboardTextfield(textEditingController: lastNameTextcontroller),
                    const SizedBox(height: 10),
                    const AutoSizeText("Email", maxLines: 1),
                    const SizedBox(height: 10),
                    DashboardTextfield(textEditingController: emailTextcontroller),
                    const SizedBox(height: 10),
                    const AutoSizeText("UserName", maxLines: 1),
                    const SizedBox(height: 10),
                    DashboardTextfield(textEditingController: usernameTextcontroller),
                    const SizedBox(height: 10),
                    const AutoSizeText("Password", maxLines: 1),
                    const SizedBox(height: 10),
                    DashboardTextfield(textEditingController: passwordTextcontroller),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 30,
                      width: 100,
                      child: Obx(() => CustomIconbuttonWidget(
                        backColor: ColorConfig.primaryColor,
                        onPressed: () {
                          if (!userController.isLoading.value) {
                            userController
                                .createUser(
                              username: usernameTextcontroller.text,
                              password: passwordTextcontroller.text,
                              firstName: firstNameTextcontroller.text,
                              lastName: lastNameTextcontroller.text,
                              email: emailTextcontroller.text,
                              rule: "user",
                            )
                                .then((_) {
                              if (userController.errorMessage.value.isEmpty) {
                                Get.back();
                              }
                            });
                          }
                        },
                        title: userController.isLoading.value ? "Submitting..." : "Submit",
                      )),
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