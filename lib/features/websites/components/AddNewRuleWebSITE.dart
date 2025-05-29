import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/features/controllers/waf/WafWebsite.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';

class AddNewRuleWebsite extends StatelessWidget {
  final String websiteId; // Add websiteId as a required parameter
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final WafWebsiteController controller = Get.find<WafWebsiteController>();

  AddNewRuleWebsite({required this.websiteId}); // Constructor with websiteId

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return PageBuilder(sectionWidgets: [
      const SizedBox(height: 16),

      Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back, size: 25),
            ),
            const SizedBox(width: 20),
            Text(
              "Enter title of the rule:".tr,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: SizedBox(
                height: 60,
                child: TextField(
                  controller: titleController,
                  decoration:  InputDecoration(
                    hintText: "Type rule name...".tr,
                    fillColor: Color(0xFF404456),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 16),

      Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Content of the rule".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(15),
              ),
              child: DashboardTextfield(
                textEditingController: contentController,
                maxLines: 10,
                inputType: TextInputType.multiline,
              ),
            ),

            const SizedBox(height: 16),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                onPressed: () {
                  String title = titleController.text.trim();
                  String content = contentController.text.trim();
                  if (title.isNotEmpty && content.isNotEmpty) {
                    controller.createRule(websiteId, title, content); // Pass websiteId
                    Get.snackbar("Success".tr, "Rule added successfully".tr);
                    Get.back();
                  } else {
                    Get.snackbar("Error".tr, "Please fill in both fields".tr);
                  }
                },
                child:  Text("Save".tr, style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}