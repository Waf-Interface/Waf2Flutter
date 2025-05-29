import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msf/features/controllers/settings/TranslateController.dart';

class ControlPanelScreen extends StatelessWidget {
  const ControlPanelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isRtl = Get.find<TranslateController>().isEnglish.value ? TextDirection.ltr : TextDirection.rtl;

    return Directionality(
      textDirection: isRtl,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: isRtl == TextDirection.rtl ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                "Control Panel".tr,
                style: Theme.of(context).textTheme.headlineSmall,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "The Control Panel is the central hub for managing websites, configuring WAF settings, and monitoring logs.".tr,
                style: Theme.of(context).textTheme.bodyLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "Website Management".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "1. Access the Websites Dashboard via the Control Panel.\n2. Use the tabs:\n   - Websites Running: View active websites.\n   - Disabled Websites: View inactive websites.\n3. For each website:\n   - View Logs: Click the magnifying glass to see audit/debug logs.\n   - Edit: Click the edit icon to configure settings.\n   - Start/Stop: Use play/pause icons to toggle status.\n   - Delete: Click the delete icon and confirm.\n   - Mode: Select 'enabled' or 'disabled' from the dropdown.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),
              const SizedBox(height: 16),
              Text(
                "WAF Configuration".tr,
                style: Theme.of(context).textTheme.titleLarge,
                textDirection: isRtl,
              ),
              const SizedBox(height: 8),
              Text(
                "1. Select a website and go to the WAF Protection tab.\n2. Manage ModSecurity rules:\n   - Search: Filter rules by name.\n   - Create: Click 'Create New Rule', enter title/content, and save.\n   - Edit: Click 'Edit Rule' to modify content.\n   - Delete: Click the delete icon.\n   - Toggle: Enable/disable rules with the switch.\n3. Backup/Restore:\n   - Download: Save a backup of rules.\n   - Restore: Upload a backup file.\n4. Configure Exclusions:\n   - Local: Set exclusion paths, rule IDs, or attack names.\n   - Global: Set global rule exclusions.".tr,
                style: Theme.of(context).textTheme.bodyMedium,
                textDirection: isRtl,
              ),

            ],
          ),
        ),
      ),
    );
  }
}