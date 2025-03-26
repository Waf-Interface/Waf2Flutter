import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/page_builder.dart';
import 'package:msf/features/controllers/waf/WafSetup.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';

class EditConfigScreen extends StatefulWidget {
  final String fileKey;

  const EditConfigScreen({required this.fileKey, super.key});

  @override
  State<EditConfigScreen> createState() => _EditConfigScreenState();
}

class _EditConfigScreenState extends State<EditConfigScreen> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  late final WafSetupController wafController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
    wafController = Get.find<WafSetupController>();

    // Fetch config file content when screen loads
    wafController.fetchConfigFile(widget.fileKey).then((_) {
      if (mounted) {
        setState(() {
          titleController.text = widget.fileKey;
          contentController.text = wafController.configFileContents[widget.fileKey] ?? '';
        });
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, size: 25),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Config File: ${widget.fileKey}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: TextField(
                        controller: titleController,
                        enabled: false,
                        decoration: const InputDecoration(
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
            // Main Content Section
            Expanded(
              child: Obx(() {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: wafController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Content of ${widget.fileKey}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 10),
                      // Text Editor taking full available height
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: TextField(
                            controller: contentController,
                            expands: true,   // Fills available space
                            maxLines: null,  // Must be null when expands is true
                            // minLines removed as it must be null when expands is true
                            keyboardType: TextInputType.multiline,
                            textAlignVertical: TextAlignVertical.top,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter your configuration here...",
                              hintStyle: TextStyle(color: Colors.grey),
                            ),
                            style: const TextStyle(
                              fontFamily: 'monospace', // Better for config files
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            onPressed: () async {
                              bool success = await wafController
                                  .restoreConfigFile(widget.fileKey);
                              if (success) {
                                Get.snackbar("Success",
                                    "${widget.fileKey} restored successfully");
                                wafController
                                    .fetchConfigFile(widget.fileKey)
                                    .then((_) {
                                  contentController.text = wafController
                                      .configFileContents[widget.fileKey] ??
                                      '';
                                });
                              } else {
                                Get.snackbar("Error",
                                    "Failed to restore ${widget.fileKey}");
                              }
                            },
                            icon: const Icon(Icons.restore, color: Colors.white),
                            label: const Text("Restore",
                                style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 12),
                            ),
                            onPressed: () async {
                              String content = contentController.text.trim();
                              if (content.isNotEmpty) {
                                bool success = await wafController
                                    .updateConfigFile(widget.fileKey, content);
                                if (success) {
                                  Get.snackbar("Success",
                                      "${widget.fileKey} updated successfully");
                                  Get.back();
                                } else {
                                  Get.snackbar("Error",
                                      "Failed to update ${widget.fileKey}");
                                }
                              } else {
                                Get.snackbar(
                                    "Error", "Content cannot be empty");
                              }
                            },
                            child: const Text("Save",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}