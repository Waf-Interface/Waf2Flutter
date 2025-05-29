import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/core/component/widgets/custom_iconbutton.dart';
import 'package:msf/core/component/widgets/dashboard_textfield.dart';
import 'package:msf/core/utills/_colorconfig.dart';
import 'package:msf/features/controllers/waf/WafWebsite.dart';

class ExpertConfigTab extends StatefulWidget {
  const ExpertConfigTab({super.key});

  @override
  State<ExpertConfigTab> createState() => _ExpertConfigTabState();
}

class _ExpertConfigTabState extends State<ExpertConfigTab> {
  late final WafWebsiteController wafController;
  TextEditingController nginxTextController = TextEditingController();
  TextEditingController modsecurityTextController = TextEditingController();
  final String websiteId = Get.arguments ?? '';

  @override
  void initState() {
    super.initState();
    wafController = Get.put(WafWebsiteController());
    _fetchConfigs();
  }

  @override
  void dispose() {
    nginxTextController.dispose();
    modsecurityTextController.dispose();
    super.dispose();
  }

  Future<void> _fetchConfigs() async {
    if (websiteId.isNotEmpty) {
      try {
        final nginxConfig = await wafController.getNginxConfig(websiteId);
        final modsecConfig = await wafController.getModsecMainConfig(websiteId);
        print('Nginx Config: $nginxConfig'); // Debug log
        print('Modsec Config: $modsecConfig'); // Debug log
        nginxTextController.text = nginxConfig.isEmpty ? 'No Nginx config available' : nginxConfig;
        modsecurityTextController.text = modsecConfig.isEmpty ? 'No ModSecurity config available' : modsecConfig;
      } catch (e) {
        print('Error fetching configs: $e'); // Debug log
      }
    } else {
      Get.snackbar(
        "Error",
        "No website ID provided",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  Future<void> _saveConfigs() async {
    if (websiteId.isNotEmpty) {
      final success = await wafController.updateNginxConfig(websiteId, nginxTextController.text);
      if (success) {
        await _fetchConfigs(); // Refresh the data after saving
        Get.snackbar(
          "Success",
          "Nginx configuration updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "No website ID provided",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          sectionMaker("Nginx Configuration", nginxTextController),
          const SizedBox(height: 15),
          sectionMaker("ModSecurity Configuration", modsecurityTextController),
          const SizedBox(height: 15),
          SizedBox(
            width: 100,
            child: wafController.isLoading.value
                ? const CircularProgressIndicator()
                : CustomIconbuttonWidget(
              backColor: primaryColor,
              onPressed: _saveConfigs,
              icon: Icons.save,
              title: "Save",
              titleColor: Colors.white,
              iconColor: Colors.white,
            ),
          ),
          const SizedBox(height: 15), // Extra padding at the bottom
        ],
      ),
    ));
  }

  Widget sectionMaker(String title, TextEditingController textController) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: DashboardTextfield(
              textEditingController: textController,
              maxLines: null, // Dynamic height
              minLines: 5, // Minimum height
              inputType: TextInputType.multiline,
            ),
          ),
        ],
      ),
    );
  }
}