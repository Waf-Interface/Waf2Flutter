import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/_colorconfig.dart';

class ManualExclusion extends StatefulWidget {
  const ManualExclusion({super.key});

  @override
  State<ManualExclusion> createState() => _ManualExclusionState();
}

class _ManualExclusionState extends State<ManualExclusion> {
  TextEditingController exclusionPathController = TextEditingController();
  TextEditingController ruleIdController = TextEditingController();
  TextEditingController attackNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Local rule exclusion",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildField(
                label: "Exclusion Path:",
                controller: exclusionPathController,
                hintText: "/some/resource.php",
              ),
              const SizedBox(height: 20),
              buildField(
                label: "Rule ID:",
                controller: ruleIdController,
                hintText: "9254463",
              ),
              const SizedBox(height: 20),
              buildField(
                label: "Attack Name:",
                controller: attackNameController,
                hintText: "Attack name",
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: Get.width / 5,
                child: CustomIconbuttonWidget(
                  backColor: Colors.blue,
                  title: "Save",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const Divider(
          color: primaryColor,
          thickness: 3,
        ),
        const SizedBox(height: 30),
        const Text("Global Exclusion"),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildField(
                label: "Rule ID:",
                controller: ruleIdController,
                hintText: "9254463",
              ),
              const SizedBox(height: 20),
              buildField(
                label: "Attack Name:",
                controller: attackNameController,
                hintText: "Attack name",
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: Get.width / 5,
                child: CustomIconbuttonWidget(
                  backColor: Colors.blue,
                  title: "Save",
                  onPressed: () {},
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        DashboardTextfield(
          textEditingController: controller,
          hintText: hintText,
          maxLength: 50,
        ),
      ],
    );
  }
}
