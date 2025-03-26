import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/core/router/app_router.dart';
import 'package:msf/core/utills/colorconfig.dart';
import 'package:msf/features/controllers/settings/MenuController.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/features/controllers/user/UserController.dart';
import 'package:msf/features/system/users/edit_user_screen.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Menu_Controller menuController = Get.find<Menu_Controller>();
    final UserController userController = Get.find<UserController>();
    final ScrollController scrollbarController = ScrollController();

    userController.onInit();

    return PageBuilder(
      sectionWidgets: [
        Row(
          children: [
            const Text("User Management"),
            const SizedBox(width: 16),
            CustomIconbuttonWidget(
              backColor: primaryColor,
              onPressed: () => Get.toNamed(AppRouter.addUserManagmentRoute),
              title: "Add User",
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Scrollbar(
            controller: scrollbarController,
            child: SingleChildScrollView(
              controller: scrollbarController,
              scrollDirection: Axis.horizontal,
              child: Obx(() => userController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : DataTable(
                columnSpacing: 20.0,
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      width: 25,
                      child: Text("ID", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 100,
                      child: Text("First Name", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: Text("Last Name", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 250,
                      child: Text("E-Mail", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: Text("Username", overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  DataColumn(
                    label: Tooltip(
                      message:
                      "You cannot create a user via root rule directly from the frontend. Please use the CLI tool on the server side. Thanks!",
                      child: SizedBox(
                        width: 100,
                        child: Text("Rule", overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                  DataColumn(label: SizedBox()),
                ],
                rows: userController.users.map((row) {
                  return DataRow(
                    cells: [
                      DataCell(Text(row["id"]?.toString() ?? 'N/A')),
                      DataCell(Text(row["first_name"] ?? 'N/A', overflow: TextOverflow.ellipsis)),
                      DataCell(Text(row["last_name"] ?? 'N/A', overflow: TextOverflow.ellipsis)),
                      DataCell(Text(row["email"] ?? 'N/A', overflow: TextOverflow.ellipsis)),
                      DataCell(Text(row["username"] ?? 'N/A', overflow: TextOverflow.ellipsis)),
                      DataCell(Text(row["rule"] ?? 'N/A', overflow: TextOverflow.ellipsis)),
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Row(
                            children: [
                              CustomIconbuttonWidget(
                                backColor: Colors.white10,
                                onPressed: () {},
                                icon: Icons.zoom_in,
                                title: "View",
                              ),
                              const SizedBox(width: 5),
                              CustomIconbuttonWidget(
                                backColor: Colors.white10,
                                onPressed: () {
                                  Get.to(() => EditUserScreen(user: row));
                                  },
                                icon: Icons.edit,
                                title: "Edit",
                              ),
                              const SizedBox(width: 5),
                              CustomIconbuttonWidget(
                                backColor: Colors.white10,
                                onPressed: () => userController.deleteUser(row["id"]),
                                icon: Icons.delete,
                                title: "Delete",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )),
            ),
          ),
        ),
      ],
    );
  }
}