import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/features/controllers/user/UserController.dart';

class EditUserScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const EditUserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final Menu_Controller menuController = Get.find<Menu_Controller>();
    final UserController userController = Get.find<UserController>();

    final TextEditingController firstNameTextcontroller = TextEditingController(text: user['first_name'] ?? '');
    final TextEditingController lastNameTextcontroller = TextEditingController(text: user['last_name'] ?? '');
    final TextEditingController emailTextcontroller = TextEditingController(text: user['email'] ?? '');
    final TextEditingController usernameTextcontroller = TextEditingController(text: user['username'] ?? '');
    final TextEditingController passwordTextcontroller = TextEditingController(text: user['password'] ?? '');

    return PageBuilder(
      sectionWidgets: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: CustomIconbuttonWidget(
                  backColor: primaryColor,
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
                  backColor: primaryColor,
                  onPressed: () {
                    if (!userController.isLoading.value) {
                      userController
                          .updateUser(
                        userId: user['id'],
                        username: usernameTextcontroller.text,
                        password: passwordTextcontroller.text,
                        firstName: firstNameTextcontroller.text,
                        lastName: lastNameTextcontroller.text,
                        email: emailTextcontroller.text,
                        rule: user['rule'] ?? "user",
                      )
                          .then((_) {
                        if (userController.errorMessage.value.isEmpty) {
                          Get.back();
                        }
                      });
                    }
                  },
                  title: userController.isLoading.value ? "Updating..." : "Update",
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}